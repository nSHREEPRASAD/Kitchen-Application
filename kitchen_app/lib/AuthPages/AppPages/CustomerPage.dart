import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerCorner extends StatefulWidget {
  const CustomerCorner({super.key});

  @override
  State<CustomerCorner> createState() => _CustomerCornerState();
}

class _CustomerCornerState extends State<CustomerCorner> {
  final _key1=GlobalKey<FormState>();
  TextEditingController reviewcontroller=TextEditingController();
  List Likess = [];

  Map<String,dynamic> userMap={};
  final _auth=FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection("Users")
    .doc(_auth.currentUser!.uid.toString())
    .get().then((value){
      setState(() {
        userMap=value.data()!;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance.collection("Customer Reviews");
    var ScreenH = MediaQuery.of(context).size.height;
    var ScreenW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer's Corner"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: double.infinity,
                height: (ScreenH*450)/672,
                child: StreamBuilder(
                  stream: _firestore.snapshots(), 
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Container(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text("${snapshot.data!.docs[index]["Username"]}",style: TextStyle(fontSize: (ScreenH*15)/672,color: Colors.blueGrey),),
                                subtitle: Text("${snapshot.data!.docs[index]["Review"]}",style: TextStyle(fontSize: (ScreenH*15)/672),),
                                trailing: Container(
                                  height: (ScreenH*120)/672,
                                  width: (ScreenW*80)/360,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async{
                                          var Likes = List.from(snapshot.data!.docs[index]["Likes"]??[]);
                                          if(Likes.contains(_auth.currentUser!.uid.toString())){
                                            Likes.remove(_auth.currentUser!.uid.toString());
                                          }
                                          else{
                                            Likes.add(_auth.currentUser!.uid.toString());
                                          }
                                          await _firestore.doc(snapshot.data!.docs[index].id).update({
                                            "Likes":Likes
                                          });
                                        }, 
                                        icon: snapshot.data!.docs[index]["Likes"].contains(_auth.currentUser!.uid.toString())?Icon(Icons.favorite,color: Colors.red,):Icon(Icons.favorite,color: Colors.blueGrey,)
                                      ),
                                      Text(snapshot.data!.docs[index]["Likes"].length.toString(),style: TextStyle(fontSize: (ScreenH*10)/672),)
                                    ],
                                  ),
                                ),
                              )
                            ),
                          );
                        },
                      );
                    }
                    else{
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )
              ),
            ),
            SizedBox(height: (ScreenH*5)/672,),
            Container(
              width: (ScreenW*320)/360,
              child: Form(
                key: _key1,
                child: TextFormField(
                  maxLines: 2,
                  validator: (value) {
                    if(value!.isNotEmpty){
                      return null;
                    }
                    else{
                      return "Please Enter Your Review";
                    }
                  },
                  controller: reviewcontroller,
                  decoration: InputDecoration(
                    hintText: "Enter Your Review...",
                    suffix: IconButton(
                      onPressed: (){
                        if(!_key1.currentState!.validate()){
                          return;
                        }
                        else{
                           _firestore.add({
                            "Review": reviewcontroller.text.toString(),
                            "Likes": Likess,
                            "Username": userMap["Username"]
                          }).then((value){
                            reviewcontroller.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Review Posted Successfully !"),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.green,
                              )
                            );
                          });
                        }
                      }, 
                      icon: Icon(Icons.send)
                    )
                  ),
                )
              ),
            )
          ],
        ),
      )
    );
  }
}