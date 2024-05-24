import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class OwnerReadReviews extends StatefulWidget {
  const OwnerReadReviews({super.key});

  @override
  State<OwnerReadReviews> createState() => _OwnerReadReviewsState();
}

class _OwnerReadReviewsState extends State<OwnerReadReviews> {
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
        title: Text("Customer Reviews"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: double.infinity,
                height: (ScreenH*550)/672,
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
          ],
        ),
      )
    );
  }
}