
import 'package:flutter/material.dart';
import 'package:loquesea/views/carrito.dart';
import 'package:loquesea/views/carrito_item.dart';



class articulos_pedidos extends StatefulWidget {
  final cart;

  articulos_pedidos( this.cart);
  @override
  _articulos_pedidosState createState() => _articulos_pedidosState();
}

class _articulos_pedidosState extends State<articulos_pedidos> {
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
        Expanded(
        child: ListView.builder(
            itemBuilder: (context,i)=>CartPdt(
              widget.cart.toList()[i].id,
              widget.cart.items.keys.toList()[i],
              widget.cart.items.values.toList()[i].cart_product_name,
              widget.cart.items.values.toList()[i].cart_product_picture,
              widget.cart.items.values.toList()[i].cart_product_count,
              widget.cart.items.values.toList()[i].cart_product_price,


    ),
          itemCount: widget.cart.items.length,
    ),
    ),

              total(widget.cart),
    ]
        )

    );
  }
}


class total extends StatefulWidget {

  final Carrito cart;

  total(this.cart);
  @override
  _totalState createState() => _totalState();
}

class _totalState extends State<total> {
  @override
  Widget build(BuildContext context) {
    if(widget.cart.totalAmmount<=0){
      return Container();

    }else{
      return   Container(
        padding: const EdgeInsets.only(left: 14.0, top: 14.0),
        child: Text("Total: \$${widget.cart.totalAmmount}",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
          ),
        ),
      );
    }
  }
}

class articulo extends StatefulWidget {


  @override
  _articuloState createState() => _articuloState();
}

class _articuloState extends State<articulo> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

