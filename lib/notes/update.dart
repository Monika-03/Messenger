import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Authenticate/databaseservice.dart';
import 'appStyle.dart';

class Update extends StatefulWidget {
  const Update({Key? key,}) : super(key: key);
  @override
  State<Update> createState() => _UpdateState();
}
class _UpdateState extends State<Update> {

  int colorid = Random().nextInt(AppStyle.cardsColor.length);
  String date = DateTime.now().toString();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _mainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[colorid],
      appBar: AppBar(backgroundColor: AppStyle.cardsColor[colorid],
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Add a new Note", style: TextStyle(color: Colors.black),),),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note Title',
                ),
                style: AppStyle.mainTitle,
              ),
              const SizedBox(height: 8.0,),
              Text(date, style: AppStyle.dateTitle,),
              const SizedBox(height: 28.0,),
              TextField(
                controller: _mainController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Note content'
                ),
                style: AppStyle.mainTitle,
              ),

            ],),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {

                Map<String,dynamic> notesMap={
              "note_title": _titleController.text,
              "creation_date": _titleController.text,
              "creation_date": date,
              "note_content": _mainController.text,
              "color_id": colorid
              };
                Databaseservice().addNotes(FirebaseAuth.instance.currentUser!.uid,notesMap).whenComplete(() {

            return Navigator.pop(context);
          }).catchError((error) {
            print("failed to add new notes due to $error");
          });
        },
        child: const Icon(Icons.save),
      ),

    );
  }

  
}