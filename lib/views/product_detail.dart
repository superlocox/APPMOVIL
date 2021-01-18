import 'package:flutter/material.dart';
import 'package:loquesea/views/carrito.dart';
import 'package:loquesea/views/carrito_screen.dart';
import 'package:provider/provider.dart';



class ProductDetails extends StatefulWidget {
  final product_deatail_id;
  final product_detail_name;
  final product_detail_price;
  final product_detail_cant;
  final product_detail_picture;
  final product_detail_detalle;

  ProductDetails({
    this.product_deatail_id,
    this.product_detail_name,
    this.product_detail_price,
    this.product_detail_cant,
    this.product_detail_picture,
    this.product_detail_detalle
});


  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {


  @override
  Widget build(BuildContext context) {
    final cart= Provider.of<Carrito>(context);
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    String url = "https://sade-app.herokuapp.com/";
    String url2= "http://10.128.128.35:4000/";

    return Scaffold(
      appBar: AppBar(
        key: _scaffoldKey,
        backgroundColor: Colors.green,
        title: Text("SADE", style: TextStyle(color: Colors.white)),

      ),

      body: Builder(
        builder: (context)=>
        ListView(
          children: <Widget>[
            new Container(
              height: 300.0,
              child: GridTile(
                child: Container(
                  color: Colors.white,

                  child: Image.network((url2 + widget.product_detail_picture)),
                ),
                footer: new Container(
                  color: Colors.white70,

                  child: Column(children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                      Expanded(
                        //width: 400,
                        child: Text(widget.product_detail_name, style: TextStyle(
                            fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),

                    ],

                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: <Widget>[

                      Expanded(
                        child: new Text("Precio: \$${widget.product_detail_price}",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        ),

                      ),
                      Expanded(
                        child: new Text("Cantidad: ${widget.product_detail_cant}",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )

                    ],)
                  ],)



                 ,
                ),

              ),

            ),


            Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(onPressed: (){

                    Scaffold.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text("Artículo agregado al Carrito"),
                    ));



                    cart.addItems(widget.product_deatail_id, widget.product_detail_name, widget.product_detail_price, widget.product_detail_picture);

                   /* final snackBar = SnackBar(content: Text("Artículo agregado al Carrito"),);
                    _scaffoldKey.currentState.showSnackBar(snackBar);
*/
                  },
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                    color: Colors.green,
                    textColor: Colors.white,
                    elevation: 0.2,

                    child: new Text("Agregar al carrito",style: TextStyle(fontSize: 20),)
                  ),
                ),

              /*  new IconButton(icon: Icon(Icons.add_shopping_cart), color: Colors.red, onPressed: (){},
                )*/
              ],
            ),

            Divider(),

            new ListTile(
              title: new Text("Detalles del producto"),
              subtitle: new Text(widget.product_detail_detalle),
            )
          ],
        ),
      ),
    );
  }
}
