
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messanger/notes/update.dart';
import '../Authenticate/auth.dart';
import '../chat/home.dart';
import '../chat/profile.dart';
import '../todo/home_page.dart';
import '../verification/login.dart';
import 'note_card.dart';
import 'note_reader.dart';
class Notes extends StatefulWidget {
  final String username;
  final String email;
  const Notes({Key? key, required this.username, required this.email}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      elevation: 0.0,
      title: const Text("FastNotes"),
      centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        
      ),
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                  return Profile(username: widget.username,email: widget.email,);
                }));
              },
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
              selectedColor:Theme.of(context).primaryColor,
              selected: true,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your recent notes",style:GoogleFonts.roboto(color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("notes").snapshots(),
                  builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),
                      );
                    }
                  if(snapshot.hasData){
                    return GridView(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      children: snapshot.data!.docs
                        .map((note)=>noteCard(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>  NoteReaderScreen(note)));
                    }, note))
                      .toList(),
                    );
                  }
                  return Text("no Notes till now",style: GoogleFonts.nunito(color: Colors.white),);
                  },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  Update()));
      }, label: const Text("Add note"),
        backgroundColor: Theme.of(context).primaryColor,
      icon:const Icon(Icons.add),
      ),
    );
  }
}

