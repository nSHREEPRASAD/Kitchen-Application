
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:kitchen_app/AuthPages/AppPages/CustomerPage.dart';
// import 'package:kitchen_app/AuthPages/AppPages/KitchenIntroPage.dart';
// import 'package:kitchen_app/AuthPages/AppPages/customerSpecialDish.dart';
// import 'package:kitchen_app/AuthPages/SignInPage.dart';
// import 'package:kitchen_app/AuthPages/SignUpPage.dart';
// import 'package:kitchen_app/CartPage/CartScreen.dart';
// import 'package:kitchen_app/Provider/CartProvider.dart';
// import 'package:provider/provider.dart';

// class Kitchen extends StatefulWidget {

//   @override
//   State<Kitchen> createState() => _KitchenState();
// }

// class _KitchenState extends State<Kitchen> {
//   late int index;
//   List items=[
//     "https://img.freepik.com/premium-photo/indian-breakfast-dish-poha-white-background_55610-1377.jpg",
//     "https://img.freepik.com/premium-photo/upma-made-samolina-rava-south-indian-breakfast-item-which-is-beautifully-arranged-bowl-made-banana-leaf-garnished-with-fried-cashew-nut-napkin-with-white-textured-background_527904-2738.jpg",
//     "https://media.istockphoto.com/id/638506124/photo/idli-with-coconut-chutney-and-sambhar.jpg?s=612x612&w=0&k=20&c=ze1ngBM0LY4w9aqWx_tGe2vTAr4uf36elveTDZ83fgw=",
//     "https://img.freepik.com/premium-photo/indian-cuisine-chapati-white-background_55610-598.jpg",
//   ];
//   // TextEditingController QuantityController=TextEditingController();
//   List FoodNames=[
//     "Poha","Upma","Idli Sambar","Chapati"
//   ];
//   List FoodPrice=[
//     "Rs 40","Rs 45","Rs 50","Rs 8"
//   ];
//   var Costs=[
//     40,45,50,8
//   ];
//   bool isLoading=false;
//   FirebaseAuth _auth=FirebaseAuth.instance;
//   Map<String,dynamic> userMap = {};

//   @override
//   void initState() {
//     // TODO: implement initState
//     FirebaseFirestore.instance.collection("Users")
//     .doc(_auth.currentUser!.uid.toString())
//     .get()
//     .then((value) {
//       setState(() {
//         userMap=value.data()!;
//       });
//     },);
//   }
//   @override
//   Widget build(BuildContext context) {
//     var ct=context.watch<CartProvider>().cart;
//     var ctQ=context.watch<CartProvider>().cartQuant;
//     final screenW = MediaQuery.of(context).size.width;
//     final screenH = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Text("Ghadi's Kitchen",style: TextStyle(color: Colors.white),),
//             SizedBox(width: (screenW*10)/360,),
//             Icon(Icons.dining)
//           ],
//         ),
//         backgroundColor: Colors.green,
//         iconTheme: IconThemeData(
//           color: Colors.white
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: (){
//           Navigator.push(context, MaterialPageRoute(builder: (context)=>Cart()));
//           // ct.clear();
//           // ctQ.clear();
//           // print("Item: ${ct}");
//           // print("Quantity: ${ctQ}");
//         },
//         child:Icon(Icons.shopping_cart) ,
//       ),
//       drawer: Drawer(
//         elevation: 4,
//         width: (screenW*300)/360,
//         child: ListView(
//           children: [
//             SizedBox(height: (screenH*20)/672,),
//             Card(
//               elevation: 5,
//               child: Container(
//                 child: ListTile(
//                   leading: CircleAvatar(child: Icon(Icons.person),),
//                   title: userMap.isEmpty?Text("Loading..."):Text("${userMap["Username"]}"),
//                   subtitle: Text("Role : User"),
//                   trailing: IconButton(
//                     onPressed: (){
//                       _auth.signOut().then((value){
//                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignIn()));
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text("User Signed Out."),
//                             backgroundColor: Colors.black,
//                             duration: Duration(seconds: 2),
//                           )
//                         );
//                       });
//                     }, 
//                     icon: Icon(Icons.logout)),
//                 ),
//               ),
//             ),
//             InkWell(
//               child: Card(
//                 elevation: 5,
//                 child: Container(
//                   height: (screenH*50)/672,
//                   child: Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20),
//                         child: Icon(Icons.dining),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 10),
//                         child: Text("About Ghadi's Kitchen",style: TextStyle(fontSize: (screenH*20)/672),),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>KitchenIntro()));
//               },
//             ),
//             InkWell(
//               child: Card(
//                 elevation: 5,
//                 child: Container(
//                   height: (screenH*50)/672,
//                   child: Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20),
//                         child: Icon(Icons.reviews),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 10),
//                         child: Text("Customer's Corner",style: TextStyle(fontSize: (screenH*20)/672),),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerCorner()));
//               },
//             ),
//             InkWell(
//               child: Card(
//                 elevation: 5,
//                 child: Container(
//                   height: (screenH*50)/672,
//                   child: Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20),
//                         child: Icon(Icons.dinner_dining),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 10),
//                         child: Text("Special Dish",style: TextStyle(fontSize: (screenH*20)/672),),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerSpecialDish()));
//               },
//             ),
//           ],
//         ),
//       ),
//       body: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
//         itemCount: 4,
//         itemBuilder: (context,index){
//           return Padding(
//             padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
//             child: Card(
//               elevation: 10,
//               shadowColor: Colors.black,
//               color: Colors.green,
//               child: Column(
//                 children: [
//                   Container(
//                     child: Image.network(items[index])
//                   ),
//                   ListTile(
//                     title: Text(FoodNames[index],style: TextStyle(fontSize: (screenH*20)/672,color: Colors.white),),
//                     subtitle: Text(FoodPrice[index].toString(),style: TextStyle(fontSize: (screenH*20)/672,color: Colors.white),),
//                     trailing: ElevatedButton(
//                       onPressed: (){
//                         TextEditingController c=TextEditingController();
//                         final key=GlobalKey<FormState>();
//                         !ct.contains(index)?
//                         showDialog(
//                           context: context,
//                           builder: (context){
//                             return Container(
//                               child: AlertDialog(
//                                 title: Text(FoodNames[index].toString()),
//                                 content: Form(
//                                   key: key,
//                                   child: TextFormField(
//                                     validator: (value) {
//                                       if(value!.isNotEmpty){
//                                         return null;
//                                       }
//                                       else{
//                                         return "Please Enter Quantity";
//                                       }
//                                     },
//                                     controller:c,
//                                     keyboardType: TextInputType.number,
//                                     decoration: InputDecoration(
//                                       hintText: "Enter Quantity"
//                                     ),
//                                   ),
//                                 ),
//                                 actions: [
//                                   TextButton(onPressed: (){
//                                     if(!key.currentState!.validate()){
//                                       return;
//                                     }
//                                     else{
//                                       context.read<CartProvider>().addToCart(index);
//                                       context.read<CartProvider>().addQuant(c.text.toString());
//                                     // _controller[index].clear();
//                                       Navigator.pop(context);
//                                     }
//                                   }, child: Text("Done"))
//                                 ],
//                               ),
//                             );
//                           }
//                         ):
//                         context.read<CartProvider>().removeQuant(ctQ[findIndex(index,ct)]);
//                         context.read<CartProvider>().removeFromCart(index);
                        
//                         // !CN.contains(FoodNames[index])?
//                       }, 
//                       child:!ct.contains(index)?Text("Add to cart"):Text("Remove")
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         })
//     );
//   }
//   findIndex(value,List arr){
//     for(int i=0;i<arr.length;i++)
//     {
//       if(arr[i]==value){ 
//         index=i;
//         return index;
//       }
      
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_app/AuthPages/AppPages/CustomerPage.dart';
import 'package:kitchen_app/AuthPages/AppPages/KitchenIntroPage.dart';
import 'package:kitchen_app/AuthPages/AppPages/customerSpecialDish.dart';
import 'package:kitchen_app/AuthPages/SignInPage.dart';
import 'package:kitchen_app/AuthPages/SignUpPage.dart';
import 'package:kitchen_app/CartPage/CartScreen.dart';
import 'package:kitchen_app/Provider/CartProvider.dart';
import 'package:provider/provider.dart';

class Kitchen extends StatefulWidget {

  @override
  State<Kitchen> createState() => _KitchenState();
}

class _KitchenState extends State<Kitchen> {
  bool isLoading =false;
  late int index;
  List items=[
    "https://img.freepik.com/premium-photo/indian-breakfast-dish-poha-white-background_55610-1377.jpg",
    "https://img.freepik.com/premium-photo/upma-made-samolina-rava-south-indian-breakfast-item-which-is-beautifully-arranged-bowl-made-banana-leaf-garnished-with-fried-cashew-nut-napkin-with-white-textured-background_527904-2738.jpg",
    "https://media.istockphoto.com/id/638506124/photo/idli-with-coconut-chutney-and-sambhar.jpg?s=612x612&w=0&k=20&c=ze1ngBM0LY4w9aqWx_tGe2vTAr4uf36elveTDZ83fgw=",
    "https://img.freepik.com/premium-photo/indian-cuisine-chapati-white-background_55610-598.jpg",
  ];
  // TextEditingController QuantityController=TextEditingController();
  List FoodNames=[
    "Poha","Upma","Idli Sambar","Chapati"
  ];
  List FoodPrice=[
    "Rs 40","Rs 45","Rs 50","Rs 8"
  ];
  var Costs=[
    40,45,50,8
  ];
  var Count=[
    0,0,0,0
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
    var ct=context.watch<CartProvider>().cart;
    var ctQ=context.watch<CartProvider>().cartQuant;
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Ghadi's Kitchen",style: TextStyle(color: Colors.white),),
            SizedBox(width: (screenW*10)/360,),
            Icon(Icons.dining)
          ],
        ),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Cart()));
        },
        child:Icon(Icons.shopping_cart,color: Colors.white,weight: 500,) ,
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
                  subtitle: Text("Role : User"),
                  trailing: IconButton(
                    onPressed: (){
                      _auth.signOut().then((value){
                        ct.clear();
                        ctQ.clear();
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
                        child: Icon(Icons.dining),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("About Ghadi's Kitchen",style: TextStyle(fontSize: (screenH*20)/672),),
                      )
                    ],
                  ),
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>KitchenIntro()));
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
                        child: Icon(Icons.reviews),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("Customer's Corner",style: TextStyle(fontSize: (screenH*20)/672),),
                      )
                    ],
                  ),
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerCorner()));
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerSpecialDish()));
              },
            ),
          ],
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        itemCount: 4,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
            child: Card(
              elevation: 10,
              shadowColor: Colors.black,
              color: Colors.green[900],
              child: Column(
                children: [
                  Container(
                    child: 
                    Image.network(items[index],fit: BoxFit.cover,)
                  ),
                  ListTile(
                    title: Text(FoodNames[index],style: TextStyle(fontSize: (screenH*20)/672,color: Colors.white),),
                    subtitle: Text(FoodPrice[index].toString(),style: TextStyle(fontSize: (screenH*20)/672,color: Colors.white),),
                    trailing: 
                    findIndex(index, ct)==-1?
                    ElevatedButton(
                      onPressed: (){
                         setState(() {
                          context.read<CartProvider>().addToCart(index);
                          context.read<CartProvider>().addQuant(1.toString());
                          print(ct);
                          print(ctQ);
                        });
                      }, 
                      child:Text("Add to cart",style: TextStyle(color: Colors.black),)
                    ):
                    Container(
                      width: (screenW*120)/360,
                      child: Row(
                        children: [
                          IconButton(
                            iconSize: (screenH*30)/672,
                            onPressed: (){
                              setState(() {
                                int newQ=int.parse(ctQ[findIndex(index, ct)]);
                                newQ++;
                                ctQ[findIndex(index,ct)]=newQ.toString();
                                print(ct);
                                print(ctQ);
                              });
                            }, 
                            icon: Icon(Icons.add,color: Colors.white,)
                          ),
                          Text("${ctQ[findIndex(index,ct)]}",style: TextStyle(color: Colors.white,),),
                          IconButton(
                            iconSize: (screenH*30)/672,
                            onPressed: (){
                              setState(() {
                                int newQ=int.parse(ctQ[findIndex(index, ct)]);
                                newQ--;
                                if(newQ!=0){
                                  ctQ[findIndex(index, ct)]=newQ.toString();
                                }
                                else{
                                  context.read<CartProvider>().removeQuant(ctQ[findIndex(index,ct)]);
                                  context.read<CartProvider>().removeFromCart(index);
                                }
                                
                                print(ct);
                                print(ctQ);
                              });
                            }, 
                            icon: Icon(Icons.remove,color: Colors.white,)
                          ),
                        ],
                      ),
                    )
                  )
                ],
              ),
            ),
          );
        })
    );
  }
  findIndex(value,List arr){
    for(int i=0;i<arr.length;i++)
    {
      if(arr[i]==value){ 
        index=i;
        return index;
      }
      
    }
    return -1;
  }
}