
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


  final _key=GlobalKey<FormState>();
  TextEditingController phoneController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final dref=FirebaseDatabase.instance.ref("Cart");
    var c=context.watch<CartProvider>().cart;
    var cQ=context.watch<CartProvider>().cartQuant;
    final _auth=FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        actions: [
          IconButton(
            onPressed:(){
              c.length==0?
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Cart is Empty !"),
                  duration: Duration(seconds: 1),
                  backgroundColor: Colors.red,
                )
              ):
              showModalBottomSheet(
                isScrollControlled: true,
                context: context, 
                builder: ((context){
                  return StreamBuilder( 
                    stream: FirebaseFirestore.instance.collection("Special Dish").snapshots(),
                    builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
                      return Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                        height: 300,
                        child: Center(
                          child: Container(
                            width: 330,
                            height: 270,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10,),
                                  InkWell(
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on),
                                        SizedBox(width: 10,),
                                        Text("Share Current Location",style: TextStyle(fontSize: 20),),
                                      ],
                                    ),
                                    onTap: ()async{
                                      currentPosition = await getposition();
                                      await getAddressFromLatLong(currentPosition!.latitude, currentPosition!.longitude);
                                      setState(() {
                                        loc = true;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    width: 320,
                                    height: 50,
                                    child: loc==true?Text(finalCurrentLocation.toString()):Text("User Location",style: TextStyle(color: Colors.grey),)
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    width: 300,
                                    padding: EdgeInsets.all(8),
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
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(11),
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 2,
                                            )
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(11),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                              width: 2,
                                            )
                                          )
                                        ),
                                      )
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  ElevatedButton(
                                    onPressed: (){
                                      if(!_key.currentState!.validate()){
                                        return;
                                      }
                                      else if(loc==false)
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
                                      else{
                                        Navigator.pop(context);
                                        id=DateTime.now().millisecondsSinceEpoch.toString();
                                        if(c.length==1)
                                        {
                                          dref.child(id).set({
                                          "id":id.toString(),
                                          "UserEmail":_auth.currentUser!.email.toString(),
                                          "Address":finalCurrentLocation.toString(),
                                          "Phone Number":phoneController.text.toString(),
                                          "Item1": (c[0]==4 && snapshot.hasData)? snapshot.data!.docs[0]["Dish Type"]:(c[0]<=3)? FoodNames[c[0]] : "",
                                          "Quantity1":cQ[0],
                                          "Cost1": (c[0]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])}" :(c[0]<=3)? "${Costs[c[0]]*int.parse(cQ[0])}" : "",
                                          "Total Cost":(c[0]==4 && snapshot.hasData)? "${int.parse(snapshot.data!.docs[0]["Cost"])*int.parse(cQ[0])}" :(c[0]<=3)? "${Costs[c[0]]*int.parse(cQ[0])}" : "",
                                        });
                                        }
                                        else if(c.length==2)
                                        {
                                          dref.child(id).set({
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
                                        }
                                        else if(c.length==3)
                                        {
                                          dref.child(id).set({
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
                                        }
                                        else if(c.length==4)
                                        {
                                          dref.child(id).set({
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
                                        }
                                        else if(c.length==5)
                                        {
                                          dref.child(id).set({
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
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Bill(snapshot.data!.docs[0]["Dish Type"], snapshot.data!.docs[0]["Cost"])));
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
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Bill("", "")));
                                        }
                                      }
                                    },  
                                    child: Row(
                                      children: [
                                        Text("Place Order"),
                                      ],
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
          )
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
            return Card(
              elevation: 6,
              color: Colors.blueGrey,
              child: Row(
                children: [
                  SizedBox(width: 10,),
                  Container(
                    width: 150,
                    height: 170,
                    child: ((c[index]==4) && (snapshot.hasData))?Image.network(snapshot.data!.docs[0]["ImageUrl"]):(c[index]<=3)? Image.network(photo[c[index]]):Text("")
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: 170,
                    height: 170,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        ((c[index]==4) && (snapshot.hasData))?
                        Text("${snapshot.data!.docs[0]["Dish Type"]}",style: TextStyle(fontSize: 20,color: Colors.white),):
                        (c[index]<=3)?
                        Text("Item: ${FoodNames[c[index]]}",style: TextStyle(fontSize: 20,color: Colors.white),):Text(""),
                        SizedBox(height: 10,),
                        ((c[index]==4) && (snapshot.hasData))?
                        Text("Quantity: ${cQ[index]}",style: TextStyle(fontSize: 20,color: Colors.white),):
                        (c[index]<=3)?
                        Text("Quantity: ${cQ[index]}",style: TextStyle(fontSize: 20,color: Colors.white),):Text(""),
                        SizedBox(height: 10,),
                        ((c[index]==4) && (snapshot.hasData))?
                        Text("Cost: Rs ${int.parse(snapshot.data!.docs[0]["Cost"])*mul}",style: TextStyle(fontSize: 20,color: Colors.white),):
                        (c[index]<=3)?
                        Text("Cost: Rs ${Costs[c[index]]*mul}",style: TextStyle(fontSize: 20,color: Colors.white),):Text(""),
                        Row(
                          children: [
                            SizedBox(width: 120,),
                            IconButton(onPressed: (){
                              context.read<CartProvider>().removeFromCart(c[index]);
                              context.read<CartProvider>().removeQuant(cQ[index]);
                            }, icon: Icon(Icons.delete,color: Colors.white,))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )
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