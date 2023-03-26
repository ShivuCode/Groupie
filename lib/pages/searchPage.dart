import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/chatPage.dart';
import 'package:chat_app/service/database_servise.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;
  bool isJoined = false;

  @override
  void initState() {
    getCurrentUserIdAndName();
    super.initState();
  }

  String getName(String res) {
    return res.substring(res.indexOf(".") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  getCurrentUserIdAndName() async {
    await HelperFunction.getUserNameFromSf().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Search"),
        backgroundColor: mainColor,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                border: Border.all(color: mainColor),
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color:mainColor, fontSize: 16),
                          hintText: "Search groups.......",
                        ))),
                GestureDetector(
                  onTap: () {
                    initiateSearchState();
                  },
                  child: const Icon(Icons.search, color: mainColor),
                )
              ],
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator(color: mainColor))
              : groupList()
        ],
      ),
    );
  }

  initiateSearchState() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService().searchByName(searchController.text).then((val) {
        setState(() {
          searchSnapshot = val;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? Expanded(
            child: searchSnapshot!.docs.length!=0?ListView.builder(
                itemCount: searchSnapshot!.docs.length,
                itemBuilder: (_, index) {
                  return groupTile(
                      userName,
                      searchSnapshot!.docs[index]['groupId'],
                      searchSnapshot!.docs[index]['groupName'],
                      searchSnapshot!.docs[index]['admin']);
                }):Center(child: Text("No Data founded"))
          )
        :Container();
  }
  joinOrNot(String userName, String gN, String gI, String ad) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoin(gN, gI, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    //function to check already exist in group
    joinOrNot(userName, groupName, groupId, admin);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: mainColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
          onTap: () async {
            await DatabaseService(uid: user!.uid).toggleGroupJoin(groupId, userName, groupName);
              if(isJoined){
                setState(() {
                  isJoined=!isJoined;
                });
                showSnackBar(context, Colors.red, "Successfully joined the group");
                Future.delayed(const Duration(seconds: 2),(){
                  nextScreen(context, ChatPage(userName: userName, groupId: groupId, groupName: groupName));
                });
              }else{
                setState(() {
                  isJoined=!isJoined;
                });
                showSnackBar(context,Colors.red, "Left the group $groupName");
              }
            },
          child: isJoined
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      border: Border.all(color: Colors.white, width: 1)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text(
                    "Joined",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: mainColor,
                      border: Border.all(color: Colors.white, width: 1)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text(
                    "Join Now",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
    );
  }
}
