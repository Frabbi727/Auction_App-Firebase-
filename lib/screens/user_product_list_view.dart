import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProductList extends StatefulWidget {
  @override
  _UserProductListState createState() => _UserProductListState();
}

class _UserProductListState extends State<UserProductList> {
  var LoginUser = FirebaseAuth.instance.currentUser;
  //User? LoginUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            // .collectionGroup('products')
            // .where(LoginUser!.uid)
            // .snapshots(),

        .collection('users')
        //.doc(FirebaseAuth.instance.currentUser?.uid ?? '') this portion is also perfect and working perfectly but i have user the avobe one.....
        .doc(LoginUser!.uid)
        .collection('products')
        .snapshots(),
        builder: (BuildContext,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Text('No Produts for display..');
          }
          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Text('Name :' + document['productName']);
            }).toList(),
          );
        },
      ),
    );
  }
}
