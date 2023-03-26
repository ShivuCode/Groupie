import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/Auth/login.dart';
import 'package:chat_app/pages/profilePage.dart';
import 'package:chat_app/pages/searchPage.dart';
import 'package:chat_app/service/AuthServices.dart';
import 'package:chat_app/service/database_servise.dart';
import 'package:chat_app/widgets/groupTile.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String email = "";
  String userName = "";
  Stream? groups;
  bool isLoading = false;
  String groupName = "";
  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String rs) {
    return rs.substring(rs.indexOf("_") + 1);
  }

  void gettingUserData() async {
    await HelperFunction.getUserEmailFromSf().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunction.getUserNameFromSf().then((value) {
      setState(() {
        userName = value!;
      });
    });
    //getting list of snapshot in our screen
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      groups = snapshot;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(CupertinoIcons.search))
        ],
        centerTitle: true,
        backgroundColor: mainColor,
        title: const Text(
          "Groupie",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
        ),
      ),
      drawer: Drawer(width: 200,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            const Icon(Icons.account_circle, color: Colors.grey, size: 150),
            height(10),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            height(30),
            const Divider(),
            ListTile(
              onTap: () {},
              selectedColor: mainColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(CupertinoIcons.group),
              title: const Text("Groups",
                  style: TextStyle(
                      fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: () {
                nextScreenReplace(
                    context, ProfilePage(userName: userName, userEmail: email));
              },
              selectedColor: mainColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(CupertinoIcons.profile_circled),
              title: const Text("Profile",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("LogOut"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel")),
                          TextButton(onPressed: () {
                            authService.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (_) => const LoginPage()),
                                    (route) => false);
                          }, child: const Text("Yes"))
                        ],
                      );
                    });
              },
              selectedColor: mainColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text("LogOut",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
            ),
            ListTile(
              leading:const Icon(Icons.info_outline),
              title: const Text("Info"),
              trailing: InkWell(
                onTap: (){
                  showDialog(barrierDismissible:true,context: context, builder: (_){
                    return const AboutDialog(
                      applicationName: "Groupie",
                      applicationVersion: "1.2",
                      children: [
                        Text("Developed by Shivani Bind"),
                        Text("Its Small Chatting App with friends or family or make community. Its easy to use and understand anyone can understand this app and use it.")
                      ],
                    );
                  });
                },
              ),
            )
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: mainColor,
        child: const Icon(CupertinoIcons.add, color: Colors.white),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Create a group", textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: mainColor))
                    : TextField(
                        onChanged: (value) {
                          setState(() {
                            groupName = value;
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: mainColor),
                              borderRadius: BorderRadius.circular(15)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: mainColor),
                              borderRadius: BorderRadius.circular(15)),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: mainColor),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      )
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                child: const Text(" Cancel "),
              ),
              width(10),
              ElevatedButton(
                onPressed: () async {
                  if (groupName.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .createGroup(userName,
                            FirebaseAuth.instance.currentUser!.uid, groupName)
                        .whenComplete(() {
                      setState(() {
                        isLoading = false;
                      });
                    });
                    Navigator.of(context).pop();
                    showSnackBar(
                        context, Colors.green, "Group created successfully");
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                child: const Text(" Create "),
              ),
            ],
          );
        });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (_, AsyncSnapshot snapshot) {
        //make some change
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (_, index) {

                    int reverseIndex=snapshot.data['groups'].length-index-1;
                    return GroupTile(
                        userName: userName,
                        groupId: getId(snapshot.data['groups'][reverseIndex]),
                        groupNAme: getName(snapshot.data['groups'][reverseIndex]));
                  });
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return const Center(
              child: CircularProgressIndicator(
                color: mainColor,
              )
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: const Center(
            child: Text(
          "You've not joined any groups, tap on the add icon to create a group or also search from tap searh button",
          textAlign: TextAlign.center,
        )));
  }
}
