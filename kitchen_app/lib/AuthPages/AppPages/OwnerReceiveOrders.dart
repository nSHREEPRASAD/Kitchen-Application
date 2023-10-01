import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OwnerReceiveOrders extends StatefulWidget {
  const OwnerReceiveOrders({super.key});

  @override
  State<OwnerReceiveOrders> createState() => _OwnerReceiveOrdersState();
}

class _OwnerReceiveOrdersState extends State<OwnerReceiveOrders> {
  final _firestore=FirebaseFirestore.instance;
  final rdb=FirebaseDatabase.instance.ref("Cart");
  bool isPresent=false;

  Future<bool> checkCollectionExists() async {
    final snapshot = await _firestore.collection("Special Dish").limit(1).get();
    return snapshot.size > 0;
  }

  checkVal() async{
    final bool collectionExists = await checkCollectionExists();
    if(collectionExists==true){
      setState(() {
        isPresent=true;
      });
    }
    else if(collectionExists==false){
      setState(() {
        isPresent=false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body:FirebaseAnimatedList(
        query: rdb, 
        defaultChild: Center(child: CircularProgressIndicator()),
        itemBuilder: (context,snapshot,animation,index){
          return Card(
            elevation: 10,
            shadowColor: Colors.black,
            color: Colors.blueGrey,
            child: Container(
              width: 300,
              height: 370,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.person,size: 30,color: Colors.white),
                      ),
                      SizedBox(width: 10,),
                      Text(snapshot.child("UserEmail").value.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)
                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: 350,
                    height: 160,
                    child: Row(
                      children: [
                        Container(
                          width: 115,
                          height: 150,
                          child: Column(
                            children: [
                              Text("Item",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),),
                              SizedBox(height: 5,),
                              Text(snapshot.child("Item1").value.toString(),style: TextStyle(color: Colors.white),),
                              SizedBox(height: 5,),
                              snapshot.child("Item2").exists?
                              Text(snapshot.child("Item2").value.toString(),style: TextStyle(color: Colors.white),):
                              Text(""),
                              SizedBox(height: 5,),
                              snapshot.child("Item3").exists?
                              Text(snapshot.child("Item3").value.toString(),style: TextStyle(color: Colors.white),):
                              Text(""),
                              SizedBox(height: 5,),
                              snapshot.child("Item4").exists?
                              Text(snapshot.child("Item4").value.toString(),style: TextStyle(color: Colors.white),):
                              Text(""),
                              snapshot.child("Item5").exists?
                              Text(snapshot.child("Item5").value.toString(),style: TextStyle(color: Colors.white),):
                              Text(""),
                            ],
                          ),
                        ),
                        Container(
                          width: 115,
                          height: 150,
                          child: Column(
                            children: [
                              Text("Quantity",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),),
                              SizedBox(height: 5,),
                              Text(snapshot.child("Quantity1").value.toString(),style: TextStyle(color: Colors.white),),
                              SizedBox(height: 5,),
                              snapshot.child("Quantity2").exists?
                              Text(snapshot.child("Quantity2").value.toString(),style: TextStyle(color: Colors.white),):
                              Text(""),
                              SizedBox(height: 5,),
                              snapshot.child("Quantity3").exists?
                              Text(snapshot.child("Quantity3").value.toString(),style: TextStyle(color: Colors.white),):
                              Text(""),
                              SizedBox(height: 5,),
                              snapshot.child("Quantity4").exists?
                              Text(snapshot.child("Quantity4").value.toString(),style: TextStyle(color: Colors.white),):
                              Text(""),
                              snapshot.child("Quantity5").exists?
                              Text(snapshot.child("Quantity5").value.toString(),style: TextStyle(color: Colors.white),):
                              Text(""),
                            ],
                          ),
                        ),
                        Container(
                          width: 115,
                          height: 150,
                          child: Column(
                            children: [
                              Text("Price",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),),
                              SizedBox(height: 5,),
                              Text("Rs ${snapshot.child("Cost1").value.toString()}",style: TextStyle(color: Colors.white),),
                              SizedBox(height: 5,),
                              snapshot.child("Cost2").exists?
                              Text("Rs ${snapshot.child("Cost2").value.toString()}",style: TextStyle(color: Colors.white),):
                              Text(""),
                              SizedBox(height: 5,),
                              snapshot.child("Cost3").exists?
                              Text("Rs ${snapshot.child("Cost3").value.toString()}",style: TextStyle(color: Colors.white),):
                              Text(""),
                              SizedBox(height: 5,),
                              snapshot.child("Cost4").exists?
                              Text("Rs ${snapshot.child("Cost").value.toString()}",style: TextStyle(color: Colors.white),):
                              Text(""),
                              snapshot.child("Cost5").exists?
                              Text("Rs ${snapshot.child("Cost5").value.toString()}",style: TextStyle(color: Colors.white),):
                              Text(""),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 350,
                    height: 40,
                    child: Row(
                      children: [
                        SizedBox(width: 20,),
                        Text("Total Cost :- Rs ",style: TextStyle(color: Colors.white),),
                        Text(snapshot.child("Total Cost").value.toString(),style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20,),
                      Text("Address :- ",style: TextStyle(color: Colors.white),),
                      SizedBox(width: 10,),
                      Container(
                        width: 230,
                        height: 50,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(snapshot.child("Address").value.toString(),style: TextStyle(color: Colors.white),)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      ElevatedButton(
                        onPressed: ()async{
                          final Uri url=Uri(
                            scheme: 'tel',
                            path: snapshot.child("Phone Number").value.toString()
                          );
                          if(await canLaunchUrl(url)){
                            await launchUrl(url);
                          }
                          else{
                            print("Cannot Launch Url");
                          }
                        }, 
                        child:Row(
                          children: [
                            Icon(Icons.call),
                            SizedBox(width: 5,),
                            Text("Call")
                          ],
                        ) 
                      ),
                      SizedBox(width: 140,),
                      ElevatedButton(onPressed: (){
                        rdb.child(snapshot.child("id").value.toString()).remove();
                      }, child: Text("Done"))
                    ],
                  )
                ],
              ),
            ),
          );
        }
      )
    );
  }
}