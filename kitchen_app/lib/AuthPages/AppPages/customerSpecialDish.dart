// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:kitchen_app/Provider/CartProvider.dart';
// import 'package:provider/provider.dart';

// class CustomerSpecialDish extends StatefulWidget {
//   const CustomerSpecialDish({super.key});

//   @override
//   State<CustomerSpecialDish> createState() => _CustomerSpecialDishState();
// }

// class _CustomerSpecialDishState extends State<CustomerSpecialDish> {
//   late int index;
//   final _firestore= FirebaseFirestore.instance;
//   bool isPresent=false;

//   Future<bool> checkCollectionExists() async {
//     final snapshot = await _firestore.collection("Special Dish").limit(1).get();
//     return snapshot.size > 0; 
//   }

//   checkVal() async{
//     final bool collectionExists = await checkCollectionExists();
//     if(collectionExists==true){
//       setState(() {
//         isPresent=true;
//       });
//     }
//     else if(collectionExists==false){
//       setState(() {
//         isPresent=false;
//       });
//     }
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     checkVal();
//   }
//   @override
//   Widget build(BuildContext context) {
//     var cartI=context.watch<CartProvider>().cart;
//     var cartQ=context.watch<CartProvider>().cartQuant;
//     final screenW = MediaQuery.of(context).size.width;
//     final screenH = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Special Dish"),
//         actions: [
//           isPresent?
//           ElevatedButton(
//             onPressed: (){
//               // print("Cart ${cartI}");
//               // print("Quantity ${cartQ}");
//               TextEditingController c=TextEditingController();
//               final key=GlobalKey<FormState>();
//               !cartI.contains(4)?
//               showDialog(
//                 context: context, 
//                 builder: (context){
//                   return Container(
//                     child: AlertDialog(
//                       title: Text("Special Dish"),
//                       content: Form(
//                         key: key,
//                         child: TextFormField(
//                           validator: (value) {
//                             if(value!.isNotEmpty){
//                               return null;
//                             }
//                             else{
//                               return "Please Enter Quantity";
//                             }
//                           },
//                             controller:c,
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(
//                               hintText: "Enter Quantity"
//                             ),
//                         ),
//                       ),
//                       actions: [
//                         TextButton(onPressed: (){
//                           if(!key.currentState!.validate()){
//                             return;
//                           }
//                           else{
//                             context.read<CartProvider>().addToCart(4);
//                             context.read<CartProvider>().addQuant(c.text.toString());
//                             // _controller[index].clear();
//                             Navigator.pop(context);
//                           }
//                         }, child: Text("Done"))
//                       ],
//                     ),
//                   );
//                 }
//               ):
//               context.read<CartProvider>().removeQuant(cartQ[findIndex(4,cartI)]);
//               context.read<CartProvider>().removeFromCart(4);

//             }, 
//             child: cartI.contains(4)?Text("Remove"):Text("Add To Cart",style: TextStyle(color: Colors.black ),)):Text("")
//         ],
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection("Special Dish").snapshots(),
//         builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
//           if(snapshot.hasData)
//           {
//             return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context,index){
//                 return Container(
//                 width: (screenW*300)/360,
//                 height: (screenH*600)/672,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       SizedBox(height: (screenH*20)/672,),
//                       Container(
//                         width: (screenW*280)/360,
//                         height: (screenH*200)/672,
//                         child: Image.network(snapshot.data!.docs[0]["ImageUrl"],fit: BoxFit.cover,),
//                       ),
//                       SizedBox(height: (screenH*10)/672,),
//                       Container(
//                         width: (screenW*300)/360,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(width: (screenW*10)/360,),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 10,top: 10),
//                               child: Text("Type :",style: TextStyle(fontSize: (screenH*23)/672,fontWeight: FontWeight.bold),),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 10),
//                               child: Text("${snapshot.data!.docs[0]["Dish Type"]}",style: TextStyle(fontSize: (screenH*18)/672),),
//                             )
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: (screenH*10)/672,),
//                       Container(
//                         width: (screenW*300)/360,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(  
//                               padding: const EdgeInsets.only(left: 10),
//                               child: Text("Description :",style: TextStyle(fontSize: (screenH*23)/672,fontWeight: FontWeight.bold),),
//                             ),
//                             Container(  
//                               child: Padding(  
//                                 padding: const EdgeInsets.only(left: 10),
//                                 child: Text("${snapshot.data!.docs[0]["Dish Discription"]} ",style: TextStyle(fontSize: (screenH*18)/672),),
//                               ),
//                             )  
//                           ],  
//                         ),
//                       ),
//                       SizedBox(height: (screenH*10)/672,),
//                       Container(
//                         width: (screenW*300)/360,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 10),
//                               child: Text("Cost :",style: TextStyle(fontSize: (screenH*23)/672,fontWeight: FontWeight.bold),),  
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 10),
//                               child: Text("Rs ${snapshot.data!.docs[0]["Cost"]}",style: TextStyle(fontSize: (screenH*18)/672),),
//                             )
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: (screenH*20)/672,)
//                     ],
//                   ),
//                 ),
//               );
//               }
//             );
//           }
//           else {
//             return Center(child: CircularProgressIndicator(),);
//           }
//         }
//       )
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
import 'package:flutter/material.dart';
import 'package:kitchen_app/Provider/CartProvider.dart';
import 'package:provider/provider.dart';

class CustomerSpecialDish extends StatefulWidget {
  const CustomerSpecialDish({super.key});

  @override
  State<CustomerSpecialDish> createState() => _CustomerSpecialDishState();
}

class _CustomerSpecialDishState extends State<CustomerSpecialDish> {
  late int index;
  final _firestore= FirebaseFirestore.instance;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    checkVal();
  }
  @override
  Widget build(BuildContext context) {
    var cartI=context.watch<CartProvider>().cart;
    var cartQ=context.watch<CartProvider>().cartQuant;
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
          isPresent?
          findIndex(4, cartI)==-1?
                    ElevatedButton(
                      onPressed: (){
                         setState(() {
                          context.read<CartProvider>().addToCart(4);
                          context.read<CartProvider>().addQuant(1.toString());
                          print(cartI);
                          print(cartQ);
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
                                int newQ=int.parse(cartQ[findIndex(4, cartI)]);
                                newQ++;
                                cartQ[findIndex(4,cartI)]=newQ.toString();
                                print(cartI);
                                print(cartQ);
                              });
                            }, 
                            icon: Icon(Icons.add,color: Colors.white,)
                          ),
                          Text("${cartQ[findIndex(4,cartI)]}",style: TextStyle(color: Colors.white,),),
                          IconButton(
                            iconSize: (screenH*30)/672,
                            onPressed: (){
                              setState(() {
                                int newQ=int.parse(cartQ[findIndex(4, cartI)]);
                                newQ--;
                                if(newQ!=0){
                                  cartQ[findIndex(4, cartI)]=newQ.toString();
                                }
                                else{
                                  context.read<CartProvider>().removeQuant(cartQ[findIndex(4,cartI)]);
                                  context.read<CartProvider>().removeFromCart(4);
                                }
                                print(cartI);
                                print(cartQ);
                              });
                            }, 
                            icon: Icon(Icons.remove,color: Colors.white,)
                          ),
                        ],
                      ),
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