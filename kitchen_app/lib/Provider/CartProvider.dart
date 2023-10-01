import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier{

  List cart=[];
  List cartQuant=[];

  addToCart(index){
    cart.add(index);
    notifyListeners();
  }
  removeFromCart(index){
    cart.remove(index);
    notifyListeners();
  }

  addQuant(value){
    cartQuant.add(value);
  }
  removeQuant(value){
    cartQuant.remove(value);
  }
}