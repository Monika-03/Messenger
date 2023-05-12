
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/verification/register.dart';
import 'package:messanger/verification/resetPassword.dart';

import '../Authenticate/auth.dart';
import '../Authenticate/databaseservice.dart';
import '../chat/helperfun.dart';
import '../chat/home.dart';
import '../chat/resource.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _visible = true;
  bool _isloading = false;
  AuthService authService = AuthService();
  String emailid ="";
  String pass = "";
  final _formkey = GlobalKey<FormState>();
  TextEditingController email =TextEditingController(text: "");
  TextEditingController password =TextEditingController(text: "");
  void login() async {
    if(_formkey.currentState!.validate()){
      setState(() {
        _isloading = true;
      });
      await authService.loginUserWithEmailandPassword(emailid,pass).
      then((value)async{
        if(value == true){
          QuerySnapshot snapshot = await Databaseservice(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserdata(emailid);
          // saving values to share preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(emailid);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullname']);
          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
            return const Home();
          }));
        }else{
          showSnack(context, Colors.red,value);
          setState(() {
            _isloading = false;
          });
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  _isloading? Center(child: CircularProgressIndicator(color:Theme.of(context).primaryColor,)):SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Center(child: Image.asset("images/login.png",colorBlendMode: BlendMode.dstATop,width: 300,height: 300,)),
                Form(
                    key: _formkey,
                    child:Column(
                  children: [
                    TextFormField(
                      validator: (value){
                        if(!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)){
                          return'Please Enter the valid email';
                        }
                        return null;
                      },
                      onChanged: (val){
                        setState(() {
                          emailid=val;
                        });
                      },
                      controller: email,
                      decoration: InputDecoration(
                         prefixIcon: Icon(Icons.email,color:Theme.of(context).primaryColor,),
                          labelText: "Email",
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide:  BorderSide(color:Theme.of(context).primaryColor,
                          width: 2.0)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide:  BorderSide(color:Theme.of(context).primaryColor,
                              width: 2.0)
                      ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                            borderSide: const BorderSide(color: Colors.redAccent,
                                width: 2.0)
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: const BorderSide(color: Colors.redAccent,
                                width: 2.0)
                        ),

                      ),

                    ),
                    const SizedBox(height:10),
                    TextFormField(
                      controller: password,
                      obscureText: _visible,
                      validator: (value){
                        if(value!.length < 6){
                          return 'Password must be atleast 6 characters';
                        }
                        return null;
                      },
                      onChanged: (val){
                        pass=val;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock,color:Theme.of(context).primaryColor,),
                        suffixIcon: IconButton(onPressed:(){
                          setState(() {
                            _visible =!_visible;
                          });
                          },icon:Icon(Icons.remove_red_eye_rounded,color:Theme.of(context).primaryColor)),
                        labelText: "Password",
                        labelStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide(color:Theme.of(context).primaryColor,
                                width: 2.0)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor,
                                width: 2.0)
                        ),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: const BorderSide(color: Colors.redAccent,
                                width: 2.0)
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: const BorderSide(color: Colors.redAccent,
                                width: 2.0)
                        ),

                      ),

                    ),]
                )),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child:ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                )
                            ),
                            onPressed: (){
                             login();
                            }, child: const Text("login"))
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          onPressed: (){
                             Navigator.push(context,MaterialPageRoute(builder: (context){
                              return ResetPassword();
                            }));
                          },
                          child: Text("Forgot Password?",style: TextStyle(
                        color: Theme.of(context).primaryColor
                      ),)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return const Register();
                            }));
                          }, child:  Text("Register here",style: TextStyle(
                            color:Theme.of(context).primaryColor
                          ),))
                        ],
                      ),
                    ),

                  ],

    ),
          ),
        ),
      ),
    );
  }
}
