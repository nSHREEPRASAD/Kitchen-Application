import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_app/AuthPages/AppPages/OwnerAddDish.dart';
import 'package:kitchen_app/AuthPages/AppPages/OwnerReadReviews.dart';
import 'package:kitchen_app/AuthPages/AppPages/OwnerReceiveOrders.dart';
import 'package:kitchen_app/AuthPages/AppPages/OwnerSpecialDish.dart';
import 'package:kitchen_app/AuthPages/SignUpPage.dart';

class OwnerHomePage extends StatefulWidget {
  const OwnerHomePage({super.key});

  @override
  State<OwnerHomePage> createState() => __OwnerHomePageState();
}

class __OwnerHomePageState extends State<OwnerHomePage> {
  int _currentindex=0;

  List<Widget> Screens=[
    OwnerAddDish(),
    OwnerReceiveOrders(),
  ];
  @override
  Widget build(BuildContext context) {
    final _auth=FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      drawer: Drawer(
        elevation: 4,
        width: 300,
        child: ListView(
          children: [
            SizedBox(height: 30,),
            Card(
              elevation: 5,
              child: Container(
                height: 150,
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      height: 100,
                      child: CircleAvatar(
                        child: Icon(Icons.person,size: 80,),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      width: 150,
                      height: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Owner@hotmail.com",style: TextStyle(fontSize: 15),),
                          SizedBox(height: 5,),
                          Text("Role : Owner"),
                          SizedBox(height: 10,),
                          ElevatedButton(
                            onPressed: (){
                              _auth.signOut().then((value){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Account Signed Out !"),
                                    duration: Duration(seconds: 1),
                                  )
                                );
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp()));
                              });
                            }, 
                            child: Row(
                              children: [
                                SizedBox(width: 2,),
                                Icon(Icons.logout),
                                SizedBox(width: 5,),
                                Text("Sign Out"),
                              ],
                            )
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 30,),
            InkWell(
              child: Card(
                elevation: 5,
                child: Container(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(width: 20,),
                      Text("Customer Reviews",style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
              ),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>OwnerReadReviews()));
              },
            ),
            InkWell(
              child: Card(
                elevation: 5,
                child: Container(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(width: 20,),
                      Text("Special Dish",style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
              ),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>OwnerSpecialDish()));
              },
            ),
          ],
        ),
      ),
      body: Screens[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:_currentindex, 
        selectedFontSize: 15,      
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add Special Item",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_sharp),
            label: "Orders",
          )
        ],
        onTap: (index){
          setState(() {
            _currentindex=index;
          });
        },
      ),
    );
  }
}