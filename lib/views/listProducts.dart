import 'dart:async';
import 'dart:convert';

//import 'package:appnode/view/detailProduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loquesea/views/product_detail.dart';

class ListProducts extends StatefulWidget {
  @override
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {

  Map data;
  List productData;

  getProducts() async{
    http.Response response = await http.get("https://sade-app.herokuapp.com/api/productos");
    data = json.decode(response.body);
    setState(() {
      productData = data['productos'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getProducts();
  }


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: productData == null ? 0 : productData.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index){
          return Single_prod(
            product_name: productData[index]['nombre_producto'],
            product_picture: productData[index]['imgPath'],
            product_price: productData[index]['precio'],
            product_count: productData[index]['cantidad'],
            product_descripcion: productData[index]['descripcion_producto'],
          );

      },
    );
  }
}

class Single_prod extends StatelessWidget {
  final product_name;
  final product_picture;
  final product_price;
  final product_count;
  final product_descripcion;

  Single_prod({
    this.product_name,
    this.product_picture,
    this.product_price,
    this.product_count,
    this.product_descripcion
});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
          tag: product_name,
          child: Material(
            child: InkWell(
              onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new ProductDetails(
                product_detail_name: product_name,
                product_detail_price: product_price,
                product_detail_cant: product_count,
                product_detail_picture: product_picture,
                product_detail_detalle: product_descripcion,
              ))),
            child: GridTile(
                footer: Container(
                color: Colors.white70,

                  child: Column(children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[


                      Container(
                          width: 120.0,

                          child: Text(product_name,style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold
                          ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          )
                      ),
                      Text("\$$product_price",style: TextStyle(color: Colors.green, fontSize: 22.0 ,fontWeight: FontWeight.w800)),
                    ],)
                  ],)


            ,
                ),
              child: Image.network(('https://sade-app.herokuapp.com/' + product_picture), fit: BoxFit.cover)),
      ),
          ))
    );
  }
}

