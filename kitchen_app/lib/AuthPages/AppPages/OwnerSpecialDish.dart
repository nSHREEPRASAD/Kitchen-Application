import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_app/AuthPages/AppPages/OwnerHomePage.dart';

class OwnerSpecialDish extends StatefulWidget {
  const OwnerSpecialDish({super.key});

  @override
  State<OwnerSpecialDish> createState() => _OwnerSpecialDishState();
}

class _OwnerSpecialDishState extends State<OwnerSpecialDish> {
  final _firestore =FirebaseFirestore.instance;
  bool isPresent=true;
  bool isPresentDish=false;

  Future<bool> checkCollectionExists() async {
    final snapshot = await _firestore.collection("Special Dish").limit(1).get();
    return snapshot.size > 0;
  }

  checkVal() async{
    final bool collectionExists = await checkCollectionExists();
    if(collectionExists==true){
      setState(() {
        isPresentDish=true;
      });
    }
    else if(collectionExists==false){
      setState(() {
        isPresentDish=false;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkVal();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Special Dish"),
        actions: [
          isPresentDish?
          IconButton(
            onPressed: (){
              showDialog(
                context: context, 
                builder: (context){
                  return Container(
                    child: AlertDialog(
                      title: Text("Do you want to remove Today's Special Dish ?"),
                      actions: [
                        ElevatedButton(
                          onPressed: (){
                            FirebaseFirestore.instance.collection("Special Dish").doc("Today's Dish").delete();
                            setState(() {
                              isPresent=false;
                            });
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OwnerHomePage()));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Today's Special Dish Removed"),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              )
                            );
                          }, 
                          child: Text("Yes")
                        ),
                        ElevatedButton(
                          onPressed: (){
                            Navigator.pop(context);
                          }, 
                          child: Text("No")
                        ),
                      ],
                    ),
                  );
                }
              );
            }, 
            icon: Icon(Icons.delete,color: Colors.red,) 
          ):
          IconButton(
            onPressed: (){

            }, 
            icon: Icon(Icons.dangerous)
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Special Dish").snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
          if(snapshot.hasData)
          {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){
                return Container(
                width: 300,
                height: 600,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        width: 200,
                        height: 200,
                        child: Image.network(snapshot.data!.docs[0]["ImageUrl"],fit: BoxFit.cover,),
                      ),
                      SizedBox(height: 20,),
                      Card(
                        elevation: 10,
                        child: Container(
                          width: 300,
                          height: 50,
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Text("Type :- ${snapshot.data!.docs[0]["Dish Type"]}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Card(
                        elevation: 10,
                        child: Container(
                          width: 300,
                          height: 200,
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Container(
                                width: 280,
                                height: 200,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5,),
                                      Text("Description :- ${snapshot.data!.docs[0]["Dish Discription"]}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                                      SizedBox(height: 5,),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Card(
                        elevation: 10,
                        child: Container(
                          width: 300,
                          height: 50,
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Text("Cost :- Rs ${snapshot.data!.docs[0]["Cost"]}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,)
                    ],
                  ),
                ),
              );
              }
            );
          }
          else {
            return Center(child: CircularProgressIndicator(),);
          }
        }
      )
    );
  }
}