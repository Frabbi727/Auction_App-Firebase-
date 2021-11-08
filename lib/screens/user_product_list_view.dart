import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserProductList extends StatefulWidget {
  @override
  _UserProductListState createState() => _UserProductListState();
}

class _UserProductListState extends State<UserProductList> {
  var LoginUser = FirebaseAuth.instance.currentUser;
  //User? LoginUser;
  var imageUrl;

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
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
            physics: ScrollPhysics(),
            children: snapshot.data!.docs.map((document) {
              return Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 150,
                      width: 150,
                      margin: EdgeInsets.only(right: 10),
                      child: Image(
                        image: NetworkImage(document.data()['productImageUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Name :' + document['productName'],style: TextStyle(color: Theme.of(context).primaryColor),),
                          Text('description :' + document['productDes']),
                          Text('Price :' + document['bidPrice']),
                          
                          // Text('By: ' + document['username']),
                          Text('Post Date : ' + document['uploadDate']),
                          Text('Last Date : ' + document['endDate']),
                          TextButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(LoginUser!.uid)
                                    .collection('products')
                                    .doc(document.id)
                                    .delete()
                                    .then((value) async {
                                  // var storageRef = FirebaseStorage.instance
                                  //     .refFromURL(productImageUrl!);
                                  //     await storageRef.delete();
                                  //FirebaseStorage.instance.refFromURL('productImageUrl').delete();

                                  print(
                                      'Product Deleted But image is still there in Storage Folder');
                                });
                              },
                              child: Text('Delete')),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
