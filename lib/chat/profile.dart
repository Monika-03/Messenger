
import 'package:flutter/material.dart';

import '../Authenticate/auth.dart';
import '../notes/Home.dart';
import '../todo/home_page.dart';
import '../verification/login.dart';
import 'home.dart';
class Profile extends StatefulWidget {
  final String username;
  final String email;
  const Profile({Key? key,required this.username,required this.email}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthService authService =AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          centerTitle:true, title: const Text("PROFILE",style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold
      ),),backgroundColor: Theme.of(context).primaryColor),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children:<Widget> [
            Icon(Icons.account_circle,color:Theme.of(context).primaryColor,size: 150,),
            const SizedBox(
              height: 20,
            ),
            Text(widget.username,textAlign: TextAlign.center,style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                  return const Home();
                }));
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Groups",style: TextStyle(
                  color: Colors.black
              ),),
            ),
            ListTile(
              onTap: (){

              },
              selectedColor:Theme.of(context).primaryColor,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.home),
              title: const Text("Profile",style: TextStyle(
                  color: Colors.black
              ),),
            ),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Notes(username: widget.username,email: widget.email,);
                }));
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.note_add_rounded),
              title: const Text("Notes",style: TextStyle(
                  color: Colors.black
              ),),
            ),
            ListTile(
              onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context){
                   return HomePage();
                 }));
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.list_alt),
              title: const Text("Todo List",style: TextStyle(
                  color: Colors.black
              ),),
            ),
            ListTile(
              onTap: ()async{

                showDialog(
                    barrierDismissible: false,
                    context: context, builder: (context){
                  return AlertDialog(
                    content: const Text("Are you sure you want to Logout?"),
                    title: const Text("Logout"),
                    actions: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: const Icon(Icons.cancel,color: Colors.red,)),
                      IconButton(onPressed: (){
                        authService.signout().whenComplete((){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                            return const Login();
                          }));
                        });
                      }, icon: const Icon(Icons.done,color: Colors.green,))
                    ],
                  );
                });
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Logout",style: TextStyle(
                  color: Colors.black
              ),),
            )

          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Center(
              child:Icon(Icons.account_circle,size: 170,color: Colors.grey,)),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Name",style: TextStyle(
                  fontSize: 17
                ),),
                Text(widget.username,style:const TextStyle(
                    fontSize: 17
                ),)
              ],
            ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email Id",style: TextStyle(
                    fontSize: 15
                ),),
                Text(widget.email,textAlign: TextAlign.end,style:const TextStyle(
                    fontSize: 15
                ),)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
