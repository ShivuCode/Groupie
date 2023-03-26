import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/Auth/register_page.dart';
import 'package:chat_app/service/AuthServices.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../../service/database_servise.dart';
import '../homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool isLoading=false;
  AuthService authService=AuthService();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: isLoading?const Center(child: CircularProgressIndicator(color: mainColor)):SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Groupie",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  height(15),
                  const Text(
                    "Login Now to see what they are talking",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  Image.asset("assets/img.png",
                      width: size.width * 0.9, height: size.height * 0.4),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email_outlined),
                        prefixIconColor: mainColor),
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val!)
                          ? null
                          : "Please enter a valid email";
                    },
                  ),
                  height(10),
                  TextFormField(
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(
                        labelText: "Password",
                        prefixIcon: const Icon(CupertinoIcons.lock),
                        prefixIconColor: mainColor),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    validator: (val) {
                      if (val!.length < 6) {
                        return "Password must be at least 6 characters";
                      } else {
                        return null;
                      }
                    },
                  ),
                  height(30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        onPressed: () {
                          login();
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                  ),
                  height(10),
                  Text.rich(TextSpan(
                      text: "Don't have Account? ",
                      style: const TextStyle(fontSize: 14),
                      children: [
                        TextSpan(
                            text: "Register here",
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontStyle: FontStyle.italic,
                                color: mainColor),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              nextScreen(context, const Register());
                            })
                      ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() async{
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading=true;
      });
      await authService.loginWithUserNameAndEmail(email, password).then((value)async{
        if(value==true){
          QuerySnapshot snapshot=await DatabaseService(uid:FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
          //saving the values to our sharedPreference
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmail(email);
          await HelperFunction.saveUserName(snapshot.docs[0]['Name']);
          // ignore: use_build_context_synchronously
          nextScreenReplace(context, const HomePage());

        }else{
          showSnackBar(context,Colors.red,value);
          setState(() {
            isLoading=false;
          });
        }
      });
    }
  }
}
