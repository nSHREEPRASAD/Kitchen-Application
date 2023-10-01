import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kitchen_app/AuthPages/SignUpPage.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({super.key});

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 4), () { 
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 100,),
            Container(
              width: 250,
              height: 250,
              child: Image.network("https://m.media-amazon.com/images/I/81n-ZmsFPeL.jpg")
            ),
            SizedBox(height: 20,),
            Text("Ghade's",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 80,color: Colors.purple),),
            Text("Kitchen",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 80,color: Colors.purple),)
          ],
        )
      ),
    );
  }
}