
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/chat/resource.dart';

import '../Authenticate/databaseservice.dart';
import 'chatpage.dart';
import 'helperfun.dart';
class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool _loading = false;
  QuerySnapshot? searchSnapshot ;
  bool hasUserSearched = false;
  TextEditingController searchController = TextEditingController();
  String userName = "";
  User? user;
  bool _isJoin = false;

  @override
  void initState() {
    getcurrentUsernameAndid();
    super.initState();
  }
  getName(String r){
    return r.substring(r.indexOf("_")+1);
  }

  String getid(String res){
    return res.substring(0,res.indexOf("_"));
  }
  getcurrentUsernameAndid()async{
    await HelperFunctions.getUserNameFromSF().then((value){
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Search",style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Groups......",
                    hintStyle: TextStyle(
                      color: Colors.white,fontSize: 16
                    ),
                  ),
                )),
                GestureDetector(
                  onTap: (){
                    initiateSearch();
                    },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(Icons.search,color: Colors.white,),
                  ),
                )
              ],
            ),
          ),
          _loading ? Center(child: CircularProgressIndicator(color:Theme.of(context).primaryColor ,),):
              groupList(),
        ],
      ),
    );
  }
  initiateSearch()async{
    if(searchController.text.isNotEmpty){
      setState(() {
        _loading =true;
      });
      await Databaseservice().searchByName(searchController.text).then((val){
        setState(() {
          searchSnapshot = val;
          _loading=false;
          hasUserSearched=true;
        });
      });
    }
  }
  groupList(){
      return hasUserSearched? ListView.builder(
          shrinkWrap: true,
          itemCount: searchSnapshot!.docs.length,
          itemBuilder: (context,index) {
            return groupTile(
              userName,
              searchSnapshot!.docs[index]['groupId'],
              searchSnapshot!.docs[index]['groupName'],
              searchSnapshot!.docs[index]['admin'],
            );
          }):
      Container();
  }
  joinedOrNot(
      String username,String groupId,String groupName,String admin)async{
      await Databaseservice(uid: user!.uid).isUserJoined(groupName, groupId, userName).then((value) {
        setState(() {
          _isJoin = value;
        });
      });
  }
  Widget groupTile(String userName,String groupid,String groupName,String admin){
    joinedOrNot(userName, groupid, groupName, admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(groupName.substring(0,1).toUpperCase(),style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),),
      ),
      title: Text(groupName,style: const TextStyle(
        fontWeight: FontWeight.w600
      ),),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: ()async{
          await Databaseservice(uid: user!.uid).
          toggleGroupJoin(groupid, userName, groupName);
          if(_isJoin){
            setState(() {
              _isJoin = !_isJoin;
              showSnack(context, Colors.green, "Successfully joined the group");
            });
            Future.delayed(const Duration(seconds: 2), ()
            {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                return Chatpage(groupid: groupid, groupname: groupName, userName: userName);
              }));
            });
          }
          else{
            setState(() {
              _isJoin = !_isJoin;
              showSnack(context, Colors.red, "Left the group $groupName");
            });
          }

        },
        child: _isJoin?Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: const Text("JOINED",style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600
          ),),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            border: Border.all(color: Colors.white,width: 1)
          ),
        ):Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: const Text("JOIN NOW",style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600
          ),),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor,
              border: Border.all(color: Colors.white,width: 1)
          ),
        ),
      ),
    );
  }
}
