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
    return Scaffold(
      appBar: AppBar(
        title: Text("Special Dish"),
        actions: [
          isPresent?
          ElevatedButton(
            onPressed: (){
              // print("Cart ${cartI}");
              // print("Quantity ${cartQ}");
              TextEditingController c=TextEditingController();
              final key=GlobalKey<FormState>();
              !cartI.contains(4)?
              showDialog(
                context: context, 
                builder: (context){
                  return Container(
                    child: AlertDialog(
                      title: Text("Special Dish"),
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
                            context.read<CartProvider>().addToCart(4);
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
              context.read<CartProvider>().removeQuant(cartQ[findIndex(4,cartI)]);
              context.read<CartProvider>().removeFromCart(4);

            }, 
            child: cartI.contains(4)?Text("Remove"):Text("Add To Cart")):IconButton(onPressed: (){}, icon: Icon(Icons.dangerous))
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
                      SizedBox(height: 10,),
                      Card(
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