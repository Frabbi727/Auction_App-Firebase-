import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/user_drawer.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isFabVisibale = true;
  User? FirebaseUser;
  var _productName = '';
  var _productDes = '';
  var _bidPrice = '';
  var _auctionDate = '';
  var time= DateTime.now().toString();

  var userName;

  File? pickImageFile;
  pickAnImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxWidth: 200,
          maxHeight: 100);
      if (pickedImage == null) return;
      final pickTemp = File(pickedImage.path);
      setState(() {
        this.pickImageFile = pickTemp;
      });
      print(pickImageFile);
    } on Exception catch (e) {
      print('failed to upload $e');
    }
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    var FirebaseUser = await FirebaseAuth.instance.currentUser;
    if (FirebaseUser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseUser.uid)
          .get()
          .then((value) {
        userName = value.data()!['username'];
      });

    FocusScope.of(context).unfocus();
    try {
      if (isValid) {
        _formKey.currentState?.save();
        print(_productName);
        print(_productDes);
        print(_bidPrice);
        print(_auctionDate);
        print(FirebaseUser!.email);
        print(userName);

        print(' Good to go ');
        final productImgRef = FirebaseStorage.instance
            .ref()
            .child('productImage')
            .child(FirebaseUser.uid +time +'.jpg');
        await productImgRef.putFile(pickImageFile!);
        var productImageUrl = await productImgRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseUser.uid)
            .collection('products')
            .add({
          'productName': _productName,
          'productDes': _productDes,
          'bidPrice': _bidPrice,
          'auctionDate': _auctionDate,
          'submitBy': userName,
          'productImageUrl': productImageUrl,
        });
      } else {
        print('Form is not valid');
      }
    } catch (err) {
      Text('Check credential: $err');
    }
  }

  void addNewProducts(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              scrollDirection: Axis.vertical,
              addRepaintBoundaries: true,
              physics: ScrollPhysics(),
              children: <Widget>[
                Center(
                    child: Text(
                  'Add New Product',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                )),
                TextFormField(
                  onSaved: (value) {
                    _productName = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Product Name';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Product Name',
                      icon: Icon(Icons.insert_chart)),
                ),
                TextFormField(
                  onSaved: (value) {
                    _productDes = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Product Description';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Product Description',
                      icon: Icon(Icons.description)),
                ),
                TextFormField(
                  onSaved: (value) {
                    _bidPrice = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Product Price';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Minimum Bid Price',
                      icon: Icon(Icons.price_check)),
                ),
                TextFormField(
                  onSaved: (value) {
                    _auctionDate = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Product End Date';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Auction End DateTime',
                      icon: Icon(Icons.data_saver_off)),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: pickImageFile != null
                          ? FileImage(pickImageFile!)
                          : null,
                    ),
                    IconButton(
                      onPressed: pickAnImage,
                      icon: Icon(Icons.image),
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserScreen()));
                        },
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _trySubmit();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserScreen()));
                        },
                        child: Text('Add Product'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Screen'),
          actions: [
            DropdownButton(
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.exit_to_app,
                          color: Theme.of(context).indicatorColor,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Logout')
                      ],
                    ),
                  ),
                  value: 'logout',
                ),
              ],
              onChanged: (itemIdentifire) {
                if (itemIdentifire == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              },
            ),
          ],
        ),
        drawer: UserDrawer(),
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              setState(() {
                isFabVisibale = true;
              });
            }
            if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                isFabVisibale = false;
              });
            }
            return true;
          },
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collectionGroup('products')
                .snapshots(),
            builder: (BuildContext contex,
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
                            image: NetworkImage(
                                document.data()['productImageUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Name :' + document['productName']),
                              Text('description :' + document['productDes']),
                              Text('Price :' + document['bidPrice']),
                              Text('Date :' + document['auctionDate']),
                              // Text('By: ' + document['username']),
                              TextButton(onPressed: () {}, child: Text('Bid')),
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: isFabVisibale
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  addNewProducts(context);
                },
              )
            : null,
      ),
    );
  }
}
