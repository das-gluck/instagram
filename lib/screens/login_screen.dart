import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/color.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widget/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController() ;
  final TextEditingController _passwordController = TextEditingController() ;
  bool _isloading = false;

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async{
    setState(() {
      _isloading = true;
    });
    String res = await AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text );

    setState(() {
      _isloading = false;
    });
    if(res!='success'){
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

  void navigateToSignUp(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context) => const SignupScreen(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
            padding: MediaQuery.of(context).size.width > webScreenSize ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width /3 )
            : const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Container() , flex: 2,),
                //svg image
                SvgPicture.asset('assets/ic_instagram.svg', height: 64, color: primaryColor,),
                const SizedBox(height: 64),
                //text field for email
                TextFieldInput(
                  hintText: 'Enter Your Email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                ),

                const SizedBox(height: 24,),

                //text field for password
                TextFieldInput(
                  hintText: 'Enter Your Password',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true,
                ),

                const SizedBox(height: 24,),

                //button login
                InkWell(
                  onTap: loginUser,
                  child: Container(
                    child: _isloading? Center(
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
                      onTap: navigateToSignUp,
                      child: Container(
                        child: const Text(" Sign up." , style: TextStyle(fontWeight: FontWeight.bold ),),
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
