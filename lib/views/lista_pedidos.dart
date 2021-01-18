import 'dart:async';
import 'dart:convert';

//import 'package:appnode/view/detailProduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:loquesea/services/mensajes.dart';
import 'package:loquesea/views/pedido_cart.dart';
import 'package:loquesea/views/pedido_screen.dart';
import 'package:loquesea/views/product_detail.dart';
import 'package:loquesea/views/ubicacion.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'entregando.dart';
import 'geo_state.dart';


class listaPedidos extends StatefulWidget {
  final email;

  listaPedidos(
      this.email,
      );

  @override
  _listaPedidosState createState() => _listaPedidosState();
}

class _listaPedidosState extends State<listaPedidos> {

  Map data;
  List pedidosData;

  final url1= "http://10.128.128.35:4000/api/pedidos";
  final url2= "https://sade-app.herokuapp.com/api/pedidos";

  getPedidos() async{
    http.Response response = await http.get(url1);
    data = json.decode(response.body);
    setState(() {
      pedidosData = data['pedidos'];
    });
  }






  @override
  void initState() {
    super.initState();
    this.getPedidos();
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

                    child: singlePedido(
                        pedidosData[index]['_id'],
                        pedidosData[index]['username'],
                        pedidosData[index]['estado'],
                        pedidosData[index]['pago'],
                        pedidosData[index]['cantTotal'],
                        pedidosData[index]['precioTotal'],
                        pedidosData[index]['cart'],
                        pedidosData[index]['latclient'],
                        pedidosData[index]['lngclient'],
                        widget.email,
                        pedidosData[index]['nombre_producto'],
                        pedidosData[index]['precio'],
                        pedidosData[index]['cantidad'],
                        pedidosData[index]['imgPath'],
                        pedidosData[index]['index'],
                        pedidosData[index]['telclien']

                    ),


                  );


                },


              ),
            )
          ],
        ),

      /*GridView.builder(
          itemCount: pedidosData == null ? 0 : pedidosData.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.all(8.0),

              child: singlePedido(
                  pedidosData[index]['_id'],
                  pedidosData[index]['username'],
                  pedidosData[index]['estado'],
                  pedidosData[index]['pago'],
                  pedidosData[index]['cart']['cantTotal'],
                  pedidosData[index]['cart']['precioTotal']
              ),
            );

          },


        ),*/


    );


  }
}

class singlePedido extends StatefulWidget {

  final pedido_id;
  final usarname;
  final estado_pedido;
  final pago;
  final cantidad_articulos;
  final total;
  final cart;
  var latclient;
  var lngclient;
  final email;


  final nombre_producto;
  final precio;
  final cantidad;
  final imgPath;
  final index;
  final telclien;


  singlePedido(
      this.pedido_id,
      this.usarname,
      this.estado_pedido,
      this.pago,
      this.cantidad_articulos,
      this.total,
      this.cart,
      this.latclient,
      this.lngclient,
      this.email,
      this.nombre_producto,
      this.precio,
      this.cantidad,
      this.imgPath,
      this.index,
      this.telclien
      );

  @override
  _singlePedidoState createState() => _singlePedidoState();
}

class _singlePedidoState extends State<singlePedido> {
  @override
  Widget build(BuildContext context) {


    final geO_state = Provider.of<geo_state>(context);

    //geO_state.getUserLocation();

    //final LatLng fromPoint = LatLng (geO_state.lastPosition.latitude,  geO_state.lastPosition.longitude);
    //final LatLng toPoint = LatLng (widget.latclient, widget.lngclient);

    if( widget.estado_pedido == "En cola"){
      return Container(
        child: Card(
          /*{
                        print(cart["items"]);
                        print(cart["cantTotal"]);
                        print(cart["precioTotal"]);

                      }*/
          //child: InkWell( onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new pedidoScreen(
          /*cart["items"],
                          cart["cantTotal"],
                          cart["precioTotal"]*/
          //)
          //  )
          //   ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 1),
                  child: Row(children: <Widget>[
                    Text("Cliente: ${widget.usarname}", style: new TextStyle(fontSize: 30.0),),
                    Spacer(),
                  ]),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:1, bottom: 1),
                  child: Row(children: <Widget>[
                    Text("Estado de pedido: ${widget.estado_pedido}", style: new TextStyle(fontSize: 20.0),),
                    Spacer(),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1, bottom: 20.0),
                  child: Row(children: <Widget>[
                    Text("Metodo de pago: ${widget.pago}", style: new TextStyle(fontSize: 20.0),),
                    Spacer(),
                  ]),
                ),



                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Row(children: <Widget>[
                    Text("Cantidad de artículos: ${widget.cantidad_articulos}", style: new TextStyle(fontSize: 25.0),),
                    Spacer(),
                  ]),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Row(children: <Widget>[
                    Text("Total: ${widget.total}", style: new TextStyle(fontSize: 25.0),),
                    Spacer(),
                  ]),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 90.0 ),
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
                  ]),
                ),

          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right:40.0 ),
            child: Row(children: <Widget>[

              Spacer(),
              MaterialButton( onPressed: (){

                Navigator.push(context, MaterialPageRoute(builder: (context)=> new ubicacion(widget.latclient, widget.lngclient)));

              },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.green,
                textColor: Colors.white,
                elevation: 0.2,
                child: new Text("Ver ubicación",style: TextStyle(fontSize: 20),textAlign: TextAlign.left,),
              ),

              Spacer(),
              MaterialButton( onPressed: () async {

                ProgressDialog dialog = new ProgressDialog( context);
                dialog.style(
                    message: 'Cargando...'
                );
                await dialog.show();

                final LatLng fromPoint = LatLng (geO_state.lastPosition.latitude,  geO_state.lastPosition.longitude);

                await dialog.hide();


                elegirPedido(widget.pedido_id, geO_state.lastPosition.latitude, geO_state.lastPosition.longitude, widget.email);
                //Navigator.pop(context);

              },

                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.green,
                textColor: Colors.white,
                elevation: 0.2,
                child: new Text("Elegir pedido",style: TextStyle(fontSize: 20),textAlign: TextAlign.left,),
              ),




            ],),
          ),




              ],
            ),

          ),
          //),
        ),
      );
    }else if(widget.estado_pedido == "En progreso"){
      return Container(
        child: Card(
          /*{
                        print(cart["items"]);
                        print(cart["cantTotal"]);
                     print(cart["precioTotal"])
                    }*/
          //child: InkWell( onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new pedidoScreen(
          /*cart["items"],
                          cart["cantTotal"],
                         cart["precioTotal"]*/
          //)
          //  )
          //   ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 1),
                  child: Row(children: <Widget>[
                    Text("Cliente: ${widget.usarname}", style: new TextStyle(fontSize: 30.0),),
                    Spacer(),
                  ]),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:1, bottom: 1),
                  child: Row(children: <Widget>[
                    Text("Estado de pedido: ${widget.estado_pedido}", style: new TextStyle(fontSize: 20.0),),
                    Spacer(),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1, bottom: 20.0),
                  child: Row(children: <Widget>[
                    Text("Metodo de pago: ${widget.pago}", style: new TextStyle(fontSize: 20.0),),
                    Spacer(),
                  ]),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Row(children: <Widget>[
                    Text("Cantidad de artículos: ${widget.cantidad_articulos}", style: new TextStyle(fontSize: 25.0),),
                    Spacer(),
                  ]),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Row(children: <Widget>[
                    Text("Total: ${widget.total}", style: new TextStyle(fontSize: 25.0),),
                    Spacer(),
                  ]),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 90.0 ),
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
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right:50.0 ),
                  child: Row(children: <Widget>[




                    Spacer(),
                    MaterialButton( onPressed: () async {

                      // elegirPedido(widget.pedido_id, geO_state.lastPosition.latitude, geO_state.lastPosition.longitude, widget.email)

                      ProgressDialog dialog = new ProgressDialog( context);
                      dialog.style(
                          message: 'Cargando...'
                      );
                      await dialog.show();

                      final LatLng fromPoint = LatLng (geO_state.lastPosition.latitude,  geO_state.lastPosition.longitude);
                      final LatLng toPoint = LatLng (widget.latclient, widget.lngclient);



                      print('latitud es:');
                      print(geO_state.lastPosition.latitude);

                      await dialog.hide();

                      Navigator.of(context).push(new MaterialPageRoute(builder: (context) =>DeliveryScreen( fromPoint, toPoint,widget.pedido_id)));
                      //Navigator.pop(context);

                    },

                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.green,
                      textColor: Colors.white,
                      elevation: 0.2,
                      child: new Text("Ruta",style: TextStyle(fontSize: 20),textAlign: TextAlign.left,),
                    ),
                    Spacer(),
                    MaterialButton( onPressed: (){

                      var sm = ["Estoy de camino","Llegue a la ubicación"];
                      var telefono = 8098172926;

                      print(widget.telclien);

                      Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new mensajes(widget.telclien, sm)));


                    },
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.green,
                      textColor: Colors.white,
                      elevation: 0.2,
                      child: new Text("Mensajes",style: TextStyle(fontSize: 20),textAlign: TextAlign.left,),
                    ),
                    Spacer(),





                  ],),
                ),


                      botonFinal(widget.pago,widget.pedido_id)




          ],
            ),

          ),
          //),
        ),
      );


    }
    else{
      return Container();
    }
    }

  void elegirPedido(id, latmen, lngmen, email) async{
    Map data ={
      '_id' : id,
      'latmen' : latmen.toString(),
      'lngmen' : lngmen.toString(),
      'email' : email
    };

    String ur1= "https://sade-app.herokuapp.com/elegir_api";
    String url2= "http://10.128.128.35:4000/elegir_api";


    print(widget.email);

    var jsonResponse = null;
    var response = await http.post(url2, body: data);

   // jsonResponse = json.decode(response.body);



    final LatLng fromPoint = LatLng (latmen, lngmen);
    final LatLng toPoint = LatLng (widget.latclient, widget.lngclient);

    //Navigator.of(context).push(new MaterialPageRoute(builder: (context) =>DeliveryScreen( fromPoint, toPoint,id)));






    if (response.statusCode == 200) {
      //jsonResponse = json.decode(response.body);
      print("Entro");
     //Fluttertoast.showToast(msg: "Se eligió correctamente");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> new listaPedidos(widget.email)));
      //Navigator.of(context).push(new MaterialPageRoute(builder: (context) =>DeliveryScreen( fromPoint, toPoint,id)));
      Fluttertoast.showToast(msg: "Se eligió correctamente");
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> new listaPedidos(widget.email)));
      Fluttertoast.showToast(msg: "Algo salió mal");
    }


  }


}

class botonFinal extends StatefulWidget {
  final metodoPago;
  final id;
  botonFinal(this.metodoPago,this.id);
  @override
  _botonFinalState createState() => _botonFinalState();
}

class _botonFinalState extends State<botonFinal> {
  @override
  Widget build(BuildContext context) {
    if(widget.metodoPago == "Efectivo"){
      return  MaterialButton( onPressed: (){
        finalizarPedido(widget.id);
        Navigator.pop(context);

      },
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        color: Colors.green,
        textColor: Colors.white,
        elevation: 0.2,
        child: new Text("Finzalizar orden",style: TextStyle(fontSize: 20),textAlign: TextAlign.left,),
      );
    }else{
      return Container();
    }
  }

  void finalizarPedido(id) async{
    Map data ={
      '_id' : id
    };

    String ur1= "https://sade-app.herokuapp.com/finalizar_api";
    String url2= "http://10.128.128.35:4000/finalizar_api";

    var jsonResponse = null;
    var response = await http.post(url2, body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      Fluttertoast.showToast(msg: "Se finalizó correctamente");
    }else{
      Fluttertoast.showToast(msg: "Algo salió mal");
    }


  }
}



class boton extends StatefulWidget {
  final estado_pedido;

  boton(this.estado_pedido);
  @override
  _botonState createState() => _botonState();
}

class _botonState extends State<boton> {
  @override
  Widget build(BuildContext context) {

    if(widget.estado_pedido == "En cola"){
      Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right:50.0 ),
        child: Row(children: <Widget>[

          Spacer(),
          MaterialButton( onPressed: (){


          },

            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.green,
            textColor: Colors.white,
            elevation: 0.2,
            child: new Text("Elegir pedido",style: TextStyle(fontSize: 20),textAlign: TextAlign.left,),
          )],),
      );
    } else if(widget.estado_pedido == "En progreso"){

      Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right:50.0 ),
        child: Row(children: <Widget>[

          Spacer(),
          MaterialButton( onPressed: (){

          },
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.green,
            textColor: Colors.white,
            elevation: 0.2,
            child: new Text("Ver ubicación",style: TextStyle(fontSize: 20),textAlign: TextAlign.left,),
          ),
          MaterialButton( onPressed: (){



          },
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.green,
            textColor: Colors.white,
            elevation: 0.2,
            child: new Text("Mensajes",style: TextStyle(fontSize: 20),textAlign: TextAlign.left,),
          )
        ],),
      );


    }

  }
}






