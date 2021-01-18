import 'dart:async';
import 'dart:convert';

//import 'package:appnode/view/detailProduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:loquesea/services/mensajes.dart';
import 'package:loquesea/views/mapa_seguimiento.dart';
import 'package:loquesea/views/pedido_cart.dart';
import 'package:loquesea/views/pedido_screen.dart';
import 'package:loquesea/views/product_detail.dart';
import 'package:loquesea/views/seguimiento.dart';
import 'package:loquesea/views/ubicacion.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'articulos_pedidos.dart';
import 'entregando.dart';
import 'geo_state.dart';


class mip_pedido extends StatefulWidget {
  final email;

  mip_pedido(
      this.email
      );

  @override
  _mip_pedidoState createState() => _mip_pedidoState();
}

class _mip_pedidoState extends State<mip_pedido> {


  List pedidosData;


  getPedido() async{

    Map data={
    'email': widget.email

  };
    final url1= "http://10.128.128.35:4000/api/pedidos_cliente";
    final url2= "https://sade-app.herokuapp.com/api/pedidos_cliente";

    http.Response response = await http.post(url1, body:data);

    data = json.decode(response.body);
    setState(() {
      pedidosData = data['pedidos'];
      print('los pedidos son:');
     // print(pedidosData);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getPedido();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Pedidos", style: TextStyle(color: Colors.white)),
        actions: <Widget>[


        ],
      ),


      body: new ListView(
        children: <Widget>[
          Container(
            height: 500.0,
            child: GridView.builder(
              itemCount: pedidosData == null ? 0 : pedidosData.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),

                  child: pedido_s(
                      pedidosData[index]['_id'],
                      pedidosData[index]['username'],
                      pedidosData[index]['estado'],
                      pedidosData[index]['pago'],
                      pedidosData[index]['cantTotal'],
                      pedidosData[index]['precioTotal'],
                      pedidosData[index]['items'],
                      pedidosData[index]['latmen'],
                      pedidosData[index]['lngmen'],
                      widget.email,
                      pedidosData[index]['nombre_producto'],
                      pedidosData[index]['precio'],
                      pedidosData[index]['cantidad'],
                      pedidosData[index]['imgPath'],
                      pedidosData[index]['index'],
                      pedidosData[index]['latclient'],
                      pedidosData[index]['lngclient'],
                      pedidosData[index]['telmen'],


                  ),


                );


              },


            ),
          )
        ],
      ),



    );
  }
}


class pedido_s extends StatefulWidget {

  final pedido_id;
  final usarname;
  final estado_pedido;
  final pago;
  final cantidad_articulos;
  final total;
  final cart;
  var latmen;
  var lngmen;
  final email;

  final nombre_producto;
  final precio;
  final cantidad;
  final imgPath;
  final index;

  final latclient;
  final lngclient;

  final telmen;


  pedido_s(
      this.pedido_id,
      this.usarname,
      this.estado_pedido,
      this.pago,
      this.cantidad_articulos,
      this.total,
      this.cart,
      this.latmen,
      this.lngmen,
      this.email,
      this.nombre_producto,
      this.precio,
      this.cantidad,
      this.imgPath,
      this.index,
      this.latclient,
      this.lngclient,
      this.telmen
      );

  @override
  _pedido_sState createState() => _pedido_sState();
}

class _pedido_sState extends State<pedido_s> {
  @override
  Widget build(BuildContext context) {

    final geO_state = Provider.of<geo_state>(context);

    //print(widget.cart);

    if(widget.estado_pedido == "En cola"){
      return Container(
        child: Card(

          child: Padding(

            padding: const EdgeInsets.only(left: 16.0),
            child: Column(

              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.only(top: 8.0, bottom: 1),
                //   child: Row(children: <Widget>[
                //     Text("Cliente: ${widget.usarname}",
                //       style: new TextStyle(fontSize: 30.0),),
                //     Spacer(),
                //   ]),
                // ),


                Padding(
                  padding: const EdgeInsets.only(top: 1, bottom: 1),
                  child: Row(children: <Widget>[
                    Text("Estado del pedido: ${widget.estado_pedido}",
                      style: new TextStyle(fontSize: 25.0),),
                    Spacer(),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1, bottom: 20.0),
                  child: Row(children: <Widget>[
                    Text("Metodo de pago: ${widget.pago}",
                      style: new TextStyle(fontSize: 25.0),),
                    Spacer(),
                  ]),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Row(children: <Widget>[
                    Text("Cantidad de artículos: ${widget.cantidad_articulos}",
                      style: new TextStyle(fontSize: 25.0),),
                    Spacer(),
                  ]),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Row(children: <Widget>[
                    Text("Total: ${widget.total}",
                      style: new TextStyle(fontSize: 25.0),),
                    Spacer(),
                  ]),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                //   child: Row(children: <Widget>[
                //     Text("Carrito: ${widget.cart.values.toList()[0].nombre_producto}",
                //       style: new TextStyle(fontSize: 8.0),),
                //
                //     Spacer(),
                //   ]),
                // ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, bottom: 4.0, right: 50.0),
                  child: Row(children: <Widget>[

                    Spacer(),
                    MaterialButton(

                      onPressed: () {

                        //cancelar(widget.pedido_id);
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> new mip_pedido(widget.email)));

                        Navigator.push(context, MaterialPageRoute(builder: (context)=> new pedido_cart(widget.email, widget.pedido_id, widget.nombre_producto, widget.precio, widget.cantidad, widget.imgPath, widget.index)));


                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.green,
                      textColor: Colors.white,
                      elevation: 0.2,
                      child: new Text(
                        "Ver artículos", style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,),
                    ),

                    Spacer(),
                    MaterialButton(

                      onPressed: () {

                        cancelar(widget.pedido_id);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> new mip_pedido(widget.email)));


                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.red,
                      textColor: Colors.white,
                      elevation: 0.2,
                      child: new Text(
                        "Cancelar", style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,),
                    ),

                    // Spacer(),
                    // MaterialButton(
                    //
                    //   onPressed: () {
                    //
                    //     Navigator.push(context, MaterialPageRoute(builder: (context)=> new articulos_pedidos(widget.cart)));
                    //
                    //   },
                    //   shape: new RoundedRectangleBorder(
                    //       borderRadius: new BorderRadius.circular(30.0)),
                    //     color: Colors.green,
                    //   textColor: Colors.white,
                    //   elevation: 0.2,
                    //   child: new Text(
                    //     "Ver pedido", style: TextStyle(fontSize: 20),
                    //     textAlign: TextAlign.left,),
                    // ),



                  ],),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 1),
                  // child: ListView.builder(
                  //     itemCount: widget.index,
                  //     itemBuilder: (context, i){
                  //       return ListTile(
                  //         title: Text(widget.nombre_producto[i]),
                  //       );
                  //     }
                  // ),

                  // child: Row(children: <Widget>[
                  //   Text("N1: ${widget.nombre_producto[0]}",
                  //     style: new TextStyle(fontSize: 25.0),),
                  //   Spacer(),
                  // ]),


                ),


              ],
            ),

          ),
          //),
        ),
      );
    }
    else if(widget.estado_pedido == "En progreso"){
      return Container(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.only(top: 8.0, bottom: 1),
                //   child: Row(children: <Widget>[
                //     Text("Cliente: ${widget.usarname}",
                //       style: new TextStyle(fontSize: 30.0),),
                //     Spacer(),
                //   ]),
                // ),

                Padding(
                  padding: const EdgeInsets.only(top: 1, bottom: 1),
                  child: Row(children: <Widget>[
                    Text("Estado del pedido: ${widget.estado_pedido}",
                      style: new TextStyle(fontSize: 25.0),),
                    Spacer(),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1, bottom: 20.0),
                  child: Row(children: <Widget>[
                    Text("Metodo de pago: ${widget.pago}",
                      style: new TextStyle(fontSize: 25.0),),
                    Spacer(),
                  ]),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Row(children: <Widget>[
                    Text("Cantidad de artículos: ${widget.cantidad_articulos}",
                      style: new TextStyle(fontSize: 25.0),),
                    Spacer(),
                  ]),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Row(children: <Widget>[
                    Text("Total: ${widget.total}",
                      style: new TextStyle(fontSize: 25.0),),
                    Spacer(),
                  ]),
                ),
                Padding(

                  padding: const EdgeInsets.only(
                      top: 4.0, bottom: 4.0, right: 50.0,),
                  child: Row(children: <Widget>[



                    MaterialButton(

                      onPressed: () {

                        //cancelar(widget.pedido_id);
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> new mip_pedido(widget.email)));

                        Navigator.push(context, MaterialPageRoute(builder: (context)=> new pedido_cart(widget.email, widget.pedido_id, widget.nombre_producto, widget.precio, widget.cantidad, widget.imgPath, widget.index)));


                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.green,
                      textColor: Colors.white,
                      elevation: 0.2,
                      child: new Text(
                        "Ver artículos", style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,),
                    ),




                  ],),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 50),
                  child: Row(children: <Widget>[
                    MaterialButton( onPressed: (){

                      var sm = ["Estás en camino?","Voy"];

                      Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new mensajes(widget.telmen, sm)));

                    },
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.green,
                      textColor: Colors.white,
                      elevation: 0.2,
                      child: new Text("Mensajes",style: TextStyle(fontSize: 20),textAlign: TextAlign.left,),
                    ),
                  ]),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 50),
                  child: Row(children: <Widget>[
                    MaterialButton(
                      onPressed: () async {

                        ProgressDialog dialog = new ProgressDialog( context);
                        dialog.style(
                            message: 'Cargando...'
                        );
                        await dialog.show();

                        final LatLng fromPoint = LatLng (widget.latclient,  widget.lngclient);
                        final LatLng toPoint = LatLng (widget.latmen, widget.lngmen);

                        await dialog.hide();

                        Navigator.of(context).push(new MaterialPageRoute(builder: (context) => seguimiento( fromPoint, toPoint,widget.pedido_id)));


                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.green,
                      textColor: Colors.white,
                      elevation: 0.2,
                      child: new Text(
                        "Ver seguimiento", style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,),
                    ),
                  ]),
                ),


              ],
            ),

          ),
          //),
        ),
      );

    }
    // else if(widget.estado_pedido == "Cancelado"){
    //   return Container( width: 0.0, height: 0.0,);
    // }
    // else if(widget.estado_pedido == "Completado"){
    //
    //   return Container( width: 0.0, height: 0.0,);
    //
    // }




  }

  cancelar(id)async{

    Map data = {
      'id': id
    };

    var jsonResponse = null;

    String url1 = "https://sade-app.herokuapp.com/api_cancelar";
    String url2= "http://10.128.128.35:4000/api_cancelar";
    var response = await http.post(url2, body: data);

    jsonResponse = json.decode(response.body);

    if(jsonResponse == 200){
      setState(() {});
      Fluttertoast.showToast(msg: "Se canceló el pedido");
    }else{
      Fluttertoast.showToast(msg: "Ocurrió un problema");
    }



  }

  sacar_items(id)async{

    Map data= {

    };

  }



}