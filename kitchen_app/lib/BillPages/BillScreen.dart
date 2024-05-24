import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_app/AuthPages/AppPages/kitchenPage.dart';
import 'package:kitchen_app/AuthPages/SignUpPage.dart';
import 'package:kitchen_app/Provider/CartProvider.dart';
import 'package:provider/provider.dart';

class Bill extends StatefulWidget {
  var item;
  var cost;
  var id;

  Bill(
    this.item,
    this.cost,
    this.id
  );

  @override
  State<Bill> createState() => _BillState(item,cost,id);
}

class _BillState extends State<Bill> {

  var item;
  var cost;
  var id;

  _BillState(
    this.item,
    this.cost,
    this.id
  );

  List FoodNames=[
    "Poha","Upma","Idli Sambar","Chapati"
  ];
  List Costs=[
    40,45,50,8
  ];
  @override
  Widget build(BuildContext context) {
    num sum=0;
    var cartindex=context.watch<CartProvider>().cart;
    var cartQuantity=context.watch<CartProvider>().cartQuant;    
    var ScreenH = MediaQuery.of(context).size.height;
    var ScreenW = MediaQuery.of(context).size.width;
    final _firestore = FirebaseFirestore.instance.collection("Cart");
    final _auth = FirebaseAuth.instance;
    for(int i=0;i<cartindex.length;i++)
    {
      if(cartindex[i]==4)
      {
        sum=sum+(int.parse(cost)*int.parse(cartQuantity[i]));
      }
      else{
        sum=sum+Costs[cartindex[i]]*int.parse(cartQuantity[i]);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Bill"),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(onPressed: (){
            cartindex.clear();
            cartQuantity.clear();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Kitchen()));
            _firestore.doc(_auth.currentUser!.uid.toString()).delete();
          }, child: Text("Back To Shop",style: TextStyle(color: Colors.black),))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100,left: 20,right: 20),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Cart").doc(_auth.currentUser!.uid.toString()).snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Column(
                children: [
                  Container(
                    height: (ScreenH*100)/672,
                    decoration: BoxDecoration(
                      color: Colors.green[900],
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.dining,size: (ScreenH*50)/672,color: Colors.white,),
                        Text("Ghadi's Kitchen",style: TextStyle(fontSize: (ScreenH*30)/672 ,color: Colors.white,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  SizedBox(height: (ScreenH*2)/672,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green[900],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: (ScreenW*105)/360,
                          child: Column(
                            children: [
                              Text("Item",style: TextStyle(fontSize: (ScreenH*25)/672 ,fontWeight: FontWeight.bold,color: Colors.white),),
                              SizedBox(height: (ScreenH*10)/672,),
                              cartQuantity.length==1?
                              Column(
                                children: [
                                  Text("${snapshot.data!["Item1"]}",style: TextStyle(fontSize: (ScreenH*18)/672 ,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                              ],):
                              cartQuantity.length==2?
                              Column(
                                children: [
                                  Text("${snapshot.data!["Item1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Item2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                              ],):
                              cartQuantity.length==3?
                              Column(
                                children: [
                                  Text("${snapshot.data!["Item1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Item2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Item3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                              ],):
                              cartQuantity.length==4?
                              Column(
                                children: [
                                  Text("${snapshot.data!["Item1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Item2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Item3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Item4"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                              ],):  
                              Column(
                                children: [
                                  Text("${snapshot.data!["Item1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Item2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Item3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Item4"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Item5"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
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
                              Text("Quantity",style: TextStyle(fontSize: (ScreenH*25)/672 ,fontWeight: FontWeight.bold,color: Colors.white),),
                              SizedBox(height: (ScreenH*10)/672,),
                              cartQuantity.length==1?
                              Column(
                                children: [
                                  Text("${snapshot.data!["Quantity1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                              ],):
                              cartQuantity.length==2?
                              Column(
                                children: [
                                  Text("${snapshot.data!["Quantity1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Quantity2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                              ],):
                              cartQuantity.length==3?
                              Column(
                                children: [
                                  Text("${snapshot.data!["Quantity1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Quantity2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Quantity3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                              ],):
                              cartQuantity.length==4?
                              Column(
                                children: [
                                  Text("${snapshot.data!["Quantity1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Quantity2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Quantity3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Quantity4"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                              ],):  
                              Column(
                                children: [
                                  Text("${snapshot.data!["Quantity1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Quantity2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Quantity3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Quantity4"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("${snapshot.data!["Quantity5"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
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
                              Text("Cost",style: TextStyle(fontSize: (ScreenH*25)/672 ,fontWeight: FontWeight.bold,color: Colors.white),),
                              SizedBox(height: (ScreenH*10)/672,),
                              cartQuantity.length==1?
                              Column(
                                children: [
                                  Text("Rs ${snapshot.data!["Cost1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                              ],):
                              cartQuantity.length==2?
                              Column(
                                children: [
                                  Text("Rs ${snapshot.data!["Cost1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("Rs ${snapshot.data!["Cost2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                              ],):
                              cartQuantity.length==3?
                              Column(
                                children: [
                                  Text("Rs ${snapshot.data!["Cost1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("Rs ${snapshot.data!["Cost2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("Rs ${snapshot.data!["Cost3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                              ],):
                              cartQuantity.length==4?
                              Column(
                                children: [
                                  Text("Rs ${snapshot.data!["Cost1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("Rs ${snapshot.data!["Cost2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("Rs ${snapshot.data!["Cost3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("Rs ${snapshot.data!["Cost4"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                              ],):  
                              Column(
                                children: [
                                  Text("Rs ${snapshot.data!["Cost1"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("Rs ${snapshot.data!["Cost2"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("Rs ${snapshot.data!["Cost3"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("Rs ${snapshot.data!["Cost4"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                                  Text("Rs ${snapshot.data!["Cost5"]}",style: TextStyle(fontSize: (ScreenH*18)/672,color: Colors.white),),
                                  SizedBox(height: (ScreenH*5)/672,),
                              ],)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: (ScreenH*2)/672,),
                  Container(

                    decoration: BoxDecoration(
                      color: Colors.green[900],
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.money,size: (ScreenH*30)/672,color: Colors.white,),
                              SizedBox(width: (ScreenW*5)/360,),
                              Text("Total Cost : - ",style: TextStyle(fontSize: (ScreenH*20)/672 ,color: Colors.white,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          Container(
                            width: (ScreenW*295)/360,
                            child: Column(  
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Rs ${snapshot.data!["Total Cost"]}",style: TextStyle(fontSize: (ScreenH*20)/672,color: Colors.white,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
              }
              else{
                return Center(child: CircularProgressIndicator(),);
              }
            }
          ),
        ),
      )
    );
  }
}