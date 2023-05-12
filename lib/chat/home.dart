
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/chat/profile.dart';
import 'package:messanger/chat/resource.dart';
import 'package:messanger/chat/search_page.dart';

import '../Authenticate/auth.dart';
import '../Authenticate/databaseservice.dart';
import '../notes/Home.dart';
import '../todo/home_page.dart';
import '../verification/login.dart';
import 'grouptile.dart';
import 'helperfun.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String username =  "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _loading = false;
  String groupname = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettinguserdata();
  }

  //String manipulation
  String getid(String res){
    return res.substring(0,res.indexOf("_"));
  }

  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }


  gettinguserdata()async{
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        username = value!;
      });
    });
    //getting list of snapshot in stream
    await Databaseservice(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((val){
      setState(() {
        groups=val;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context){
             return const Search();
           }));
          }, icon: const Icon(Icons.search,color: Colors.white,))
        ],
          elevation: 0,
          centerTitle:true, title: const Text("Groups",style: TextStyle(
        color: Colors.white,
        fontSize: 25,
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
            Text(username,textAlign: TextAlign.center,style: const TextStyle(
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
            onTap: (){},
            selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Groups",style: TextStyle(
                color: Colors.black
              ),),
            ),
            ListTile(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                  return Profile(username: username,email: email,);
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
                  return Notes(username: username,email: email,);
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
      body: grouplist(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          return popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add,color: Colors.white,size:30,),
      ),

    );}
    popUpDialog(BuildContext context){
      showDialog(
          barrierDismissible: false,
          context: context, builder: (context){
        return AlertDialog(
          title: const Text("Create a group",textAlign: TextAlign.center,),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _loading ? Center(
                child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),) :
                TextField(
                  onChanged: (value) {
                    setState(() {
                      groupname = value;
                    });
                  },
                  style: TextStyle(
                    color: Colors.black
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor,
                            width: 2.0)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(color:Theme.of(context).primaryColor,
                            width: 2.0)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: const BorderSide(color:Colors.red,
                            width: 2.0)
                    ),
                  ),
                )
            ],
          ),
          actions: [
            ElevatedButton(
                 style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 3,),
                onPressed: (){
                   return Navigator.pop(context);
                }, child: const Text("Cancel",style:TextStyle(
                fontWeight: FontWeight.bold
            ),)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 3,),
                onPressed: ()async{
                if(groupname != ""){
                  setState(() {
                    _loading = true;
                  });
                  Databaseservice(uid: FirebaseAuth.instance.currentUser!.uid).
                  createGroup(username, FirebaseAuth.instance.currentUser!.uid ,groupname).whenComplete((){
                    setState(() {
                      _loading = false;
                    });
                    showSnack(context, Colors.green,"Group created successfully");
                    return Navigator.pop(context);
                  });
                }
                }, child: const Text("Create",style:TextStyle(
              fontWeight: FontWeight.bold
            ),)),
          ],
        );
      });
    }
    grouplist() {
      return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          // checks
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data['groups'].length,
                    itemBuilder:(context,index) {
                      int reverseindex= snapshot.data['groups'].length-index-1;
                      return GroupTile(
                          userName:snapshot.data['fullname'],
                          groupid: getid(snapshot.data["groups"][reverseindex]),
                          groupName:getName(snapshot.data["groups"][reverseindex]));
                },);
              } else{
                return nogroupWiget();
              }
            } else {
              return nogroupWiget();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,),);
          }
        },);
    }
    nogroupWiget(){
      return Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: (){
                    return popUpDialog(context);
                  },
                  child: Icon(Icons.add_circle,color: Colors.grey[700],size: 75,)),
              const SizedBox(
                height: 20,
              ),
              const Text("You've not joined any groups , tap on the add icon to create a group",
              textAlign: TextAlign.center
                ,)
            ],
          ),
        ),
      );
    }

}
