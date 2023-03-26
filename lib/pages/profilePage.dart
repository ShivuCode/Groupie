import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/homePage.dart';
import 'package:chat_app/service/AuthServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/widget.dart';
import 'Auth/login.dart';
// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  String userName;
  String userEmail;
  ProfilePage({Key? key,required this.userName,required this.userEmail}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService=AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        title: const Text("Profile",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 27)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 40),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(backgroundColor: mainColor,radius: 100,child: Text(widget.userName.substring(0, 1).toUpperCase(),style:const TextStyle(
                fontSize: 120,color: Colors.white
              ),)),
              height(30),
              Text(widget.userName.substring(0,1).toUpperCase()+widget.userName.substring(1).toUpperCase(),style:const TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
              height(15),
              Text(widget.userEmail,style: const TextStyle(fontWeight: FontWeight.w500,color: Colors.black54,fontSize: 14)),

            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical:20),
          children: [
            const Icon(Icons.account_circle,color: Colors.grey,size: 150),
            height(10),
            Text(widget.userName,textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.bold),),
            height(30),
            const Divider(),
            ListTile(
              onTap: (){
                nextScreen(context, const HomePage());
              },
              selectedColor: mainColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(CupertinoIcons.group),
              title: const Text("Groups",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
            ),
            ListTile(
              onTap: (){},
              selectedColor: mainColor,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(CupertinoIcons.profile_circled),
              title: const Text("Profile",style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: ()async{
                showDialog(barrierDismissible:true,context: context, builder: (_){
                  return AlertDialog(
                    title: const Text("LogOut"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(onPressed: (){
                        authService.signOut();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>const LoginPage()), (route) => false);
                      }, child: const Text("Cancel")),
                      TextButton(onPressed: (){}, child: const Text("Yes"))
                    ],
                  );
                });
              },
              selectedColor: mainColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text("LogOut",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
