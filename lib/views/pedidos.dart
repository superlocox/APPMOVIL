import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http ;

import 'loginPage.dart';

class pedidos extends StatefulWidget {
  @override
  _pedidosState createState() => _pedidosState();
}

class _pedidosState extends State<pedidos> {

  SharedPreferences sharedPreferences;

  @override
  void initState(){
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token")==null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> LoginPage()),(Route<dynamic> route)=> false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("App Mensajero", style: TextStyle(color: Colors.white)),
        actions: <Widget>[


          FlatButton(
            onPressed: (){
              sharedPreferences.clear();
              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> LoginPage()),(Route<dynamic> route)=> false);
            },
            child: Text("Logout", style: TextStyle(color: Colors.white),),
          ),

        ],
      ),

    );
  }
}
