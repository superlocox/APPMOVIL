
import 'carrito.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class OrderItem{
  final id;
  final amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    this.id,
    this.amount,
    this.products,
    this.dateTime

  });


}

class Orders with ChangeNotifier{
  List<OrderItem> _orders= [];

  List<OrderItem> get orders{
    return[..._orders];
  }

  Future<void> addOrder(user, List<CartItem> cartProducts, pago) async{
    final url = "http://10.128.128.35:4000/pedido_api";
    final url1 = "https://sade-app.herokuapp.com/pedido_api";
    final timeStamp = DateTime.now();
   // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map data = {
      'user': user,
      'cart': cartProducts,
      'pago': pago,
    };
    var jsonResponse = null;


    //var response = await http.post("http://10.0.0.7:4000/pedido_api", body: data);

    var response = await http.post( url, body: data);


   // final response = await http.post('http://10.0.0.7:4000/pedido_api',body: data);

    jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {

      Fluttertoast.showToast(msg: "Pedido Realizado");

    }else if(response.statusCode == 400){

      Fluttertoast.showToast(msg: "No tienes ningún artículo agregado");

    }else{
      final mensaje = response.body.toString();
      Fluttertoast.showToast( msg: mensaje);
      print(response.body);
    }


    notifyListeners();





  }
}