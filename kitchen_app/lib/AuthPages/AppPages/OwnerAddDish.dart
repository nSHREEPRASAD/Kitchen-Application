import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OwnerAddDish extends StatefulWidget {
  const OwnerAddDish({super.key});

  @override
  State<OwnerAddDish> createState() => _OwnerAddDishState();
}

class _OwnerAddDishState extends State<OwnerAddDish> {

  String dropDownValue="Lunch";

  final _key=GlobalKey<FormState>();
  TextEditingController descriptionController=TextEditingController();

  final _key1=GlobalKey<FormState>();
  TextEditingController costController=TextEditingController();

  final fdb=FirebaseFirestore.instance.collection("Special Dish").doc("Today's Dish");
  String imgUrl="";
  String photo="";
  bool isUploaded=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Dish"),
      ),
      body:Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        child:isUploaded==false? Icon(Icons.food_bank,size: 200,color: Colors.grey,):Image.file(File(photo))
                      ),
                      Positioned(
                        left: 130,
                        bottom: 10,
                        child: Icon(Icons.add_a_photo_sharp,size: 50,)
                      )
                    ],
                  )
                ),
                onTap: (){
                  photo.isNotEmpty?
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Photo Already Uploaded"),
                      backgroundColor: Colors.amber,
                      duration: Duration(seconds: 1),
                    )
                  ):
                  showModalBottomSheet(
                    context: context, 
                    builder: (context){
                      return Container(
                        height: 150,
                        child: Center(
                          child: Container(
                            width: 320,
                            height: 100,
                            child: Column(
                              children: [
                                InkWell(
                                  child: Row(
                                    children: [
                                      Icon(Icons.camera),
                                      SizedBox(width: 10,),
                                      Text("Capture From Camera",style: TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                  onTap: ()async{
                                    Navigator.pop(context);
                                    ImagePicker imagePicker=ImagePicker();
                                    XFile? file=await imagePicker.pickImage(source:ImageSource.camera );
        
                                    setState(() {
                                      photo=file!.path;
                                      isUploaded=true;
                                    });
                                    if(file==null) return;
                                    String img=DateTime.now().millisecondsSinceEpoch.toString();
                                    Reference refRoot=FirebaseStorage.instance.ref();
                                    Reference refDir=refRoot.child("Image");
                                    Reference refImg=refDir.child(img);
        
                                    try{
                                      await refImg.putFile(File(file.path));
                                      imgUrl=await refImg.getDownloadURL();
                                    }
                                    catch(e){
                                      //error
                                    }
                                  },
                                ),
                                SizedBox(height: 25,),
                                InkWell(
                                  child: Row(
                                    children: [
                                      Icon(Icons.image),
                                      SizedBox(width: 10,),
                                      Text("Choose From Gallery",style: TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                  onTap: () async{
                                    Navigator.pop(context);
                                    ImagePicker imagePicker=ImagePicker();
                                    XFile? file=await imagePicker.pickImage(source: ImageSource.gallery);
                                    
                                    setState(() {
                                      photo=file!.path;
                                      isUploaded=true;
                                    });
                                    if(file==null) return;
        
                                    String img=DateTime.now().millisecondsSinceEpoch.toString();
                                    Reference refRoot=FirebaseStorage.instance.ref();
                                    Reference refDir=refRoot.child("Image");
                                    Reference refImg=refDir.child(img);
        
                                    try{
                                      await refImg.putFile(File(file.path));
                                      imgUrl= await refImg.getDownloadURL();
                                    }
                                    catch(e){
                                      //error
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  );
                },
              ),
              SizedBox(height: 20,),
              Container(
                width: 300,
                child: DropdownButton(
                  isExpanded: true,
                  value: dropDownValue,
                  items: [
                    DropdownMenuItem(
                      child: Text("Lunch"),
                      value: "Lunch",
                    ),
                    DropdownMenuItem(
                      child: Text("Dinner"),
                      value: "Dinner",
                    )
                  ], 
                  onChanged: (String? newValue){
                    setState(() {
                      dropDownValue=newValue!;
                    });
                  }
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: 300,
                child: Form(
                  key: _key1,
                  child: TextFormField(
                    controller: costController,
                    validator: (value) {
                      if(value!.isNotEmpty){
                        return null;
                      }
                      else{
                        return "Please Enter Cost";
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Cost",
                      prefixIcon: Icon(Icons.money),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2,
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                          color: Colors.black,
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
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: 300,
                child: Form(
                  key: _key,
                  child: TextFormField(
                    controller: descriptionController,
                    validator: (value) {
                      if(value!.isNotEmpty)
                      {
                        return null;
                      }
                      else{
                        return "Please Enter Dish Discription";
                      }
                    },
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: "Special Dish Description",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        )
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                          color: Colors.grey
                        )
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                          color: Colors.red,
                        )
                      )
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: 50,
                width: 300,
                child: ElevatedButton(
                  onPressed: (){
                    if(!_key.currentState!.validate() || !_key1.currentState!.validate())
                    {
                      return;
                    }
                    else{
                      fdb.set({
                        "ImageUrl":imgUrl.toString(),
                        "Dish Type":dropDownValue.toString(),
                        "Dish Discription":descriptionController.text.toString(),
                        "Cost":costController.text.toString(),
                      }).then((value){
                        setState(() {
                          isUploaded=false;
                          descriptionController.clear();
                          costController.clear();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:Text("Special Dish Posted"),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 3), 
                          )
                        );
                      });
                    }
                  }, 
                  child:Row(
                    children: [
                      SizedBox(width: 20,),
                      Icon(Icons.send),
                      SizedBox(width: 20,),
                      Text("Post Dish",style: TextStyle(fontSize: 20),)
                    ],
                  ) 
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}