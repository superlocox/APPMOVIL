
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'carrito.dart';

class CartPdt extends StatelessWidget {

  final String id;
  final String productId;
  final cart_product_name;
  final cart_product_picture;
  final cart_product_price;
  final cart_product_count;

  final url = "https://sade-app.herokuapp.com/";
  final url2 = "http://10.128.128.35:4000/";

  CartPdt(
      this.id,
      this.productId,
      this.cart_product_name,
      this.cart_product_picture,
      this.cart_product_count,
      this.cart_product_price
      );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction){
        Provider.of<Carrito>(context,listen: false).removeItem(productId);
      },

      child: Card(
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
          trailing: new FittedBox(
            fit: BoxFit.fill,
            child: Column(
              children: <Widget>[
                new IconButton(icon: Icon(Icons.arrow_drop_up), onPressed: (){
                  Provider.of<Carrito>(context,listen: false).addItems(productId, cart_product_name, cart_product_price, cart_product_picture);
                }),

                new IconButton(icon: Icon(Icons.arrow_drop_down), onPressed: (){
                  Provider.of<Carrito>(context,listen: false).removeSingleItem(productId);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
