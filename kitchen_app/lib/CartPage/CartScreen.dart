import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_app/Provider/CartProvider.dart';
import 'package:provider/provider.dart';
import 'package:kitchen_app/BillPages/BillScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  String id="";
  Position? currentPosition;
  String? finalCurrentLocation;
  bool loc=false;

  List photo=[
    "https://img.freepik.com/premium-photo/indian-breakfast-dish-poha-white-background_55610-1377.jpg",
    "https://img.freepik.com/premium-photo/upma-made-samolina-rava-south-indian-breakfast-item-which-is-beautifully-arranged-bowl-made-banana-leaf-garnished-with-fried-cashew-nut-napkin-with-white-textured-background_527904-2738.jpg",
    "https://media.istockphoto.com/id/638506124/photo/idli-with-coconut-chutney-and-sambhar.jpg?s=612x612&w=0&k=20&c=ze1ngBM0LY4w9aqWx_tGe2vTAr4uf36elveTDZ83fgw=",
    "https://img.freepik.com/premium-photo/indian-cuisine-chapati-white-background_55610-598.jpg",
  ];
  List FoodNames=[
    "Poha","Upma","Idli Sambar","Chapati"
  ];
  var Costs=[
    40,45,50,8
  ];

  Map<String,dynamic>userMap={};
  late bool isUsermap;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection("Special Dish").doc("Today's Dish").get().then((value){
      setState(() {
        userMap=value.data()!;
      });
    });
  }

  final _key=GlobalKey<FormState>();
  TextEditingController phoneController=TextEditingController();
  @override
  Widget build(BuildContext context) { 
    final dref=FirebaseFirestore.instance.collection("Cart");
    final _firestore=FirebaseFirestore.instance.collection("Orders");
    var c=context.watch<CartProvider>().cart;
    var cQ=context.watch<CartProvider>().cartQuant;
    final _auth=FirebaseAuth.instance;
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    var sum = 0;
    
    // if(c.contains(4) && userMap.isNotEmpty){
    //   for(int i=0;i<c.length;i++)
    //   {
    //     if(c[i]==4)
    //     {
    //       sum=sum+(int.parse(userMap["Cost"])*int.parse(cQ[i]));
    //     }
    //     else{
    //       sum=sum+Costs[c[i]]*int.parse(cQ[i]);
    //     }
    //   }
    // }
    // else{
    //   for(int i=0;i<c.length;i++)
    //   {
    //     sum=sum+Costs[c[i]]*int.parse(cQ[i]);
    //   }
    // }

    Future<int> FinalSum() async{
      if(c.contains(4)){
        for(int i=0;i<c.length;i++)
        {
          if(c[i]==4)
          {
            sum=sum+(int.parse(userMap["Cost"])*int.parse(cQ[i]));
          }
          else{
            sum=sum+Costs[c[i]]*int.parse(cQ[i]);
          }
        }
      }
      else{
        for(int i=0;i<c.length;i++)
        {
          sum=sum+Costs[c[i]]*int.parse(cQ[i]);
        }
      }
      return sum;
    }
    final ans =FinalSum();
    var total;
    ans.then((value){
      setState(() {
        total=value;
      });
    });
    return Scaffold(
      appBar: 
      AppBar(
        title: Text("Cart",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        actions: [
          c.length!=0?
          IconButton(
            onPressed:(){
              showModalBottomSheet(
                isScrollControlled: true,
                context: context, 
                builder: ((context){
                  return StreamBuilder( 
                    stream: FirebaseFirestore.instance.collection("Special Dish").snapshots(),
                    builder: (context,snapshot){
                      return Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                        height: (screenH*350)/672,
                        child: Center(
                          child: Container(
                            width: (screenW*330)/360,
                            height: (screenH*300)/672,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: (screenH*10)/672,),
                                  InkWell(
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on),
                                        SizedBox(width: (screenW*10)/360,),
                                        Text("Share Current Location",style: TextStyle(fontSize: (screenH*20)/672),),
                                      ],
                                    ),
                                    onTap: ()async{
                                      currentPosition = await getposition();
                                      getAddressFromLatLong(currentPosition!.latitude, currentPosition!.longitude);
                                      setState(() {
                                        loc = true;
                                      });
                                    },
                                  ),
                                  SizedBox(height: (screenH*10)/672,),
                                  Container(
                                    // width: (screenW*320)/360,
                                    // height: (screenH*50)/672,
                                    child: loc==true?Text(finalCurrentLocation.toString()):Text("",style: TextStyle(color: Colors.grey),)
                                  ),
                                  SizedBox(height: (screenH*10)/672,),
                                  Container(
                                    width: (screenW*300)/360,
                                    padding: EdgeInsets.only(left: 8,right: 8),
                                    child: Form(
                                      key: _key,
                                      child: TextFormField(
                                        maxLength: 10,
                                        keyboardType: TextInputType.number,
                                        controller: phoneController,
                                        validator: (value) {
                                         if(value!.isEmpty){
                                          return "Please Enter Phone Number";
                                         }
                                         if(value.length!=10){
                                          return "Please Enter Valid Phone Number";
                                         }
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Phone Number",
                                          prefixIcon: Icon(Icons.phone),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(11),
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                              width: (screenW*2)/360,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(11),
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: (screenW*2)/360,
                                            )
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(11),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                              width: (screenW*2)/360,
                                            )
                                          )
                                        ),
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8,right: 8),
                                    child: Text("Total Cost :",style: TextStyle(fontSize: (screenH*20)/672),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8,right: 8,bottom: 8),
                                    child: Column(
                                      children: [
                                        Text("Rs ${total}",style: TextStyle(fontSize: (screenH*15)/672),)
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green
                                    ),
                                    onPressed: (){
                                      if(loc==false)
                                      {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Please Share Current Location"),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 2),
                                          )
                                        );
                                      }
                                      else if(!_key.currentState!.validate()){
                                        return;
                                      }
                                      else{
                                        Navigator.pop(context);
                                        id=DateTime.now().millisecondsSinceEpoch.toString();
                                        if(c.length==1)
                                        {
                                          dref.doc(_auth.currentUser!.uid.toString()).set({
                                          "id":id.toString(),
                                          "UserEmail":_auth.currentUser!.email.toString(),
                                          "Address":finalCurrentLocation.toString(),
                                          "Phone Number":phoneController.text.toString(),
                                          "Item1": (c[0]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[0]<=3)? FoodNames[c[0]] : "",
                                          "Quantity1":cQ[0],
                                          "Cost1": (c[0]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])}" :(c[0]<=3)? "${Costs[c[0]]*int.parse(cQ[0])}" : "",
                                          "Total Cost":(c[0]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])}" :(c[0]<=3)? "${Costs[c[0]]*int.parse(cQ[0])}" : "",
                                        });
                                        _firestore.doc(id).set({
                                          "id":id.toString(),
                                          "UserEmail":_auth.currentUser!.email.toString(),
                                          "Address":finalCurrentLocation.toString(),
                                          "Phone Number":phoneController.text.toString(),
                                          "Item1": (c[0]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[0]<=3)? FoodNames[c[0]] : "",
                                          "Quantity1":cQ[0],
                                          "Cost1": (c[0]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])}" :(c[0]<=3)? "${Costs[c[0]]*int.parse(cQ[0])}" : "",
                                          "Total Cost":(c[0]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])}" :(c[0]<=3)? "${Costs[c[0]]*int.parse(cQ[0])}" : "",
                                          "ItemLength":1
                                        });
                                        }
                                        else if(c.length==2)
                                        {
                                          dref.doc(_auth.currentUser!.uid.toString()).set({
                                          "id":id.toString(),
                                          "UserEmail":_auth.currentUser!.email.toString(),
                                          "Address":finalCurrentLocation.toString(),
                                          "Phone Number":phoneController.text.toString(), 
                                          "Item1": (c[0]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[0]<=3)? FoodNames[c[0]]:"",
                                          "Quantity1":cQ[0],
                                          "Cost1": (c[0]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])}" :(c[0]<=3)? "${Costs[c[0]]*int.parse(cQ[0])}" : "",
                                          "Item2": (c[1]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[1]<=3)? FoodNames[c[1]]:"",
                                          "Quantity2":cQ[1],
                                          "Cost2": (c[1]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[1])}" :(c[1]<=3)? "${Costs[c[1]]*int.parse(cQ[1])}" : "",
                                          "Total Cost": (c[0]==4 && snapshot.hasData)?"${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])}":(c[1]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[1])+Costs[c[0]]*int.parse(cQ[0])}":(c[0]<=3 && c[1]<=3)? "${Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])}":"",
                                        });
                                        _firestore.doc(id).set({
                                          "id":id.toString(),
                                          "UserEmail":_auth.currentUser!.email.toString(),
                                          "Address":finalCurrentLocation.toString(),
                                          "Phone Number":phoneController.text.toString(), 
                                          "Item1": (c[0]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[0]<=3)? FoodNames[c[0]]:"",
                                          "Quantity1":cQ[0],
                                          "Cost1": (c[0]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])}" :(c[0]<=3)? "${Costs[c[0]]*int.parse(cQ[0])}" : "",
                                          "Item2": (c[1]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[1]<=3)? FoodNames[c[1]]:"",
                                          "Quantity2":cQ[1],
                                          "Cost2": (c[1]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[1])}" :(c[1]<=3)? "${Costs[c[1]]*int.parse(cQ[1])}" : "",
                                          "Total Cost": (c[0]==4 && snapshot.hasData)?"${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])}":(c[1]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[1])+Costs[c[0]]*int.parse(cQ[0])}":(c[0]<=3 && c[1]<=3)? "${Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])}":"",
                                          "ItemLength":2
                                        });
                                        }
                                        else if(c.length==3)
                                        {
                                          dref.doc(_auth.currentUser!.uid.toString()).set({
                                          "id":id.toString(),
                                          "UserEmail":_auth.currentUser!.email.toString(),
                                          "Address":finalCurrentLocation.toString(),
                                          "Phone Number":phoneController.text.toString(),
                                          "Item1": (c[0]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[0]<=3)? FoodNames[c[0]]:"",
                                          "Quantity1":cQ[0],
                                          "Cost1": (c[0]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])}" :(c[0]<=3)? "${Costs[c[0]]*int.parse(cQ[0])}" : "",
                                          "Item2": (c[1]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[1]<=3)? FoodNames[c[1]]:"",
                                          "Quantity2":cQ[1],
                                          "Cost2": (c[1]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[1])}" :(c[1]<=3)? "${Costs[c[1]]*int.parse(cQ[1])}" : "",
                                          "Item3": (c[2]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[2]<=3)? FoodNames[c[2]]:"",
                                          "Quantity3":cQ[2],
                                          "Cost3": (c[2]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[2])}" :(c[2]<=3)? "${Costs[c[2]]*int.parse(cQ[2])}" : "",
                                          "Total Cost":(c[0]==4 && snapshot.hasData)?"${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[2]]*int.parse(cQ[2])}":(c[1]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[1])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[2]]*int.parse(cQ[2])}":(c[2]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[2])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])}":(c[0]<=3 && c[1]<=3 && c[2]<=3)? "${Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[2]]*int.parse(cQ[2])}":"",
                                        });
                                        _firestore.doc(id).set({
                                          "id":id.toString(),
                                          "UserEmail":_auth.currentUser!.email.toString(),
                                          "Address":finalCurrentLocation.toString(),
                                          "Phone Number":phoneController.text.toString(),
                                          "Item1": (c[0]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[0]<=3)? FoodNames[c[0]]:"",
                                          "Quantity1":cQ[0],
                                          "Cost1": (c[0]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])}" :(c[0]<=3)? "${Costs[c[0]]*int.parse(cQ[0])}" : "",
                                          "Item2": (c[1]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[1]<=3)? FoodNames[c[1]]:"",
                                          "Quantity2":cQ[1],
                                          "Cost2": (c[1]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[1])}" :(c[1]<=3)? "${Costs[c[1]]*int.parse(cQ[1])}" : "",
                                          "Item3": (c[2]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[2]<=3)? FoodNames[c[2]]:"",
                                          "Quantity3":cQ[2],
                                          "Cost3": (c[2]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[2])}" :(c[2]<=3)? "${Costs[c[2]]*int.parse(cQ[2])}" : "",
                                          "Total Cost":(c[0]==4 && snapshot.hasData)?"${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[2]]*int.parse(cQ[2])}":(c[1]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[1])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[2]]*int.parse(cQ[2])}":(c[2]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[2])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])}":(c[0]<=3 && c[1]<=3 && c[2]<=3)? "${Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[2]]*int.parse(cQ[2])}":"",
                                          "ItemLength":3
                                        });
                                        }
                                        else if(c.length==4)
                                        {
                                          dref.doc(_auth.currentUser!.uid.toString()).set({
                                          "id":id.toString(),
                                          "UserEmail":_auth.currentUser!.email.toString(),
                                          "Address":finalCurrentLocation.toString(),
                                          "Phone Number":phoneController.text.toString(),
                                          "Item1": (c[0]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[0]<=3)? FoodNames[c[0]]:"",
                                          "Quantity1":cQ[0],
                                          "Cost1": (c[0]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])}" :(c[0]<=3)? "${Costs[c[0]]*int.parse(cQ[0])}" : "",
                                          "Item2": (c[1]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[1]<=3)? FoodNames[c[1]]:"",
                                          "Quantity2":cQ[1],
                                          "Cost2": (c[1]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[1])}" :(c[1]<=3)? "${Costs[c[1]]*int.parse(cQ[1])}" : "",
                                          "Item3": (c[2]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[2]<=3)? FoodNames[c[2]]:"",
                                          "Quantity3":cQ[2],
                                          "Cost3": (c[2]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[2])}" :(c[2]<=3)? "${Costs[c[2]]*int.parse(cQ[2])}" : "",
                                          "Item4": (c[3]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[3]<=3)? FoodNames[c[3]]:"",
                                          "Quantity4":cQ[3],
                                          "Cost4": (c[3]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[3])}" :(c[3]<=3)? "${Costs[c[3]]*int.parse(cQ[3])}" : "",
                                          "Total Cost":(c[0]==4 && snapshot.hasData)?"${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[2]]*int.parse(cQ[2])+Costs[c[3]]*int.parse(cQ[3])}":(c[1]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[1])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[2]]*int.parse(cQ[2])+Costs[c[3]]*int.parse(cQ[3])}":(c[2]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[2])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[3]]*int.parse(cQ[3])}":(c[3]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[3])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[2]]*int.parse(cQ[2])}":(c[0]<=3 && c[1]<=3 && c[2]<=3 && c[3]<=3)? "${Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[2]]*int.parse(cQ[2])+Costs[c[3]]*int.parse(cQ[3])}" :"",
                                        });

                                        _firestore.doc(id).set({
                                          "id":id.toString(),
                                          "UserEmail":_auth.currentUser!.email.toString(),
                                          "Address":finalCurrentLocation.toString(),
                                          "Phone Number":phoneController.text.toString(),
                                          "Item1": (c[0]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[0]<=3)? FoodNames[c[0]]:"",
                                          "Quantity1":cQ[0],
                                          "Cost1": (c[0]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])}" :(c[0]<=3)? "${Costs[c[0]]*int.parse(cQ[0])}" : "",
                                          "Item2": (c[1]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[1]<=3)? FoodNames[c[1]]:"",
                                          "Quantity2":cQ[1],
                                          "Cost2": (c[1]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[1])}" :(c[1]<=3)? "${Costs[c[1]]*int.parse(cQ[1])}" : "",
                                          "Item3": (c[2]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[2]<=3)? FoodNames[c[2]]:"",
                                          "Quantity3":cQ[2],
                                          "Cost3": (c[2]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[2])}" :(c[2]<=3)? "${Costs[c[2]]*int.parse(cQ[2])}" : "",
                                          "Item4": (c[3]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[3]<=3)? FoodNames[c[3]]:"",
                                          "Quantity4":cQ[3],
                                          "Cost4": (c[3]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[3])}" :(c[3]<=3)? "${Costs[c[3]]*int.parse(cQ[3])}" : "",
                                          "Total Cost":(c[0]==4 && snapshot.hasData)?"${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[2]]*int.parse(cQ[2])+Costs[c[3]]*int.parse(cQ[3])}":(c[1]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[1])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[2]]*int.parse(cQ[2])+Costs[c[3]]*int.parse(cQ[3])}":(c[2]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[2])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[3]]*int.parse(cQ[3])}":(c[3]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[3])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[2]]*int.parse(cQ[2])}":(c[0]<=3 && c[1]<=3 && c[2]<=3 && c[3]<=3)? "${Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[2]]*int.parse(cQ[2])+Costs[c[3]]*int.parse(cQ[3])}" :"",                      
                                          "ItemLength":4
                                        });
                                        }
                                        else if(c.length==5)
                                        {
                                          dref.doc(_auth.currentUser!.uid.toString()).set({
                                          "id":id.toString(),
                                          "UserEmail":_auth.currentUser!.email.toString(),
                                          "Address":finalCurrentLocation.toString(),
                                          "Phone Number":phoneController.text.toString(),
                                          "Item1": (c[0]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[0]<=3)? FoodNames[c[0]]:"",
                                          "Quantity1":cQ[0],
                                          "Cost1": (c[0]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])}" :(c[0]<=3)? "${Costs[c[0]]*int.parse(cQ[0])}" : "",
                                          "Item2": (c[1]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[1]<=3)? FoodNames[c[1]]:"",
                                          "Quantity2":cQ[1],
                                          "Cost2": (c[1]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[1])}" :(c[1]<=3)? "${Costs[c[1]]*int.parse(cQ[1])}" : "",
                                          "Item3": (c[2]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[2]<=3)? FoodNames[c[2]]:"",
                                          "Quantity3":cQ[2],
                                          "Cost3": (c[2]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[2])}" :(c[2]<=3)? "${Costs[c[2]]*int.parse(cQ[2])}" : "",
                                          "Item4": (c[3]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[3]<=3)? FoodNames[c[3]]:"",
                                          "Quantity4":cQ[3],
                                          "Cost4": (c[3]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[3])}" :(c[3]<=3)? "${Costs[c[3]]*int.parse(cQ[3])}" : "",
                                          "Item5": (c[4]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[4]<=3)? FoodNames[c[4]]:"",
                                          "Quantity5":cQ[4],
                                          "Cost5": (c[4]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[4])}" :(c[4]<=3)? "${Costs[c[4]]*int.parse(cQ[4])}" : "",
                                          "Total Cost":(c[0]==4 && snapshot.hasData)?"${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[2]]*int.parse(cQ[2])+Costs[c[3]]*int.parse(cQ[3])+Costs[c[4]]*int.parse(cQ[4])}":(c[1]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[1])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[2]]*int.parse(cQ[2])+Costs[c[3]]*int.parse(cQ[3])+Costs[c[4]]*int.parse(cQ[4])}":(c[2]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[2])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[3]]*int.parse(cQ[3])+Costs[c[4]]*int.parse(cQ[4])}":(c[3]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[3])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[2]]*int.parse(cQ[2])+Costs[c[4]]*int.parse(cQ[4])}" : (c[4]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[4])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[2]]*int.parse(cQ[2])+Costs[c[3]]*int.parse(cQ[3])}" :"",
                                        });
                                        _firestore.doc(id).set({
                                          "id":id.toString(),
                                          "UserEmail":_auth.currentUser!.email.toString(),
                                          "Address":finalCurrentLocation.toString(),
                                          "Phone Number":phoneController.text.toString(),
                                          "Item1": (c[0]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[0]<=3)? FoodNames[c[0]]:"",
                                          "Quantity1":cQ[0],
                                          "Cost1": (c[0]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])}" :(c[0]<=3)? "${Costs[c[0]]*int.parse(cQ[0])}" : "",
                                          "Item2": (c[1]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[1]<=3)? FoodNames[c[1]]:"",
                                          "Quantity2":cQ[1],
                                          "Cost2": (c[1]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[1])}" :(c[1]<=3)? "${Costs[c[1]]*int.parse(cQ[1])}" : "",
                                          "Item3": (c[2]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[2]<=3)? FoodNames[c[2]]:"",
                                          "Quantity3":cQ[2],
                                          "Cost3": (c[2]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[2])}" :(c[2]<=3)? "${Costs[c[2]]*int.parse(cQ[2])}" : "",
                                          "Item4": (c[3]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[3]<=3)? FoodNames[c[3]]:"",
                                          "Quantity4":cQ[3],
                                          "Cost4": (c[3]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[3])}" :(c[3]<=3)? "${Costs[c[3]]*int.parse(cQ[3])}" : "",
                                          "Item5": (c[4]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[4]<=3)? FoodNames[c[4]]:"",
                                          "Quantity5":cQ[4],
                                          "Cost5": (c[4]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[4])}" :(c[4]<=3)? "${Costs[c[4]]*int.parse(cQ[4])}" : "",
                                          "Total Cost":(c[0]==4 && snapshot.hasData)?"${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[2]]*int.parse(cQ[2])+Costs[c[3]]*int.parse(cQ[3])+Costs[c[4]]*int.parse(cQ[4])}":(c[1]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[1])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[2]]*int.parse(cQ[2])+Costs[c[3]]*int.parse(cQ[3])+Costs[c[4]]*int.parse(cQ[4])}":(c[2]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[2])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[3]]*int.parse(cQ[3])+Costs[c[4]]*int.parse(cQ[4])}":(c[3]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[3])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[2]]*int.parse(cQ[2])+Costs[c[4]]*int.parse(cQ[4])}" : (c[4]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[4])+Costs[c[0]]*int.parse(cQ[0])+Costs[c[1]]*int.parse(cQ[1])+Costs[c[2]]*int.parse(cQ[2])+Costs[c[3]]*int.parse(cQ[3])}" :"",
                                          "ItemLength":5
                                        });
                                        } 
                                        if(c.contains(4)){
                                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Bill(snapshot.data!.docs[0]["Dish Type"],snapshot.data!.docs[0]["Cost"] )));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("Order is Posted"),
                                                backgroundColor: Colors.green,
                                                duration: Duration(seconds: 2),
                                              )
                                            );
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Bill(snapshot.data!.docs[0]["Dish Type"], snapshot.data!.docs[0]["Cost"],id)));
                                        }
                                        else{
                                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Bill("","")));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("Order is Posted"),
                                                backgroundColor: Colors.green,
                                                duration: Duration(seconds: 2),
                                              )
                                            );
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Bill("", "",id)));
                                        }
                                      }
                                    },  
                                    child: Container(
                                      width: (screenW*100)/360,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Place Order",style: TextStyle(color: Colors.white),),
                                        ],
                                      ),
                                    )
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                                          ),
                      );
                    },
                  );
                })
              );
            } , 
            icon: Icon(Icons.send)
          ):
          Text("")
        ],
      ),
      body: c.length==0?Center(child: Text("Empty Cart"))
      :StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Special Dish").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot>snapshot) {
          return ListView.builder(
          itemCount: c.length,
          itemBuilder: (context,index){
            int mul=int.parse(cQ[index]);
            return Padding(
              padding: const EdgeInsets.only(top: 10,left: 5,right: 5),
              child: Card(
                elevation: 6,
                color: Colors.green[900],
                child: Row(
                  children: [
                    SizedBox(width: (screenW*10)/360,),
                    Container(
                      width: (screenW*150)/360,
                      height: (screenH*150)/672,
                      child: ((c[index]==4) && (snapshot.hasData))?Image.network(snapshot.data!.docs[0]["ImageUrl"],fit: BoxFit.cover,):(c[index]<=3)? Image.network(photo[c[index]],fit: BoxFit.cover,):Text("")
                    ),
                    SizedBox(width: (screenW*10)/360,),
                    Container(
                      width: (screenW*170)/360,
                      height: (screenH*170)/672,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: (screenH*10)/672,),
                          ((c[index]==4) && (snapshot.hasData))?
                          Text("${snapshot.data!.docs[0]["Dish Type"]}",style: TextStyle(fontSize: (screenH*20)/672,color: Colors.white),):
                          (c[index]<=3)?
                          Text("Item: ${FoodNames[c[index]]}",style: TextStyle(fontSize: (screenH*20)/672,color: Colors.white),):Text(""),
                          SizedBox(height: (screenH*10)/672,),
                          ((c[index]==4) && (snapshot.hasData))?
                          Text("Quantity: ${cQ[index]}",style: TextStyle(fontSize: (screenH*20)/672,color: Colors.white),):
                          (c[index]<=3)?
                          Text("Quantity: ${cQ[index]}",style: TextStyle(fontSize: (screenH*20)/672,color: Colors.white),):Text(""),
                          SizedBox(height: (screenH*10)/672,),
                          ((c[index]==4) && (snapshot.hasData))?
                          Text("Cost: Rs ${int.parse(snapshot.data!.docs[0]["Cost"])*mul}",style: TextStyle(fontSize: (screenH*20)/672,color: Colors.white),):
                          (c[index]<=3)?
                          Text("Cost: Rs ${Costs[c[index]]*mul}",style: TextStyle(fontSize: (screenH*20)/672,color: Colors.white),):Text(""),
                          Row(
                            children: [
                              SizedBox(width: (screenW*120)/360,),
                              IconButton(onPressed: (){
                                context.read<CartProvider>().removeFromCart(c[index]);
                                context.read<CartProvider>().removeQuant(cQ[index]);
                              }, icon: Icon(Icons.delete,color: Colors.red,))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
              ),
            );
          }
        );
        },
      )
    );
  }
  
  Future<Position> getposition() async{
    LocationPermission? permission;

    permission=await Geolocator.checkPermission();
    if(permission==LocationPermission.denied){
      permission=await Geolocator.requestPermission();
      if(permission==LocationPermission.deniedForever){
        return Future.error("Location Permission Denied !");
      }
    }
    return Geolocator.getCurrentPosition();
  }

  Future getAddressFromLatLong(lat,long) async{
    try{
      List<Placemark> placemark= await placemarkFromCoordinates(lat, long);
      Placemark place=placemark[0];
      finalCurrentLocation="${place.locality},${place.street},${place.subLocality},${place.postalCode},${place.subAdministrativeArea}";
      setState(() {
        loc=true;
      });
    }
    catch(e){
      print(e);
    }
  }
}
