import 'dart:async';

import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/homePage.dart';
import 'pages/Auth/login.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: mainColor,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark
    )
  );
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyAaDpZYgerzE_wBCvGYPmbWcLp6nql2kzU",
      projectId: "chat-app-f3371",
      messagingSenderId: "290377690544",
      appId: "1:290377690544:web:db659943b5dc53bfa33a75",
    ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: mainColor,
      ),
      home:const Splash(),
    );
  }
}
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _isSignedIn = false;
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  void getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
    Timer(const Duration(seconds: 2),(){
      if(_isSignedIn){
        nextScreenReplace(context, const HomePage());
      }else{
        nextScreenReplace(context, const LoginPage());
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Groupie",textAlign:TextAlign.center,style: TextStyle(fontSize: 100,color: Colors.white,fontWeight: FontWeight.bold),),
          Text("Developed by Shivu",textAlign: TextAlign.center,style: TextStyle(color: Colors.white54),)
        ],
    ),
      ),);
  }
}

