
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Authenticate/databaseservice.dart';
import 'home.dart';
class Grp_info extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const Grp_info({Key? key, required this.groupId, required this.groupName, required this.adminName}) : super(key: key);

  @override
  State<Grp_info> createState() => _Grp_infoState();
}

class _Grp_infoState extends State<Grp_info> {
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }
  getName(String r){
     return r.substring(r.indexOf("_")+1);
  }

  String getid(String res){
    return res.substring(0,res.indexOf("_"));
  }

  getMembers()async{
    Databaseservice(uid: FirebaseAuth.instance.currentUser!.uid).
    groupMembers(widget.groupId).then((value){
      setState(() {
        members = value;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Group info"),
        actions: [
          IconButton(onPressed: ()async{
              showDialog(
                  barrierDismissible: false,
                  context: context, builder: (context){
                return AlertDialog(
                  content: const Text("Are you sure you want exit group?"),
                  title: const Text("Exit"),
                  actions: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: const Icon(Icons.cancel,color: Colors.red,)),
                    IconButton(onPressed: () async{
                      Databaseservice(uid: FirebaseAuth.instance.currentUser!.uid)
                          .toggleGroupJoin(widget.groupId, getName(widget.adminName), widget.groupName).whenComplete((){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                              return Home();
                            }));
                      });
                    }, icon: const Icon(Icons.done,color: Colors.green,))
                  ],
                );
              });

          },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).primaryColor.withOpacity(0.2)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(widget.groupName.substring(0,1).toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Group: ${widget.groupName}",),
                        SizedBox(height: 5,),
                        Text("Admin: ${getName(widget.adminName)}"),
                      ],
                    )
                  ],
                ),
              ),
               memberList(),
            ],
          ),
        ),
      ),
    );
  }
  memberList(){
    return StreamBuilder(
        stream: members,
        builder: (context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(snapshot.data['members'] != null){
              if(snapshot.data['members'].length != 0){
                return ListView.builder(
                    itemCount: snapshot.data['members'].length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(getName(snapshot.data['members'][index]).substring(0,1).toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),),
                          ),
                          title: Text(getName(snapshot.data['members'][index])),
                          subtitle: Text(getid(snapshot.data['members'][index])),
                        ),
                      );
                    });
              }else{
                return Center(
                  child: Text("NO MEMBERS"),
                );
              }
            }else{
              return Center(
                child: Text("NO MEMBERS"),
              );
            }
          }else{
            return Center(
              child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),
            );
          }
        });
  }
}
