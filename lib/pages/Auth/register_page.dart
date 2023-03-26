import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/Auth/login.dart';
import 'package:chat_app/pages/homePage.dart';
import 'package:chat_app/service/AuthServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../widgets/widget.dart';
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String name="";
  bool isLoading=false;
  AuthService authService=AuthService();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: isLoading?const Center(child: CircularProgressIndicator(color: mainColor,)):SingleChildScrollView(
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
                  height(10),
                  const Text(
                    "Login Now to see what they are talking",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  Image.asset("assets/img2.png",
                      width: size.width * 0.9, height: size.height * 0.4),
                  height(10),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: "Username",
                        prefixIcon: const Icon(CupertinoIcons.person),
                        prefixIconColor: mainColor),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please Enter username";
                      } else {
                        return null;
                      }
                    },
                  ),
                  height(10),
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
                          r"^[a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z\d]+\.[a-zA-Z]+")
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
                  height(20),
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
                          register();
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                  ),
                  height(10),
                  Text.rich(TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(fontSize: 14),
                      children: [
                        TextSpan(
                            text: "Login here",
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontStyle: FontStyle.italic,
                                color: mainColor),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              nextScreen(context, const LoginPage());
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

  register() async{
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading=true;
      });
      await authService.registerUserWithEmailPassword(name, email, password).then((value)async{
        if(value==true){
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmail(email);
          await HelperFunction.saveUserName(name);
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
