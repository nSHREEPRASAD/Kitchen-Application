
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_app/AuthPages/AppPages/CustomerPage.dart';
import 'package:kitchen_app/AuthPages/AppPages/KitchenIntroPage.dart';
import 'package:kitchen_app/AuthPages/AppPages/customerSpecialDish.dart';
import 'package:kitchen_app/AuthPages/SignUpPage.dart';
import 'package:kitchen_app/CartPage/CartScreen.dart';
import 'package:kitchen_app/Provider/CartProvider.dart';
import 'package:provider/provider.dart';

class Kitchen extends StatefulWidget {

  @override
  State<Kitchen> createState() => _KitchenState();
}

class _KitchenState extends State<Kitchen> {
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
  bool isLoading=false;

  @override
  Widget build(BuildContext context) {
    var ct=context.watch<CartProvider>().cart;
    var ctQ=context.watch<CartProvider>().cartQuant;
    FirebaseAuth _auth=FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text("Ghadi's Kitchen"),
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Cart()));
          // ct.clear();
          // ctQ.clear();
          // print("Item: ${ct}");
          // print("Quantity: ${ctQ}");
        },
        child:Icon(Icons.shopping_cart) ,
      ),
      drawer: Drawer(
        elevation: 4,
        width: 330,
        child: ListView(
          children: [
            SizedBox(height: 30,),
            Card(
              elevation: 5,
              child: Container(
                // height: 160,
                child: Row(
                  children: [
                    SizedBox(width: 5,),
                    Container(
                      width: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 10,
                          ),
                          Container(
                            width: 120,
                            height: 100,
                            child: CircleAvatar(
                              child: Icon(Icons.person,size: 80,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // height: 150,
                      width:150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20,),
                          Text(_auth.currentUser!.email.toString(),style: TextStyle(fontSize: 15),),
                          SizedBox(height: 5,),
                          Text("Role : User"),
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
                                ct.clear();
                                ctQ.clear();
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
                            )),
                            SizedBox(height: 10,)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              child: Card(
                elevation: 5,
                child: Container(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(width: 20,),
                      Text("About Ghadi's Kitchen",style: TextStyle(fontSize: 20),)
                    ],
                  ),
                ),
              ),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>KitchenIntro()));
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
                      Text("Customer's Corner",style: TextStyle(fontSize: 20),)
                    ],
                  ),
                ),
              ),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerCorner()));
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
                      Text("Special Dish",style: TextStyle(fontSize: 20),)
                    ],
                  ),
                ),
              ),
              onTap: (){
                Navigator.pop(context);
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
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              shadowColor: Colors.black,
              color: Colors.blueGrey,
              child: Column(
                children: [
                  Image.network(items[index]),
                  SizedBox(height: 0,),
                  // Row(
                  //   children: [
                  //     SizedBox(width: 20,),
                  //     Text(FoodNames[index],style: TextStyle(fontSize: 30,color: Colors.white),),
                  //     SizedBox(width: 20,),
                  //     Text("Rs",style: TextStyle(fontSize: 30,color: Colors.white),),
                  //     SizedBox(width: 5,),
                  //     Text(FoodCost[index].toString(),style: TextStyle(fontSize: 30,color: Colors.white),),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart_checkout,color: Colors.white,))
                  //       ],
                  //     )
                  //   ],
                  // )
                  ListTile(
                    title: Text(FoodNames[index],style: TextStyle(fontSize: 20,color: Colors.white),),
                    subtitle: Text(FoodPrice[index].toString(),style: TextStyle(fontSize: 20,color: Colors.white),),
                    trailing: ElevatedButton(
                      onPressed: (){
                        TextEditingController c=TextEditingController();
                        final key=GlobalKey<FormState>();
                        !ct.contains(index)?
                        showDialog(
                          context: context,
                          builder: (context){
                            return Container(
                              child: AlertDialog(
                                title: Text(FoodNames[index].toString()),
                                content: Form(
                                  key: key,
                                  child: TextFormField(
                                    validator: (value) {
                                      if(value!.isNotEmpty){
                                        return null;
                                      }
                                      else{
                                        return "Please Enter Quantity";
                                      }
                                    },
                                    controller:c,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Enter Quantity"
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(onPressed: (){
                                    if(!key.currentState!.validate()){
                                      return;
                                    }
                                    else{
                                      context.read<CartProvider>().addToCart(index);
                                      context.read<CartProvider>().addQuant(c.text.toString());
                                    // _controller[index].clear();
                                      Navigator.pop(context);
                                    }
                                  }, child: Text("Done"))
                                ],
                              ),
                            );
                          }
                        ):
                        context.read<CartProvider>().removeQuant(ctQ[findIndex(index,ct)]);
                        context.read<CartProvider>().removeFromCart(index);
                        
                        // !CN.contains(FoodNames[index])?
                      }, 
                      child:!ct.contains(index)?Text("Add to cart"):Text("Remove")
                    ),
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
  }
}