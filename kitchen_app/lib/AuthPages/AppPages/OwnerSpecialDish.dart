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
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Special Dish",style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.green,
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
                            FirebaseStorage.instance.ref().child("Image").child("SpecialDish").delete();
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OwnerHomePage()));
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Today's Special Dish Removed"),
                                backgroundColor: Colors.redAccent,
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
          Text("")
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
                width: (screenW*300)/360,
                height: (screenH*600)/672,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: (screenH*20)/672,),
                      Container(
                        width: (screenW*280)/360,
                        height: (screenH*200)/672,
                        child: Image.network(snapshot.data!.docs[0]["ImageUrl"],fit: BoxFit.cover,),
                      ),
                      SizedBox(height: (screenH*10)/672,),
                      Container(
                        width: (screenW*300)/360,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: (screenW*10)/360,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text("Type :",style: TextStyle(fontSize: (screenH*23)/672,fontWeight: FontWeight.bold),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("${snapshot.data!.docs[0]["Dish Type"]}",style: TextStyle(fontSize: (screenH*18)/672),),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: (screenH*10)/672,),
                      Container(
                        width: (screenW*300)/360,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(  
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("Description :",style: TextStyle(fontSize: (screenH*23)/672,fontWeight: FontWeight.bold),),
                            ),
                            Container(  
                              child: Padding(  
                                padding: const EdgeInsets.only(left: 10),
                                child: Text("${snapshot.data!.docs[0]["Dish Discription"]} ",style: TextStyle(fontSize: (screenH*18)/672),),
                              ),
                            )  
                          ],  
                        ),
                      ),
                      SizedBox(height: (screenH*10)/672,),
                      Container(
                        width: (screenW*300)/360,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("Cost :",style: TextStyle(fontSize: (screenH*23)/672,fontWeight: FontWeight.bold),),  
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("Rs ${snapshot.data!.docs[0]["Cost"]}",style: TextStyle(fontSize: (screenH*18)/672),),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: (screenH*20)/672,)
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