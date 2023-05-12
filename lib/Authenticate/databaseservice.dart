import 'package:cloud_firestore/cloud_firestore.dart';

class Databaseservice{
  final String? uid;

  Databaseservice({this.uid});

  //reference collection for firebase collections
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("groups");
 // final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");


  //updating the user data
  Future updateUserData(String fullname,String email) async{
    return await userCollection.doc(uid).set({
      "fullname": fullname,
      "email":email,
      "groups":[],
      "profilepic":"",
      "uid":uid

    }
    );

  }
  // getting user data
  Future gettingUserdata(String email)async{
    QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async{
    return userCollection.doc(uid).snapshots();
  }

  //creating group
  Future createGroup(String userName,String id,String grpName)async{
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": grpName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members" : FieldValue.arrayUnion(["${id}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userdocumentReference = await userCollection.doc(uid);
    return await userdocumentReference.update({
      "groups" : FieldValue.arrayUnion(["${groupDocumentReference.id}_$grpName"])
    });
  }
  //getting chats
  getChats(String groupid)async{
    return groupCollection.doc(groupid).
    collection("messages").
    orderBy("time").snapshots();
  }

  //get group admin
  Future getGroupAdmin(String groupid)async{
    DocumentReference d = groupCollection.doc(groupid);
    DocumentSnapshot snapshot =await d.get();
    return snapshot['admin'];
  }
  // get group members
 Future groupMembers(String groupid)async{
    return groupCollection.doc(groupid).snapshots();
 }
 // search group
 searchByName(String groupName){
    return groupCollection.where("groupName",isEqualTo: groupName).get();
 }

 //check if user is in group
 Future<bool> isUserJoined(String groupName,String groupId,String userName)async{
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot snapshot = await userDocumentReference.get();

    List<dynamic> groups = await snapshot['groups'];
    if(groups.contains("${groupId}_$groupName")){
      return true;
    }else{
      return false;
    }
 }

 //toggling the group join/exit
 Future toggleGroupJoin(String groupId,String userName,String groupName)async{
    DocumentReference userReferrence = userCollection.doc(uid);
    DocumentReference groupReferrence = groupCollection.doc(groupId);

    DocumentSnapshot snapshot = await userReferrence.get();
    List<dynamic> groups = await snapshot['groups'];

    if(groups.contains("${groupId}_$groupName")){
      await userReferrence.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupReferrence.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userReferrence.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupReferrence.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }

 }
  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    DocumentReference messageReference = await groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    await messageReference.update({
      "id": messageReference.id,
    });
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  //add note
  addNotes(String userid, Map<String, dynamic> chatMessageData) async {
    userCollection.doc(userid).collection("notes").add(chatMessageData);
  }

}