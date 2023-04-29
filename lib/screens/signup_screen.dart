import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/color.dart';
import '../utils/utils.dart';
import '../widget/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController() ;
  final TextEditingController _passwordController = TextEditingController() ;
  final TextEditingController _bioController = TextEditingController() ;
  final TextEditingController _usernameController = TextEditingController() ;
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async{
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async{
    setState(() {
      _isLoading = true;
    });
    String res =  await AuthMethods().signUpUser(
      email:_emailController.text ,
      password: _passwordController.text ,
      username:_usernameController.text,
      bio: _bioController.text,
      file:_image! ,
    );
    // print(res);

    setState(() {
      _isLoading = false;
    });
    if(res != 'success'){
      showSnackBar(res, context);
    }else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:(context) => const ResponsiveLayout(
             mobileScreenLayout: MobileScreenLayout(),
             webScreenLayout: WebScreenLayout() ,
           ),
         ),
      );

    }

  }

  void navigateToLogin(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context) => const LoginScreen(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container() , flex: 2,),
              //svg image
              SvgPicture.asset('assets/ic_instagram.svg', height: 64, color: primaryColor,),
              const SizedBox(height: 64),

              // circular widget to accept and show our selected file
              // image
              Stack(
                children: [
                  _image!=null? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                   )
                 : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/2048px-Windows_10_Default_Profile_Picture.svg.png'),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 24,),


              //text field for username
              TextFieldInput(
                hintText: 'Enter Your Username',
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),
              const SizedBox(height: 24,),


              //text field for email
              TextFieldInput(
                hintText: 'Enter Your Email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(height: 24,),


              //text feild for password
              TextFieldInput(
                hintText: 'Enter Your Password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(height: 24,),


              //text field for bio
              TextFieldInput(
                hintText: 'Enter Your bio',
                textInputType: TextInputType.text,
                textEditingController: _bioController,
              ),
              const SizedBox(height: 24,),


              //button login
              InkWell(
                onTap: signUpUser,
                child: Container(
                  child: _isLoading? Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                      : const Text('Log in'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4),
                          )
                      ),
                      color: blueColor
                  ),
                ),
              ),
              const SizedBox(height: 12,),
              Flexible(child: Container() , flex: 2,),


              //transitioning to sign-up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("Don't have an account? "),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      child: const Text(" Login." , style: TextStyle(fontWeight: FontWeight.bold ),),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
