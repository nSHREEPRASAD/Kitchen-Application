import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class OwnerReadReviews extends StatefulWidget {
  const OwnerReadReviews({super.key});

  @override
  State<OwnerReadReviews> createState() => _OwnerReadReviewsState();
}

class _OwnerReadReviewsState extends State<OwnerReadReviews> {
  final rdb=FirebaseDatabase.instance.ref("Reviews");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Reviews"),
      ),
      body: Center(
        child: Container(
          width: 340,
          height: 550,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1.5,
            )
          ),
          child: FirebaseAnimatedList(
            query: rdb, 
            defaultChild: Center(child: Text("Empty",style: TextStyle(color: Colors.grey),)),
            itemBuilder: (context,snapshot,animation,index){
              return Card(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(snapshot.child("Email Id").value.toString(),style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(snapshot.child("Review").value.toString()),
                  trailing: Icon(Icons.star,color: Colors.amber,),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}