import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
//saving user data
  Future savingUserData(String name, String email) async {
    return userCollection.doc(uid).set({
      "Name": name,
      "email": email,
      "groups": [],
      "profilePic": "",
      "user": uid
    });
  }

  //getting userData
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //get users group
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

//creating a group
  Future createGroup(String username, String id, String groupName) async {
    DocumentReference documentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$username",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    //update the members
    await documentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$username}"]),
      "groupId": documentReference.id
    });
    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${documentReference.id}_$groupName"])
    });
  }

  //getting chat
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }
  //get group admin
Future getGroupAdmin(String groupId)async{
    DocumentReference documentReference=groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot=await documentReference.get();
    return documentSnapshot["admin"];
}
//get group members
getGroupMember(String groupId)async{
    return groupCollection.doc(groupId).snapshots();
}
//search
searchByName(String groupName){
    return groupCollection.where("groupName",isEqualTo:groupName).get();
}
//function-bool
Future<bool> isUserJoin(String groupName,String groupId,String userName)async{
    DocumentReference df=userCollection.doc(uid);
    DocumentSnapshot documentSnapshot=await df.get();

    List<dynamic> groups=await documentSnapshot['groups'];
    if(groups.contains("${groupId}_$groupName")){
      return true;
    }else{
      return false;
    }
}
//toggling the group
  Future toggleGroupJoin(String groupId,String userName,String groupName)async{
    //doc reference
    DocumentReference userDocumentReference=userCollection.doc(uid);
    DocumentReference groupDocumentReference=groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot=await userDocumentReference.get();
    if(documentSnapshot.exists) {
      List<dynamic> groups=await documentSnapshot["groups"];
      //if user exist then remove them and its not in group then add them
      if(groups.contains("${groupId}_$groupName")){
        await userDocumentReference.update({
          "groups":FieldValue.arrayRemove(["${groupId}_$groupName"])
        });
        await groupDocumentReference.update({
          "members":FieldValue.arrayRemove(["${uid}_$userName"])
        });
      }else{
        await userDocumentReference.update({
          "groups":FieldValue.arrayUnion(["${groupId}_$groupName"])
        });
        await groupDocumentReference.update({
          "members":FieldValue.arrayUnion(["${uid}_$userName"])
        });
      }
    } else {
      print("User document does not exist for uid $uid");
      // handle the case where the document does not exist
    }
  }
//function for send message
sendMessage(String groupId,Map<String ,dynamic> chatMessageData)async{
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage":chatMessageData["message"],
      "recentMessageSender":chatMessageData["sender"],
      "recentMessageTime":chatMessageData["time"].toString()
    });
}
}
