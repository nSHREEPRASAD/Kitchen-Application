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
  String FilePath = "";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Dish",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body:Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: (screenH*10)/672,),
              InkWell(
                child: Card(
                  elevation: 2,
                  child: Container(
                    width: (screenW*300)/360,
                    height: (screenH*200)/672,
                    child: Stack(
                      children: [
                        Container(
                          width: (screenW*300)/360,
                          height: (screenH*200)/672,
                          child: photo.isEmpty? Center(child: Icon(Icons.food_bank,size: (screenH*200)/672,color: Colors.grey,)):Image.file(File(photo),fit: BoxFit.cover,)
                        ),
                        Positioned(
                          left:(screenH*230)/672,
                          bottom: (screenH*10)/672,
                          child: Icon(Icons.add_a_photo_sharp,size: (screenH*50)/672,color: Colors.blueGrey,)
                        ),
                        photo.isNotEmpty?
                        Positioned(
                          left:(screenH*250)/672,
                          top: (screenH*10)/672,
                          child: IconButton(
                            onPressed: (){
                              setState(() {
                                photo="";
                              });
                            }, 
                            icon: Icon(Icons.cancel,size: (screenH*30)/672,color: Colors.blueGrey,)
                          )
                        ):
                        Text("")
                      ],
                    )
                  ),
                ),
                onTap: (){
                  showModalBottomSheet(
                    context: context, 
                    builder: (context){
                      return Container(
                        height: (screenH*150)/672,
                        child: Center(
                          child: Container(
                            width: (screenW*320)/360,
                            height: (screenH*100)/672,
                            child: Column(
                              children: [
                                InkWell(
                                  child: Row(
                                    children: [
                                      Icon(Icons.camera),
                                      SizedBox(width: (screenW*10)/360,),
                                      Text("Capture From Camera",style: TextStyle(fontSize: (screenH*20)/672),),
                                    ],
                                  ),
                                  onTap: ()async{
                                    Navigator.pop(context);
                                    if(photo.isNotEmpty){
                                      setState(() {
                                        photo="";
                                      });
                                    }
                                    ImagePicker imagePicker=ImagePicker();
                                    XFile? file=await imagePicker.pickImage(source:ImageSource.camera );
        
                                    setState(() {
                                      photo=file!.path;
                                    });
                                  },
                                ),
                                SizedBox(height: (screenH*25)/672,),
                                InkWell(
                                  child: Row(
                                    children: [
                                      Icon(Icons.image),
                                      SizedBox(width: (screenW*10)/360,),
                                      Text("Choose From Gallery",style: TextStyle(fontSize: (screenH*20)/672),),
                                    ],
                                  ),
                                  onTap: () async{
                                    Navigator.pop(context);
                                    if(photo.isNotEmpty){
                                      setState(() {
                                        photo="";
                                      });
                                    }
                                    ImagePicker imagePicker=ImagePicker();
                                    XFile? file=await imagePicker.pickImage(source: ImageSource.gallery);
                                    
                                    setState(() {
                                      photo=file!.path;
                                    });
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
              SizedBox(height: (screenH*20)/672,),
              Container(
                width: (screenW*300)/360,
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
              SizedBox(height: (screenH*20)/672,),
              Container(
                width: (screenW*300)/360,
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
                          width: (screenW*2)/360,
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                          color: Colors.black,
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
                  ),
                ),
              ),
              SizedBox(height: (screenH*20)/672,),
              Container(
                width: (screenW*300)/360,
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
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Special Dish Description",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: (screenW*2)/360,
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
              SizedBox(height: (screenH*20)/672,),
              Container(
                height: (screenH*50)/672,
                width: (screenW*300)/360,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green
                  ),
                  onPressed: () async{
                    try{
                      FirebaseStorage.instance.ref().child("Image").child("SpecialDish").delete();
                    }
                    catch(err){
                      //error
                    }
                    if(photo.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please Add Dish-Image"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        )
                      );
                    }
                    else if(!_key1.currentState!.validate() || !_key.currentState!.validate()){
                      return;
                    }
                    else{
                      setState(() {
                        isLoading=true;
                      });
                      Future.delayed(Duration(seconds: 7),() {
                        setState(() {
                          isLoading=false;
                        });
                      },);
                        String img="SpecialDish";
                        Reference refRoot=FirebaseStorage.instance.ref();
                        Reference refDir=refRoot.child("Image");
                        Reference refImg=refDir.child(img);
        
                        try{
                          await refImg.putFile(File(photo));
                          imgUrl=await refImg.getDownloadURL();
                        }
                        catch(e){
                          //error
                        }
                      fdb.set({
                        "ImageUrl":imgUrl.toString(),
                        "Dish Type":dropDownValue.toString(),
                        "Dish Discription":descriptionController.text.toString(),
                        "Cost":costController.text.toString(),
                      }).then((value){
                        setState(() {
                          descriptionController.clear();
                          costController.clear();
                          setState(() {
                            photo="";
                          });
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
                  child:
                  isLoading==true?
                  Center(child: CircularProgressIndicator(color: Colors.white,),):
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Post Dish",style: TextStyle(fontSize: (screenH*20)/672,color: Colors.white),),
                      SizedBox(width: (screenW*15)/672,),
                      Icon(Icons.send,color: Colors.white,),
                    ],
                  ) 
                ),
              ),
              SizedBox(height: (screenH*10)/672,)
            ],
          ),
        ),
      )
    );
  }
}