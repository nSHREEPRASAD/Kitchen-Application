import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_app/AuthPages/SignUpPage.dart';
import 'package:lottie/lottie.dart';

import 'AppPages/kitchenPage.dart';
import 'package:kitchen_app/AuthPages/AppPages/OwnerHomePage.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool _obscure=true;
  bool isLoading=false;
  final _key2=GlobalKey<FormState>();
  final _key3=GlobalKey<FormState>();

  TextEditingController EmailController=TextEditingController();
  TextEditingController PasswordController=TextEditingController();
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  @override
  Widget build(BuildContext context) {
    final _auth=FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("SignIn"),
      ),
      body: isLoading==true?Center(child: CircularProgressIndicator()):Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              Container(
                width: 200,
                height: 200,
                child: Lottie.asset("assets/animations/KitchenAppLoginAnimation.json"),
              ),
              SizedBox(height: 40,),
              Container(
                width: 300,
                child: Form(
                  key: _key2,
                  child: TextFormField(
                    controller: EmailController,
                    validator: (value) {
                      if(value!.isNotEmpty){
                        return null;
                      }
                      else{
                        return "Please Enter Email Address";
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email Address",
                      prefixIcon: Icon(Icons.email),
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
                  )
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: 300,
                child: Form(
                  key: _key3,
                  child: TextFormField(
                    controller: PasswordController,
                    obscureText: _obscure,
                    validator: (value) {
                      if(value!.isNotEmpty){
                        return null;
                      }
                      else{
                        return "Please Enter Password";
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          _obscure=!_obscure;
                        });
                      }, 
                      icon: _obscure==true? Icon(Icons.remove_red_eye):Icon(Icons.cancel)
                      ),
                      prefixIcon: Icon(Icons.lock),
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
                  )
                ),
              ),
              SizedBox(height: 15,),
              Container(
                width: 300,
                child: Row(
                  children: [
                    Text("Don't Have an Account ?"),
                    SizedBox(width: 30,),
                    TextButton(onPressed: (){
                      setState(() {
                        isLoading=true;
                      });
                      Future.delayed(Duration(seconds: 1),(){
                        setState(() {
                          isLoading=false;
                        });
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp()));
                      });
                    }, child: Text("Sign Up"))
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: 300,
                child: ElevatedButton(
                  onPressed: (){
                    _auth.signInWithEmailAndPassword(
                      email: EmailController.text.toString(),
                      password: PasswordController.text.toString(),
                    ).then((value){
                      setState(() {
                        isLoading=true;
                      });
                      Future.delayed(Duration(seconds: 1),(){
                        setState(() {
                          isLoading=false;
                        });
                        if(_auth.currentUser!.uid=="ZmMUZWvb4td0RKvhOoHSD34QCIo2")
                        {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OwnerHomePage()));
                        }
                        else
                        {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Kitchen()));
                        }
                      });
                    }).onError((error, stackTrace){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Incorrect Username or password"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 1),
                        )
                      );
                    });
                  }, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sign In")
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