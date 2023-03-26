import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/homePage.dart';
import 'package:chat_app/service/database_servise.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/widget.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo(
      {Key? key,
      required this.groupName,
      required this.groupId,
      required this.adminName})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMember(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Info"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: mainColor,
        actions: [
          IconButton(
              onPressed: () async {
                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("Leave Group"),
                        content: const Text("Are you sure you want to leave?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel")),
                          TextButton(onPressed: () {
                            DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).toggleGroupJoin(widget.groupId,getName(widget.adminName),widget.groupName).whenComplete(() {
                              nextScreenReplace(context,const HomePage());
                            });
                          }, child: const Text("Yes"))
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: mainColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: mainColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group: ${widget.groupName}",
                          style: const TextStyle(fontWeight: FontWeight.w400)),
                      height(5),
                      Text("Admin : ${getName(widget.adminName)}")
                    ],
                  )
                ],
              ),
            ),
            memberList()
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data["members"] != null) {
              if (snapshot.data["members"].length > 0) {
                return Expanded(
                  child: PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data["members"].length,
                      itemBuilder: (_, index) {
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: mainColor,
                            child: Text(
                              getName(snapshot.data["members"][index])
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          title: Text(
                            getName(snapshot.data["members"][index]),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            getId(snapshot.data["members"][index]),
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }),
                );
              } else {
                return const Center(
                  child: Text(
                    "No members",
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }
            } else {
              return const Center(
                child: Text("No members"),
              );
            }
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: mainColor,
            ));
          }
        });
  }
}
