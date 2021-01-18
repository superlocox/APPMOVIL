

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http ;

class pedido_cart extends StatefulWidget {


  final email;
  final pedido_id;
  final nombre_producto;
  final precio;
  final cantidad;
  final imgPath;
  final index;

  pedido_cart(
      this.email,
      this.pedido_id,
      this.nombre_producto,
      this.precio,
      this.cantidad,
      this.imgPath,
      this.index

      );

  @override
  _pedido_cartState createState() => _pedido_cartState();
}

class _pedido_cartState extends State<pedido_cart> {

  Map datax;
  List articulos;

  getArticulos() async{

    Map data={
      'email': widget.email,
      'pedido_id': widget.pedido_id

    };
    final url1= "http://10.128.128.35:4000/api/pedidos_articulo";
    final url2= "https://sade-app.herokuapp.com/api/pedidos_articulo";

    http.Response response = await http.post(url1, body:data);

    datax = json.decode(response.body);

    print('la data');
    print(datax);
    setState(() {

    });
  }


  @override
  void initState() {
    // TODO: implement initState
   // getArticulos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(


      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.green,
        title: Text("Artículos del pedido", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),

      ),
      body: Column(

        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (context,i)=>ArtPdt(
                widget.pedido_id,
                widget.nombre_producto[i],
                widget.imgPath[i],
                widget.cantidad[i],
                widget.precio[i],


              ),
              itemCount: widget.index,
            ),
          ),




        ],
      ),
    );

  }
}


class ArtPdt extends StatelessWidget {

  final String id;
 // final String productId;
  final cart_product_name;
  final cart_product_picture;
  final cart_product_price;
  final cart_product_count;

  final url = "https://sade-app.herokuapp.com/";
  final url2 = "http://10.128.128.35:4000/";

  ArtPdt(
      this.id,
     // this.productId,
      this.cart_product_name,
      this.cart_product_picture,
      this.cart_product_count,
      this.cart_product_price
      );

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          leading: new Image.network(url2+cart_product_picture),
          title: new Text(cart_product_name),
          subtitle: new Column(
            children: <Widget>[

              new Row(
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: new Text("Precio:"),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Text("\$$cart_product_price",
                      style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Text("Cantidad:"),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Text("$cart_product_count"),
                  ),




                ],
              ),


            ],

          ),

        ),
      );

  }
}
