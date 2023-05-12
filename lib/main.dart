import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:messanger/todo/todos.dart';
import 'package:messanger/verification/login.dart';
import 'package:provider/provider.dart';

import 'chat/helperfun.dart';
import 'chat/home.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _signedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }
  getUserLoggedInStatus() async{
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if(value != null){
        setState(() {
          _signedIn=value;
        });
      }
    });

  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => TodosProvider(),
    child:
    MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primaryColor: const Color(0xff20b3dc)
        ),
        home: Scaffold(
          body: AnimatedSplashScreen(splash: Container(
              child: Lottie.asset("images/smart-phone.json")
          ),
              nextScreen: _signedIn ? const Home():const Login()),
        )
    )
  );
}










