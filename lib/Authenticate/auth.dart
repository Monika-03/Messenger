
import 'package:firebase_auth/firebase_auth.dart';

import '../chat/helperfun.dart';
import 'databaseservice.dart';

class AuthService{
  final FirebaseAuth firebaseauth = FirebaseAuth.instance;


  //login
   Future loginUserWithEmailandPassword(String email,String password)async {
    try{
      User user=(await firebaseauth.signInWithEmailAndPassword(email: email, password: password)).user!;
      if(user!=null){
        return true;
      }
    }on FirebaseAuthException catch(e){
      print(e.code);
      return e.message;
    }
  }

  //register
  Future registerUserWithEmailandPassword(String fullname,String email,String password)async {
    try{
       User user=(await firebaseauth.createUserWithEmailAndPassword(email: email, password: password)).user!;
       if(user!=null){
         await Databaseservice(uid:user.uid).updateUserData(fullname, email);
         return true;
       }
    }on FirebaseAuthException catch(e){
        print(e.code);
        return e.message;

    }
  }
  //signout
  Future signout()async {
    try{
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserNameSF("");
      await HelperFunctions.saveUserEmailSF("");
      await firebaseauth.signOut();
    }catch(e){
      return null;
    }
  }

}