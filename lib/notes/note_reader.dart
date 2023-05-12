
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'appStyle.dart';
class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen(this.doc,{Key? key}) : super(key: key);
QueryDocumentSnapshot doc;
  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {

  @override
  Widget build(BuildContext context) {
    String id=widget.doc.id;
    String userid = FirebaseAuth.instance.currentUser!.uid;
    int color_id=widget.doc['color_id'];
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.doc["note_title"],style: AppStyle.mainTitle,),
          SizedBox(height: 4.0,),
          Text(widget.doc["creation_date"],style: AppStyle.dateTitle,),
          SizedBox(height: 28.0,),
          Text(widget.doc["note_content"],style: AppStyle.mainContent,
            overflow: TextOverflow.ellipsis,),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
                onPressed: ()async{
                  await
                    FirebaseFirestore.instance.collection("users").doc(userid).collection("notes").doc(id).delete().whenComplete(() {
                      return Navigator.pop(context);
                    });
                },
                child: Text("DELETE")),
          )
        ],
    ),
      ),
    );
  }
}
