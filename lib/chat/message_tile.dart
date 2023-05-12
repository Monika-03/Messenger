
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/chat/resource.dart';
class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sendByMe;
  final String id;
  final String grpid;


  const MessageTile({Key? key, required this.message, required this.sender, required this.sendByMe, required this.id, required this.grpid}) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async{
         widget.sendByMe ? showDialog(
            barrierDismissible: false,
            context: context, builder: (context){
          return AlertDialog(
            content: const Text("Are you sure you want to delete?"),
            title: const Text("Delete"),
            actions: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: const Icon(Icons.cancel,color: Colors.red,)),
              IconButton(onPressed: () async {
                try{
                  await
                  FirebaseFirestore.instance.collection("groups").
                  doc(widget.grpid).
                  collection("messages").doc(widget.id).delete().whenComplete((){
                    showSnack(context, Colors.green,"Message deleted successfully");
                    return Navigator.pop(context);
                  });
                } on FirebaseAuthException catch(e){
                  showSnack(context, Colors.red,e.message);
                }
              }, icon: const Icon(Icons.done,color: Colors.green,))
            ],
          );
        }) :
         showDialog(
             barrierDismissible: false,
             context: context, builder: (context){
           return AlertDialog(
             content: Text("This Message was sent by ${widget.sender} , you can't delete it"),
             title: const Text("Info"),
             actions: [
               ElevatedButton(onPressed: (){
                 Navigator.pop(context);
               }, child: const Text("exit"),

               )],
           );
         });

      },
      child: Container(
        padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sendByMe ? 0:24,
          right: widget.sendByMe ? 24:0,
        ),
        alignment: widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: widget.sendByMe ? const EdgeInsets.only(left: 30,) : const EdgeInsets.only(right: 30,),
          padding: const EdgeInsets.only(top: 17,bottom: 17,left: 20,right: 20),
          decoration: BoxDecoration(
            borderRadius: widget.sendByMe ? BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)
            ),
            color: widget.sendByMe?Theme.of(context).primaryColor : Colors.grey.withOpacity(0.2)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.sender.toUpperCase(),
                textAlign: TextAlign.center,
                 style: TextStyle(
                   fontSize: 13,
                   fontWeight: FontWeight.bold,
                   color: widget.sendByMe ? Colors.white : Theme.of(context).primaryColor,
                   letterSpacing: -0.5
                 ),),
              SizedBox(height: 8,),
              Text(widget.message,
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     fontSize: 16,
                     color: widget.sendByMe ? Colors.white : Theme.of(context).primaryColor,
                   ),)
            ],
          ),
        ),
      ),
    );
  }
}
