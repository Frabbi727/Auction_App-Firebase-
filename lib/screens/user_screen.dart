import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';

class UserScreen extends StatefulWidget {
  UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
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
            
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              addRepaintBoundaries: true,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Product Name',
                      icon: Icon(Icons.insert_chart)),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Product Description',
                      icon: Icon(Icons.description)),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Minimum Bid Price',
                      icon: Icon(Icons.price_check)),
                ),
                TextFormField(
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
                      onPressed: () {},
                      child: Text('Add Product'),
                    ),
                    ElevatedButton(onPressed: (){
                     Navigator.push(context,  MaterialPageRoute(builder: (context)=>UserScreen()));
                    }, child: Text('Cancel'))
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
    return Scaffold(
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

          // DropdownButton(
          //   items: [
          //     DropdownMenuItem(
          //       child: Container(
          //         child: Row(
          //           children: <Widget>[
          //             Icon(
          //               Icons.add,
          //               color: Theme.of(context).indicatorColor,
          //             ),
          //             SizedBox(
          //               width: 8,
          //             ),
          //             Text('Add New Items')
          //           ],
          //         ),
          //       ),
          //       value: 'AddProduct',
          //     ),
          //   ],
          //   onChanged: (itemIdentifire) {
          //     if (itemIdentifire == 'AddProduct') {
          //       addNewProducts(context);
          //     }
          //   },
          // ),
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
        child: ListView.builder(
          itemCount: 100,
          itemBuilder: (ctx, index) => Container(
            padding: EdgeInsets.all(8),
            child: Text('This Works!'),
          ),
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
    );
  }
}
