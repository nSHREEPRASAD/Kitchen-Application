import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_app/AuthPages/AppPages/OwnerAddDish.dart';
import 'package:kitchen_app/AuthPages/AppPages/OwnerReadReviews.dart';
import 'package:kitchen_app/AuthPages/AppPages/OwnerReceiveOrders.dart';
import 'package:kitchen_app/AuthPages/AppPages/OwnerSpecialDish.dart';
import 'package:kitchen_app/AuthPages/SignInPage.dart';
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
  FirebaseAuth _auth=FirebaseAuth.instance;
  Map<String,dynamic> userMap = {};

  @override
  void initState() {
    // TODO: implement initState
    FirebaseFirestore.instance.collection("Users")
    .doc(_auth.currentUser!.uid.toString())
    .get()
    .then((value) {
      setState(() {
        userMap=value.data()!;
      });
    },);
  }
  @override
  Widget build(BuildContext context) {
    final _auth=FirebaseAuth.instance;
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      drawer: Drawer(
        elevation: 4,
        width: (screenW*300)/360,
        child: ListView(
          children: [
            SizedBox(height: (screenH*20)/672,),
            Card(
              elevation: 5,
              child: Container(
                child: ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person),),
                  title: userMap.isEmpty?Text("Loading..."):Text("${userMap["Username"]}"),
                  subtitle: Text("Role : Owner"),
                  trailing: IconButton(
                    onPressed: (){
                      _auth.signOut().then((value){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignIn()));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("User Signed Out."),
                            backgroundColor: Colors.black,
                            duration: Duration(seconds: 2),
                          )
                        );
                      });
                    }, 
                    icon: Icon(Icons.logout)),
                ),
              ),
            ),
            InkWell(
              child: Card(
                elevation: 5,
                child: Container(
                  height: (screenH*50)/672,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Icon(Icons.reviews),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("Customer Reviews",style: TextStyle(fontSize: (screenH*20)/672),),
                      )
                    ],
                  ),
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>OwnerReadReviews()));
              },
            ),
            InkWell(
              child: Card(
                elevation: 5,
                child: Container(
                  height: (screenH*50)/672,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Icon(Icons.dinner_dining),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("Special Dish",style: TextStyle(fontSize: (screenH*20)/672),),
                      )
                    ],
                  ),
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>OwnerSpecialDish()));
              },
            ),
          ],
        ),
      ),
      body: Screens[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:_currentindex, 
        selectedFontSize: (screenH*15)/672,   
        selectedIconTheme: IconThemeData(
          size: (screenH*30)/672
        ),   
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