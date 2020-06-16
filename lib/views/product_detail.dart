import 'package:flutter/material.dart';



class ProductDetails extends StatefulWidget {
  final product_detail_name;
  final product_detail_price;
  final product_detail_cant;
  final product_detail_picture;
  final product_detail_detalle;

  ProductDetails({
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("SADE", style: TextStyle(color: Colors.white)),

      ),

      body: new ListView(
        children: <Widget>[
          new Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.network(('http://10.0.0.7:4000' + widget.product_detail_picture)),
              ),
              footer: new Container(
                color: Colors.white70,
                child: ListTile(
                  leading: new Text(widget.product_detail_name, style: TextStyle(fontWeight: FontWeight.bold),),
                  title: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Text("Precio: \$${widget.product_detail_cant}"),

                      ),
                      Expanded(
                        child: new Text("Cantidad: ${widget.product_detail_cant}"),
                      )
                    ],
                  ),
                ),
              ),

            ),

          ),

  // =================== PRIMER BOTON ================
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(onPressed: (){
                  showDialog(context: context,
                    builder: (context){
                    return new AlertDialog(
                      title: new Text("Cantidad"),
                      content: new Text("Elige la cantidad a pedir"),
                      actions: <Widget>[
                        new MaterialButton(onPressed: (){
                          Navigator.of(context).pop(context);
                        },
                        child: new Text("Cerrar"),)
                      ],
                    );
                    
                    }
                  );
                },
                color: Colors.white,
                textColor: Colors.grey,
                    elevation: 0.2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: new Text("Cantidad a pedir")
                    ),
                    Expanded(
                        child: new Icon(Icons.arrow_drop_down)
                    )
                  ],
                ),),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(onPressed: (){},
                  color: Colors.red,
                  textColor: Colors.white,
                  elevation: 0.2,
                  child: new Text("Agregar al carrito")
                ),
              ),

              new IconButton(icon: Icon(Icons.add_shopping_cart), color: Colors.red, onPressed: (){})
            ],
          ),

          Divider(),

          new ListTile(
            title: new Text("Detalles del producto"),
            subtitle: new Text(widget.product_detail_detalle),
          )
        ],
      ),
    );
  }
}
