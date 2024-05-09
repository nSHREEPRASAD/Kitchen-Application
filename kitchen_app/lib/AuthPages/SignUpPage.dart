import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_app/AuthPages/AppPages/kitchenPage.dart';
import 'package:kitchen_app/AuthPages/SignInPage.dart';
import 'package:kitchen_app/AuthPages/AppPages/OwnerHomePage.dart';
import 'package:lottie/lottie.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obs=true;
  bool isLoading=false;
  final _key2=GlobalKey<FormState>();
  final _key3=GlobalKey<FormState>();

  TextEditingController EmailController=TextEditingController();
  TextEditingController PasswordController=TextEditingController();

  @override
  void dispose() {
    EmailController.dispose();
    PasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final _auth=FirebaseAuth.instance;
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Sign Up"),
      ),
      body: isLoading==true?Center(child: CircularProgressIndicator()): Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: (screenH*10)/672,),
              Container(
                width: (screenW*200)/360,
                height: (screenH*200)/672,
                child: Lottie.asset("assets/animations/KitchenAppLoginAnimation.json"),
              ),
              SizedBox(height: (screenH*40)/672,),
              Container(
                width: (screenW*300)/360,
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
                  )
                ),
              ),
              SizedBox(height: (screenH*10)/672,),
              Container(
                width: (screenW*300)/360,
                child: Form(
                  key: _key3,
                  child: TextFormField(
                    controller: PasswordController,
                    obscureText: _obs,
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
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed:(){
                          setState(() {
                            _obs=!_obs;
                          });
                        } , 
                        icon: _obs==true?Icon(Icons.remove_red_eye):Icon(Icons.cancel)),
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
                  )
                ),
              ),
              SizedBox(height: (screenH*15)/672,),
              Container(
                width: (screenW*300)/360,
                child: Row(
                  children: [
                    Text("Already Have an Account ?"),
                    SizedBox(width: (screenW*30)/360,),
                    TextButton(onPressed: (){
                      setState(() {
                        isLoading=true;
                      });
                      Future.delayed(Duration(seconds: 1),(){
                        setState(() {
                          isLoading=false;
                        });
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignIn()));
                      });
                      
                    }, child: Text("Sign In"))
                  ],
                ),
              ),
              SizedBox(height: (screenH*10)/672,),
              Container(
                width: (screenW*300)/360,
                child: ElevatedButton(
                  onPressed: (){
                    if(!_key2.currentState!.validate() || !_key3.currentState!.validate()){
                      return;
                    }
                    else{
                      _auth.createUserWithEmailAndPassword(
                        email: EmailController.text.toString(), 
                        password: PasswordController.text.toString()
                      ).then((value){
                        setState(() {
                          isLoading=true;
                        });

                        Future.delayed(Duration(seconds: 1),(){
                          setState(() {
                          isLoading=false;
                        });
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Kitchen()));
                        });
                      }).onError((error, stackTrace){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("User Already Exists"),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 1),
                          )
                        );
                      });
                    }
                  }, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sign Up")
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