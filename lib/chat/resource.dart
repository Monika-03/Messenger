import 'package:flutter/material.dart';

void showSnack(context,color,message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message,style: const TextStyle(
        fontSize: 14
    ),),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(label:"ok", onPressed: () {  },textColor: Colors.white,),
  ));
}