import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kitchen_app/FlashPage/Flash.dart';
import 'package:kitchen_app/Provider/CartProvider.dart';
import 'package:provider/provider.dart';
Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers:[
    ChangeNotifierProvider(create: (_)=>CartProvider()),
  ],
  child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FlashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


