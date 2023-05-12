
import 'package:flutter/material.dart';

import 'chatpage.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupid;
  final String groupName;
  const GroupTile({Key? key, required this.userName, required this.groupid, required this.groupName}) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Chatpage(
            groupid: widget.groupid,
            groupname: widget.groupName,
            userName: widget.userName,);
        }));
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:10,horizontal: 5),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(widget.groupName.substring(0,1).toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),),
            ),
            title: Text(widget.groupName,style: TextStyle(
              fontWeight: FontWeight.bold,
            ),),
            subtitle: Text("Join the conversation as ${widget.userName}",style: TextStyle(fontSize: 13),),
          ),
        ),
      ),
    );
  }
}
