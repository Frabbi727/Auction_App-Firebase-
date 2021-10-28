

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';

class UserScreen extends StatefulWidget {
 

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();

  var _productName = '';
  var _productDes = '';
  var _bidPrice = '';
  var _auctionDate = '';

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    try {
      if (isValid) {
        _formKey.currentState?.save();
        print(_productName);
        print(_productDes);
        print(_bidPrice);
        print(_auctionDate);
        print(' Good to go ');
        await FirebaseFirestore.instance.collection('Products').add({
          'productName': _productName,
          'productDes': _productDes,
          'bidPrice': _bidPrice,
          'auctionDate': _auctionDate,
        });
      } else {
        print('Form is not valid');
      }
    } catch (err) {
      Text('Check credential');
    }
  }

  bool isFabVisibale = false;
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
              addRepaintBoundaries: true,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserScreen()));
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text('Add Product'),
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
                        Text('Add Products')
                      ],
                    ),
                  ),
                  value: 'Add',
                ),
              ],
              onChanged: (itemIdentifire) {
                if (itemIdentifire == 'Add') {
                  addNewProducts(context);
                }
              },
            ),
          ],
        ),
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
          
           child:
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('Products').snapshots(),
            builder: (BuildContext contex,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData) {
                return Text('No Produts for display..');
              }
              return ListView(
                physics: ScrollPhysics(),
                children: snapshot.data!.docs.map((document) {
                  return Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Card(
                          child: Text('Image'),
                        ),
                        Column(children:<Widget> [
                          Text('Name :' + document['productName']),
                          Text('description :' + document['productDes']),
                          Text('Price :' + document['bidPrice']),
                          Text('Date :' + document['auctionDate']),
                          TextButton(onPressed: (){}, child: Text('Bid')),
                        ],),
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
            ? 
            FloatingActionButton(
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
