
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../chat/resource.dart';
class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Receive an mail to",textAlign: TextAlign.center,style: TextStyle(
              fontSize: 20
            ),),
            Text("reset your Password",textAlign: TextAlign.center,style: TextStyle(
              fontSize: 20
            ),),
            SizedBox(
              height: 20,
            ),
            Form(
              key: formkey,
              child: TextFormField(
                validator: (value){
                  if(!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)){
                    return'Please Enter the valid email';
                  }
                  return null;
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
            ),
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
                    onPressed: ()async{
                      if(formkey.currentState!.validate()){
                        modify();
                      }
                    }, child: const Text("RESET PASSWORD"))
            ),
          ],
        ),
      ),
    );
  }
  Future modify()async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text.trim()).whenComplete((){
        showSnack(context, Colors.green, "Reset email sent");
        return Navigator.pop(context);
      });
    } on FirebaseAuthException catch(e){
      showSnack(context, Colors.red,e.message);
    }
  }
}
