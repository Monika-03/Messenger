
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Authenticate/databaseservice.dart';
import 'group_info.dart';
import 'message_tile.dart';
class Chatpage extends StatefulWidget {
  final String groupid;
  final String groupname;
  final String userName;
  const Chatpage({Key? key, required this.groupid, required this.groupname, required this.userName}) : super(key: key);

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  Stream<QuerySnapshot>? chats;
  String admin="";
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }
  getChatAndAdmin(){
    Databaseservice().getChats(widget.groupid).then((value){
      setState(() {
        chats = value;
      });
    });
    Databaseservice().getGroupAdmin(widget.groupid).then((value) {
      setState(() {
        admin = value;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
        elevation: 0,
        title: Text(widget.groupname),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder:(context){
              return Grp_info(
                groupId: widget.groupid,
                groupName: widget.groupname,
                adminName: admin,);
            }));
          }, icon: Icon(Icons.info))
        ],
      ),
      body: Stack(
       children: <Widget>[
         chatMessages(),
         Container(
           alignment: Alignment.bottomCenter,
           width: MediaQuery.of(context).size.width,
           child: Container(
             padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
             width: MediaQuery.of(context).size.width,
             color: Colors.grey.withOpacity(0.2),
             child: Row(
               children: [
                 Expanded(child: TextFormField(
                   controller: messageController,
                   style: TextStyle(
                     color: Colors.blueGrey
                   ),
                   decoration: InputDecoration(
                     hintText: "Send a message",
                     hintStyle: TextStyle(
                       color: Colors.blueGrey,
                       fontSize: 16,
                     ),
                     border: InputBorder.none,
                   ),
                 )),
                 
                 Container(
                   height: 50,
                   width: 50,
                   decoration: BoxDecoration(
                     color: Theme.of(context).primaryColor,
                     borderRadius: BorderRadius.circular(50)
                   ),
                   child: Center(child: IconButton(
                     onPressed: (){
                       sendMessage();
                     },
                     icon:Icon(Icons.send),color: Colors.white,),),
                 )

               ],
             ),
           ),
         )
       ],
      )
    );
  }
  chatMessages(){
    return StreamBuilder(
        stream: chats,
        builder: (context,AsyncSnapshot snapshot){
          return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context,index){
                return MessageTile(
                    grpid: widget.groupid,
                    id : snapshot.data.docs[index]['id'],
                    message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    sendByMe:widget.userName == snapshot.data.docs[index]['sender']);
              }) : Container();
        });

  }
  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String,dynamic> chatMessageMap={
        "message":messageController.text,
        "sender":widget.userName,
        "time":DateTime.now().millisecondsSinceEpoch,
        "id":""
      };
      Databaseservice().sendMessage(widget.groupid,chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }


}
