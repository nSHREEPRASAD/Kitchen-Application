import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class CustomerCorner extends StatefulWidget {
  const CustomerCorner({super.key});

  @override
  State<CustomerCorner> createState() => _CustomerCornerState();
}

class _CustomerCornerState extends State<CustomerCorner> {
  final _key1=GlobalKey<FormState>();
  TextEditingController reViewcontroller=TextEditingController();
  String NodeName="";
  @override
  Widget build(BuildContext context) {
    final _auth=FirebaseAuth.instance;
    final dataref=FirebaseDatabase.instance.ref("Reviews");
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer's Corner"),
      ),
      body: Row(
        children: [
          SizedBox(width: 10,),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 340,
                  height: 420,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black
                    ),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: FirebaseAnimatedList(
                    query: dataref,
                    defaultChild: Center(child: Text("Empty",style: TextStyle(color: Colors.grey),)), 
                    itemBuilder:(context,snapshot,animation,index){
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text(snapshot.child("Email Id").value.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle:Text(snapshot.child("Review").value.toString()), 
                          trailing: Icon(Icons.star,color:Colors.amber,),
                        ),
                      );
                    }
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  width: 340,
                  height: 160, 
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black
                    ),
                    borderRadius: BorderRadius.circular(11)
                  ),
                  child: Center(
                    child: Container(
                      width: 320,
                      height: 160,
                      child: SingleChildScrollView(
                        child: Column(
                        children: [
                          Form(
                            key: _key1,
                            child: TextFormField(
                              validator: (value) {
                                if(value!.isNotEmpty){
                                  return null;
                                }
                                else{
                                  return "Please Enter Review";
                                }
                              },
                              controller: reViewcontroller,
                              maxLines: 3,
                              maxLength: 90,
                              decoration: InputDecoration(
                                hintText: "Kitchen's Speciality",
                                enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                    color: Colors.grey
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                    color: Colors.black
                                  )
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                    color: Colors.red
                                  ),
                                ),
                              ),
                            ),
                          ), 
                          ElevatedButton(onPressed: (){
                            if(!_key1.currentState!.validate()){
                              return;
                            }
                            else{
                              NodeName=DateTime.now().millisecondsSinceEpoch.toString();
                              dataref.child(NodeName).set({
                                "Id":_auth.currentUser!.uid.toString(),
                                "Email Id":_auth.currentUser!.email.toString(),
                                "Review":reViewcontroller.text.toString()
                              });
                              reViewcontroller.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Review Posted."),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Colors.green,
                                )
                              );
                            }
                          }, child: Text("Submit Review"))
                        ],
                       ),
                      ),
                    )
                    )
                )
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}