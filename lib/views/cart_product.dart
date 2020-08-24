

import 'package:flutter/material.dart';


class Cart_products extends StatefulWidget {
  @override
  _Cart_productsState createState() => _Cart_productsState();
}

class _Cart_productsState extends State<Cart_products> {

  var Products_on_the_cart = [
    {
      "nombre_producto": "Lista Milk",
      "imgPath": "/img/upload/461d21bd-48ff-432b-93e0-4c8ffb52cf49.jpg",
      "precio": 60,
      "cantidad":1
    },
    {
      "nombre_producto": "Leche Rica",
      "imgPath": "/img/upload/47e032f4-7632-491f-91a9-0d7c6b7d0ddc.jpg",
      "precio": 55,
      "cantidad":1
    }
    ];



  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: Products_on_the_cart.length,
        itemBuilder: (context, index) {
          return Single_cart_product(
            cart_product_name: Products_on_the_cart[index]["nombre_producto"],
            cart_product_count: Products_on_the_cart[index]["cantidad"],
            cart_product_picture: Products_on_the_cart[index]["imgPath"],
            cart_product_price: Products_on_the_cart[index]["precio"],

          );
        });
  }
}


class Single_cart_product extends StatelessWidget {

  final cart_product_name;
  final cart_product_picture;
  final cart_product_price;
  final cart_product_count;

  //final url = "http://10.0.0.7:4000";
  final url = "https://sade-app.herokuapp.com/";


  Single_cart_product({
    this.cart_product_name,
    this.cart_product_picture,
    this.cart_product_count,
    this.cart_product_price

});

  @override
  Widget build(BuildContext context) {
    return Card(

      //elevation: 5.0,
      //margin: EdgeInsets.all(10),
      child: ListTile(
        leading: new Image.network(url+cart_product_picture),
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
        trailing: new FittedBox(
          fit: BoxFit.fill,
          child: Column(
            children: <Widget>[
              new IconButton(icon: Icon(Icons.arrow_drop_up), onPressed: (){}),
              new Text("$cart_product_count"),
              new IconButton(icon: Icon(Icons.arrow_drop_down), onPressed: (){})
            ],
          ),
        ),
      ),

    );
  }
}
