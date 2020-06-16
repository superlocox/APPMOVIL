import 'package:loquesea/views/cart.dart';
import 'package:loquesea/views/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert';
import 'package:loquesea/views/listProducts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Nodejs',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  


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
        title: Text("SADE", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          new IconButton(icon: Icon(
              Icons.shopping_cart,
              color: Colors.white
          ), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> new Cart()));
          }),

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
      body: new ListView(
        children: <Widget>[
          Container(
            height: 600.0,
            child: ListProducts(),
          )
        ],
      ),
      drawer: Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Nodejs"),
              accountEmail: new Text("d@gmail.com"),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white,),
                ),
              ),
            ),
            new ListTile(title: new Text("Lista de Productos"),
              trailing: new Icon(Icons.list),
              onTap: (){},
            ),
            new ListTile(title: new Text("Agregar Productos"),
              trailing: new Icon(Icons.add),
              onTap: (){},
            ),
            new ListTile(title: new Text("Registrar  Productos"),
              trailing: new Icon(Icons.add),
              onTap: (){},
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Página Principal'),
                leading: Icon(Icons.home, color: Colors.green,),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Mis pedidos'),
                leading: Icon(Icons.shopping_basket, color: Colors.green,),
              ),
            ),

            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> new Cart()));
              },
              child: ListTile(
                title: Text("Carrito"),
                leading: Icon(Icons.shopping_cart, color: Colors.green,),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Configuraciones'),
                leading: Icon(Icons.settings, color: Colors.grey,),
              ),
            ),

          ],
        ),
      ),

    );
  }
}
