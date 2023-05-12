
import 'package:flutter/material.dart';

import '../Authenticate/auth.dart';
import '../chat/helperfun.dart';
import '../chat/home.dart';
import '../chat/resource.dart';
import 'login.dart';
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController name = TextEditingController(text: "");
  TextEditingController email = TextEditingController(text: "");
  TextEditingController password = TextEditingController(text: "");
  String fullname ="";
  String emailid ="";
  String pass ="";
  bool _visible = true;
  bool _isloading = false;
  AuthService authService = AuthService();
  final _formkey = GlobalKey<FormState>();
  void register() async {
    if(_formkey.currentState!.validate()){
      setState(() {
        _isloading = true;
      });
      await authService.registerUserWithEmailandPassword(fullname,emailid,pass).
      then((value)async{
        if(value == true){
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(emailid);
          await HelperFunctions.saveUserNameSF(fullname) ;
          Navigator.push(context, MaterialPageRoute(builder:(context){
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
      body: _isloading ? const Center(child: CircularProgressIndicator(color: Color(0xff20b3dc),),):SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 90,
              ),
              const Text("Groupiee",style: TextStyle(
                color: Color(0xff20b3dc),
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),),
              const SizedBox(
                height: 10,
              ),
              const Text("Create an account to chat and explore"),
              Image.asset("images/group.png"),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formkey,
                  child: Column(
                children: [
                  TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return'Please Enter the name';
                      }
                      return null;
                    },
                    controller: name,
                    onChanged: (val){
                      setState(() {
                        fullname=val;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon:  Icon(Icons.account_circle,color:Theme.of(context).primaryColor,),
                      labelText: "Full name",
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
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value){
                      if(!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)){
                        return'Please Enter the valid email';
                      }
                      return null;
                    },
                    controller: email,
                    onChanged: (val){
                      setState(() {
                        emailid=val;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon:  Icon(Icons.email,color:Theme.of(context).primaryColor,),
                      labelText: "Email",
                      labelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide:  BorderSide(color: Theme.of(context).primaryColor,
                              width: 2.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color:Theme.of(context).primaryColor,
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
                  const SizedBox(
                    height: 15,
                  ),
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
                      setState(() {
                        pass=val;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock,color:Theme.of(context).primaryColor,),
                      suffixIcon: IconButton(onPressed:(){
                        setState(() {
                          _visible =!_visible;
                        });
                      },icon: Icon(Icons.remove_red_eye_rounded,color:Theme.of(context).primaryColor,)),
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
                          borderSide: BorderSide(color:Theme.of(context).primaryColor,
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
                            register();
                          }, child: const Text("Register"))
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
                        const Text("Already have an account?"),
                        TextButton(onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                            return const Login();
                          }));
                        }, child: Text("login now",style: TextStyle(
                            color: Theme.of(context).primaryColor
                        ),))
                      ],
                    ),
                  ),
                ],

              ))
            ],
          ),
        ),
      ),
    );
  }
}
