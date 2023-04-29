import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/global_variable.dart';

import '../utils/color.dart';


class SerachScreen extends StatefulWidget {
  const SerachScreen({Key? key}) : super(key: key);

  @override
  State<SerachScreen> createState() => _SerachScreenState();
}

class _SerachScreenState extends State<SerachScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(labelText: 'Search for a user'),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUser = true;
            });
          },
        ),
      ),

      body: isShowUser ? FutureBuilder(
        future: FirebaseFirestore.instance.collection('users')
            .where('username', isGreaterThanOrEqualTo: searchController.text)
            .get(),
        builder: (context , snapshot){
          if(!snapshot.hasData){
            return  const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: ( context, index ){
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                      builder: (context)=> ProfileScreen(
                          uid: (snapshot.data! as dynamic).docs[index]['uid']
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          (snapshot.data! as dynamic).docs[index]['photoUrl']
                      ),
                    ),
                    title: Text((snapshot.data! as dynamic).docs[index]['username']) ,
                  ),
                );
              },
          );
        },
      ) : FutureBuilder(
          future: FirebaseFirestore.instance.collection('posts').get() ,
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return StaggeredGridView.countBuilder(
              crossAxisCount: 3,
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context , index) => Image.network(
                  (snapshot.data! as dynamic).docs[index]['postUrl']
              ),
              staggeredTileBuilder: (index) => MediaQuery.of(context).size.width > webScreenSize ? StaggeredTile.count(
                  (index%7==0)? 1:1, (index%7==0)? 1:1) :  StaggeredTile.count(
                  (index%7==0)? 2:1, (index%7==0)? 2:1),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            );
          }
      ) ,
    );
  }
}
