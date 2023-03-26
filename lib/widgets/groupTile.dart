import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

import '../pages/chatPage.dart';

class GroupTile extends StatefulWidget {
  String userName;
  String groupId;
  String groupNAme;
  GroupTile(
      {Key? key,
      required this.userName,
      required this.groupId,
      required this.groupNAme})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        nextScreen(context, ChatPage(userName: widget.userName, groupId: widget.groupId, groupName: widget.groupNAme));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: mainColor,
            child: Text(widget.groupNAme.substring(0, 1).toUpperCase(),textAlign: TextAlign.center,
            style:const TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
          ),
          title:Text(widget.groupNAme,style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Join the conversation as ${widget.userName}",style: const TextStyle(fontSize: 13),),
        ),
      ),
    );
  }
}
