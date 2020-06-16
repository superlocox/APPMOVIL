import 'package:flutter/material.dart';
import 'package:loquesea/views/cart_product.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Colors.green,
          title: Text("Carrito", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),

        ),

      body: new Cart_products(),
      
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(

          children: <Widget>[

            Expanded(
                child: ListTile(

                  title: new Text("Total:"),
                  subtitle: new Text("\$410"),)),
            
            Expanded(
              child: new MaterialButton(onPressed: (){},
              child: new Text("Realizar Pedido", style: TextStyle(color: Colors.white),),
                color: Colors.green,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0)
              ),
              ),
              
            )
          ],
        ),
      ),
    );
  }
}
