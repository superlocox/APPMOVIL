





import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:loquesea/views/pedido_Detail.dart';

import 'package:provider/provider.dart';


class pedidoScreen extends StatefulWidget {
  final carrito;
  final cantTotal;
  final total;



  pedidoScreen(this.carrito, this.cantTotal, this.total);


  @override
  _pedidoScreenState createState() => _pedidoScreenState();
}

class _pedidoScreenState extends State<pedidoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.green,
        title: Text("Carrito", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),

      ),
      body: Column(
        children: <Widget>[
         /* Expanded(
            child: ListView.builder(
            *//*  itemBuilder: (context,i)=>pedidoDetail(
                 carrito.items.values.toList()[i].id,
                carrito.items.keys.toList()[i],
                carrito.items.values.toList()[i].cart_product_name,
                carrito.items.values.toList()[i].cart_product_picture,
                carrito.items.values.toList()[i].cart_product_count,
                carrito.items.values.toList()[i].cart_product_price,


              ),
              itemCount: widget.items.length,
            *//*),
          ),*/


          //total(cart),
          //CheckoutButton(cart: cart,email: widget.email,pago: opcionselect ,)

        ],
      ),
    );
  }
}
