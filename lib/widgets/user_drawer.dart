

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDrawer extends StatefulWidget {
  //UserDrawer({Key? key}) : super(key: key);

  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (BuildContext contex,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return Text('User is not found');
                }
                return Stack(
                  children: snapshot.data!.docs.map(
                    (document) {
                      return Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 105),
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorDark,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(120))),
                                    child: Column(children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.blueAccent,
                                      ),
                                      Text(  document['username'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), ),
                                    ],),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            height: 100,
                            width: double.infinity,
                            child: Text(
                              'Profile',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(80))),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                );
              }),
        ),
      ),
    );
  }
}
