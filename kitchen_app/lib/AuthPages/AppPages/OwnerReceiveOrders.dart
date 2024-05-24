import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_app/AuthPages/AppPages/kitchenPage.dart';
import 'package:url_launcher/url_launcher.dart';

class OwnerReceiveOrders extends StatefulWidget {
  const OwnerReceiveOrders({super.key});

  @override
  State<OwnerReceiveOrders> createState() => _OwnerReceiveOrdersState();
}

class _OwnerReceiveOrdersState extends State<OwnerReceiveOrders> {
  final rdb=FirebaseDatabase.instance.ref("Cart");
  @override
  Widget build(BuildContext context) {
    var ScreenH = MediaQuery.of(context).size.height;
    var ScreenW = MediaQuery.of(context).size.width;
    final _firestore = FirebaseFirestore.instance.collection("Orders");
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Orders").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Column( 
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8,right: 8,top: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[900],
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.numbers,size: (ScreenH*30)/672,color: Colors.white,),
                            SizedBox(width: (ScreenW*5)/360,),
                            Text("Order No :",style: TextStyle(fontSize: (ScreenH*23)/672 ,fontWeight: FontWeight.bold,color: Colors.white),),
                          ],
                        ),
                        Container(
                          width: (ScreenW*295)/360,
                          child: Column(  
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${snapshot.data!.docs[index]["id"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8,right: 8,top: 0.5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[900],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: (ScreenW*105)/360,
                        child: Column(
                          children: [
                            Text("Item",style: TextStyle(fontSize: (ScreenH*23)/672 ,fontWeight: FontWeight.bold,color: Colors.white),),
                            SizedBox(height: (ScreenH*10)/672,),
                            snapshot.data!.docs[index]["ItemLength"]==5?
                            Column(
                              children: [
                                Text("${snapshot.data!.docs[index]["Item1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Item2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Item3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Item4"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Item5"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                            ],):
                            snapshot.data!.docs[index]["ItemLength"]==4?
                            Column(
                              children: [
                                Text("${snapshot.data!.docs[index]["Item1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Item2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Item3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Item4"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                            ],):
                            snapshot.data!.docs[index]["ItemLength"]==3?
                            Column(
                              children: [
                                Text("${snapshot.data!.docs[index]["Item1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Item2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Item3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                            ],):
                            snapshot.data!.docs[index]["ItemLength"]==2?
                            Column(
                              children: [
                                Text("${snapshot.data!.docs[index]["Item1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Item2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                            ],):
                            Column(
                              children: [
                                Text("${snapshot.data!.docs[index]["Item1"]}",style: TextStyle(fontSize: (ScreenH*18)/672 ,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                            ],)
                          ],
                        ),
                      ),
                      Container(width: (ScreenW*2)/360,color: Colors.white,),
                      Container(
                        width: (ScreenW*105)/360,
                        child: Column(
                          children: [
                            Text("Quantity",style: TextStyle(fontSize: (ScreenH*23)/672 ,fontWeight: FontWeight.bold,color: Colors.white),),
                            SizedBox(height: (ScreenH*10)/672,),
                            snapshot.data!.docs[index]["ItemLength"]==5?
                            Column(
                              children: [
                                Text("${snapshot.data!.docs[index]["Quantity1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Quantity2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Quantity3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Quantity4"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Quantity5"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                            ],):
                            snapshot.data!.docs[index]["ItemLength"]==4?
                            Column(
                              children: [
                                Text("${snapshot.data!.docs[index]["Quantity1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Quantity2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Quantity3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Quantity4"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                            ],): 
                            snapshot.data!.docs[index]["ItemLength"]==3?
                            Column(
                              children: [
                                Text("${snapshot.data!.docs[index]["Quantity1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Quantity2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Quantity3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                            ],):
                            snapshot.data!.docs[index]["ItemLength"]==2?
                            Column(
                              children: [
                                Text("${snapshot.data!.docs[index]["Quantity1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("${snapshot.data!.docs[index]["Quantity2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                            ],):
                            Column(
                              children: [
                                Text("${snapshot.data!.docs[index]["Quantity1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                            ],)
                          ],
                        ),
                      ),
                      Container(width: (ScreenW*2)/360,color: Colors.white,),
                      Container(
                        width: (ScreenW*105)/360,
                        child: Column(
                          children: [
                            Text("Cost",style: TextStyle(fontSize: (ScreenH*23)/672 ,fontWeight: FontWeight.bold,color: Colors.white),),
                            SizedBox(height: (ScreenH*10)/672,),
                            snapshot.data!.docs[index]["ItemLength"]==5?
                            Column(
                              children: [
                                Text("Rs ${snapshot.data!.docs[index]["Cost1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("Rs ${snapshot.data!.docs[index]["Cost2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("Rs ${snapshot.data!.docs[index]["Cost3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("Rs ${snapshot.data!.docs[index]["Cost4"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("Rs ${snapshot.data!.docs[index]["Cost5"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                            ],):
                            snapshot.data!.docs[index]["ItemLength"]==4?
                            Column(
                              children: [
                                Text("Rs ${snapshot.data!.docs[index]["Cost1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("Rs ${snapshot.data!.docs[index]["Cost2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("Rs ${snapshot.data!.docs[index]["Cost3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("Rs ${snapshot.data!.docs[index]["Cost4"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                            ],):
                            snapshot.data!.docs[index]["ItemLength"]==3?
                            Column(
                              children: [
                                Text("Rs ${snapshot.data!.docs[index]["Cost1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("Rs ${snapshot.data!.docs[index]["Cost2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("Rs ${snapshot.data!.docs[index]["Cost3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                            ],):
                            snapshot.data!.docs[index]["ItemLength"]==2?
                            Column(
                              children: [
                                Text("Rs ${snapshot.data!.docs[index]["Cost1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                                Text("Rs ${snapshot.data!.docs[index]["Cost2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                            ],):
                            Column(
                              children: [
                                Text("Rs ${snapshot.data!.docs[index]["Cost1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                SizedBox(height: (ScreenH*5)/672,),
                            ],)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8,right: 8,top: 0.5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[900],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.money,size: (ScreenH*30)/672,color: Colors.white,),
                            SizedBox(width: (ScreenW*5)/360,),
                            Text("Total Cost :",style: TextStyle(fontSize: (ScreenH*23)/672 ,color: Colors.white,fontWeight: FontWeight.bold),),
                          ],
                        ),
                        Container(
                          width: (ScreenW*295)/360,
                          child: Column(  
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Rs ${snapshot.data!.docs[index]["Total Cost"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8,right: 8,top: 0.5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[900],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.place,size: (ScreenH*30)/672,color: Colors.white,),
                            SizedBox(width: (ScreenW*5)/360,),
                            Text("Location : -",style: TextStyle(fontSize: (ScreenH*23)/672 ,color: Colors.white,fontWeight: FontWeight.bold),),
                          ],
                        ),
                        Container(
                          width: (ScreenW*295)/360,
                          child: Column(  
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${snapshot.data!.docs[index]["Address"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8,right: 8,top: 0.5,bottom: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[900],
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green
                          ),
                          onPressed: ()async{
                            final Uri url = Uri(
                              scheme: "tel",
                              path: "${snapshot.data!.docs[index]["Phone Number"]}"
                            );
                            if(await canLaunchUrl(url)){
                              await launchUrl(url);
                            }
                            else{
                              //err
                            }
                          }, 
                          child: Row(
                            children: [
                              Icon(Icons.phone,size: (ScreenH*30)/672,color: Colors.white,),
                              SizedBox(width: (ScreenW*5)/360,),
                              Text("Call",style: TextStyle(fontSize: (ScreenH*20)/672 ,color: Colors.white,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                        SizedBox(width: (ScreenW*120)/672,),
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.green
                          ),
                          onPressed: (){
                            _firestore.doc(snapshot.data!.docs[index].id).delete().then((value){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Order : ${snapshot.data!.docs[index]["id"]} is done"),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                )
                              );
                            });
                          }, 
                          icon: Icon(Icons.check,color: Colors.white,),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
              },
            );
          }
          else{
            return Center(child: CircularProgressIndicator(),);
          }
        }
      )
    );
  }
}