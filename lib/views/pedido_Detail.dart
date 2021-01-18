
import 'package:flutter/material.dart';

class pedidoDetail extends StatelessWidget {
  final String id;
  final String productId;
  final cart_product_name;
  final cart_product_picture;
  final cart_product_price;
  final cart_product_count;

  final url = "https://sade-app.herokuapp.com/";
  final url2 = "http://10.128.128.35:4000/";

  pedidoDetail(
      this.id,
      this.productId,
      this.cart_product_name,
      this.cart_product_picture,
      this.cart_product_count,
      this.cart_product_price
      );


  @override
  Widget build(BuildContext context) {
    return  Card(
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
