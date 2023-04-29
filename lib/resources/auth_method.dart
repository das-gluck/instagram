import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storage_method.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async{
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser!.uid).get();
    return model.User.fromSnap(snap);
  }


  // sign up user
  Future<String> signUpUser ({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
})async {
    String res = "Some error occured";
    try {
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty || file!=null )
        {
          // register the user
         UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

         String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

         // add user to database

         model.User user = model.User(
             email: email,
             uid: cred.user!.uid,
             photoUrl: photoUrl,
             username: username,
             bio: bio,
             followers: [],
             following: [],
         );

          await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
          res = "Success";
        }
    } catch(err){
      res = err.toString();
    }
    return res;
}

  // login User
  Future<String> loginUser({
    required String email ,
    required String password
}) async {
    String res = "Some error has occurred";

    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      }else{
        res = "Please enter all details";
      }
    }catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async{
    await _auth.signOut();
  }





}