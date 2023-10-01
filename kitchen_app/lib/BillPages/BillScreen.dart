import 'package:flutter/material.dart';
import 'package:kitchen_app/AuthPages/AppPages/kitchenPage.dart';
import 'package:kitchen_app/AuthPages/SignUpPage.dart';
import 'package:kitchen_app/Provider/CartProvider.dart';
import 'package:provider/provider.dart';

class Bill extends StatefulWidget {
  var item;
  var cost;

  Bill(
    this.item,
    this.cost,
  );

  @override
  State<Bill> createState() => _BillState(item,cost);
}

class _BillState extends State<Bill> {

  var item;
  var cost;

  _BillState(
    this.item,
    this.cost,
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
          }, child: Text("Back To Shop"))
        ],
      ),
      body: Center(
        child: Card(
          color: Colors.blueGrey,
          elevation: 10,
          shadowColor: Colors.black,
          child: Container(
            width: 320,
            height: 440,
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                  width: 320,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Ghadi's Kitchen ",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                      SizedBox(width: 5,),
                      Icon(Icons.food_bank,size: 30,color: Colors.white),
                    ],
                  ),
                ),
                Text("___________________________",style: TextStyle(fontSize: 25,color: Colors.white),),
                SizedBox(height: 10,),
                Container(
                  width: 300,
                  height: 240,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 200,
                            child:
                            cartindex.length==1? 
                            Column(
                              children: [
                                Text("Item",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                                SizedBox(height: 20,),
        
                                cartindex[0]==4?
                                Text(item.toString(),style: TextStyle(color: Colors.white),):
                                Text(FoodNames[cartindex[0]],style: TextStyle(color: Colors.white))
                              ],
                            ):
                            cartindex.length==2? 
                            Column(
                              children: [
                                Text("Item",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                                SizedBox(height: 20,),
        
                                cartindex[0]==4?
                                Text(item.toString(),style: TextStyle(color: Colors.white)):
                                Text(FoodNames[cartindex[0]],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[1]==4?
                                Text(item.toString(),style: TextStyle(color: Colors.white)):
                                Text(FoodNames[cartindex[1]],style: TextStyle(color: Colors.white)),
                              ],
                            ):
                            cartindex.length==3? 
                            Column(
                              children: [
                                Text("Item",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                                SizedBox(height: 20,),
        
                                cartindex[0]==4?
                                Text(item.toString(),style: TextStyle(color: Colors.white)):
                                Text(FoodNames[cartindex[0]],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[1]==4?
                                Text(item.toString(),style: TextStyle(color: Colors.white)):
                                Text(FoodNames[cartindex[1]],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[2]==4?
                                Text(item.toString(),style: TextStyle(color: Colors.white)):
                                Text(FoodNames[cartindex[2]],style: TextStyle(color: Colors.white)),
                              ],
                            ):
                            cartindex.length==4? 
                            Column(
                              children: [
                                Text("Item",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                                SizedBox(height: 20,),
        
                                cartindex[0]==4?
                                Text(item.toString(),style: TextStyle(color: Colors.white)):
                                Text(FoodNames[cartindex[0]],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[1]==4?
                                Text(item.toString(),style: TextStyle(color: Colors.white)):
                                Text(FoodNames[cartindex[1]],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[2]==4?
                                Text(item.toString(),style: TextStyle(color: Colors.white)):
                                Text(FoodNames[cartindex[2]],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[3]==4?
                                Text(item.toString(),style: TextStyle(color: Colors.white)):
                                Text(FoodNames[cartindex[3]],style: TextStyle(color: Colors.white)),
                              ],
                            ):
                            cartindex.length==5? 
                            Column(
                              children: [
                                Text("Item",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                                SizedBox(height: 20,),
        
                                cartindex[0]==4?
                                Text(item.toString(),style: TextStyle(color: Colors.white)):
                                Text(FoodNames[cartindex[0]],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[1]==4?
                                Text(item.toString(),style: TextStyle(color: Colors.white)):
                                Text(FoodNames[cartindex[1]],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[2]==4?
                                Text(item.toString(),style: TextStyle(color: Colors.white)):
                                Text(FoodNames[cartindex[2]],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[3]==4?
                                Text(item.toString(),style: TextStyle(color: Colors.white)):
                                Text(FoodNames[cartindex[3]],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[4]==4?
                                Text(item.toString(),style: TextStyle(color: Colors.white)):
                                Text(FoodNames[cartindex[4]],style: TextStyle(color: Colors.white)),
                              ],
                            ):
                            Text("")
                          ),
                          Container(
                            width: 100,
                            height: 200,
                            child: 
                            cartindex.length==1?
                            Column(
                              children: [
                                Text("Quantity",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                                SizedBox(height: 20,),
        
                                Text(cartQuantity[0],style: TextStyle(color: Colors.white)),
                              ],
                            ):
                            cartindex.length==2?
                            Column(
                              children: [
                                Text("Quantity",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                                SizedBox(height: 20,),
        
                                Text(cartQuantity[0],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                Text(cartQuantity[1],style: TextStyle(color: Colors.white))
                              ],
                            ):
                            cartindex.length==3?
                            Column(
                              children: [
                                Text("Quantity",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                                SizedBox(height: 20,),
        
                                Text(cartQuantity[0],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                Text(cartQuantity[1],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                Text(cartQuantity[2],style: TextStyle(color: Colors.white))
                              ],
                            ):
                            cartindex.length==4?
                            Column(
                              children: [
                                Text("Quantity",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                                SizedBox(height: 20,),
        
                                Text(cartQuantity[0],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                Text(cartQuantity[1],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                Text(cartQuantity[2],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                Text(cartQuantity[3],style: TextStyle(color: Colors.white)),
                              ],
                            ):
                            cartindex.length==5?
                            Column(
                              children: [
                                Text("Quantity",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                                SizedBox(height: 20,),
        
                                Text(cartQuantity[0],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                Text(cartQuantity[1],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                Text(cartQuantity[2],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                Text(cartQuantity[3],style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                Text(cartQuantity[4],style: TextStyle(color: Colors.white)),
                              ],
                            ):
                            Text("")
                          ),
                          Container(
                            width: 100,
                            height: 200,
                            child: 
                            cartindex.length==1? 
                            Column(
                              children: [
                                Text("Cost",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                                SizedBox(height: 20,),
        
                                cartindex[0]==4?
                                Text("Rs ${int.tryParse(cost)!*int.parse(cartQuantity[0])}",style: TextStyle(color: Colors.white)):
                                Text("Rs ${Costs[cartindex[0]]*int.parse(cartQuantity[0])}",style: TextStyle(color: Colors.white))
                              ],
                            ):
                            cartindex.length==2? 
                            Column(
                              children: [
                                Text("Cost",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                                SizedBox(height: 20,),
        
                                cartindex[0]==4?
                                Text("Rs ${int.tryParse(cost)!*int.parse(cartQuantity[0])}",style: TextStyle(color: Colors.white)):
                                Text("Rs ${Costs[cartindex[0]]*int.parse(cartQuantity[0])}",style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[1]==4?
                                Text("Rs ${int.tryParse(cost)!*int.parse(cartQuantity[1])}",style: TextStyle(color: Colors.white)):
                                Text("Rs ${Costs[cartindex[1]]*int.parse(cartQuantity[1])}",style: TextStyle(color: Colors.white)),
                              ],
                            ):
                            cartindex.length==3? 
                            Column(
                              children: [
                                Text("Cost",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                                SizedBox(height: 20,),
        
                                cartindex[0]==4?
                                Text("Rs ${int.tryParse(cost)!*int.parse(cartQuantity[0])}",style: TextStyle(color: Colors.white)):
                                Text("Rs ${Costs[cartindex[0]]*int.parse(cartQuantity[0])}",style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[1]==4?
                                Text("Rs ${int.tryParse(cost)!*int.parse(cartQuantity[1])}",style: TextStyle(color: Colors.white)):
                                Text("Rs ${Costs[cartindex[1]]*int.parse(cartQuantity[1])}",style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[2]==4?
                                Text("Rs ${int.tryParse(cost)!*int.parse(cartQuantity[2])}",style: TextStyle(color: Colors.white)):
                                Text("Rs ${Costs[cartindex[2]]*int.parse(cartQuantity[2])}",style: TextStyle(color: Colors.white)),
                              ],
                            ):
                            cartindex.length==4? 
                            Column(
                              children: [
                                Text("Cost",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                                SizedBox(height: 20,),
        
                                cartindex[0]==4?
                                Text("Rs ${int.tryParse(cost)!*int.parse(cartQuantity[0])}",style: TextStyle(color: Colors.white)):
                                Text("Rs ${Costs[cartindex[0]]*int.parse(cartQuantity[0])}",style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[1]==4?
                                Text("Rs ${int.tryParse(cost)!*int.parse(cartQuantity[1])}",style: TextStyle(color: Colors.white)):
                                Text("Rs ${Costs[cartindex[1]]*int.parse(cartQuantity[1])}",style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[2]==4?
                                Text("Rs ${int.tryParse(cost)!*int.parse(cartQuantity[2])}",style: TextStyle(color: Colors.white)):
                                Text("Rs ${Costs[cartindex[2]]*int.parse(cartQuantity[2])}",style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[3]==4?
                                Text("Rs ${int.tryParse(cost)!*int.parse(cartQuantity[3])}",style: TextStyle(color: Colors.white)):
                                Text("Rs ${Costs[cartindex[3]]*int.parse(cartQuantity[3])}",style: TextStyle(color: Colors.white)),
                              ],
                            ):
                            cartindex.length==5? 
                            Column(
                              children: [
                                Text("Cost",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                                SizedBox(height: 20,),
        
                                cartindex[0]==4?
                                Text("Rs ${int.tryParse(cost)!*int.parse(cartQuantity[0])}",style: TextStyle(color: Colors.white)):
                                Text("Rs ${Costs[cartindex[0]]*int.parse(cartQuantity[0])}",style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[1]==4?
                                Text("Rs ${int.tryParse(cost)!*int.parse(cartQuantity[1])}",style: TextStyle(color: Colors.white)):
                                Text("Rs ${Costs[cartindex[1]]*int.parse(cartQuantity[1])}",style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[2]==4?
                                Text("Rs ${int.tryParse(cost)!*int.parse(cartQuantity[2])}",style: TextStyle(color: Colors.white)):
                                Text("Rs ${Costs[cartindex[2]]*int.parse(cartQuantity[2])}",style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[3]==4?
                                Text("Rs ${int.tryParse(cost)!*int.parse(cartQuantity[3])}",style: TextStyle(color: Colors.white)):
                                Text("Rs ${Costs[cartindex[3]]*int.parse(cartQuantity[3])}",style: TextStyle(color: Colors.white)),
                                SizedBox(height: 10,),
                                cartindex[4]==4?
                                Text("Rs ${int.tryParse(cost)!*int.parse(cartQuantity[4])}",style: TextStyle(color: Colors.white)):
                                Text("Rs ${Costs[cartindex[4]]*int.parse(cartQuantity[4])}",style: TextStyle(color: Colors.white)),
                              ],
                            ):
                            Text("")
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          SizedBox(width: 20,),
                          Text("Total Cost :-  Rs ${sum}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}