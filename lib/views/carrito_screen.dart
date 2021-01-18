



import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loquesea/card/card_view.dart';
import 'package:loquesea/services/stripe.dart';
import 'package:loquesea/views/articulos_pedidos.dart';
import 'package:loquesea/views/carrito.dart';
import 'package:loquesea/views/carrito_item.dart';
import 'package:loquesea/views/geo_state.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http ;


class carrito_screen extends StatefulWidget {
  static const routeName='/cart';

  final email;
  carrito_screen(this.email);

  @override
  _carrito_screenState createState() => _carrito_screenState();
}





class _carrito_screenState extends State<carrito_screen> {




  var opciones = ['Efectivo', 'Tarjeta'];
  var opcionselect= 'Efectivo';

  var estado = false;
  Map cardData;

  getcard() async{

    Map data={
      'email': widget.email

    };
    final url1= "http://10.128.128.35:4000/getcard";
    final url2= "https://sade-app.herokuapp.com/getcard";

    var jsonResponse = null;

    http.Response response = await http.post(url1, body:data);

    data = json.decode(response.body);


    jsonResponse = json.decode(response.body);
    if (response.statusCode == 200){

      setState(() {
        cardData = data['card'];
        print('los pedidos son:');
        print(cardData);
        estado=true;
      });


    }else if(response.statusCode == 400){
      setState(() {
        estado=false;
      });

    }


  }

  @override
  void initState() {
    // TODO: implement initState
    getcard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart= Provider.of<Carrito>(context);
    final geO_state = Provider.of<geo_state>(context);


/*

    List<opciones> _opciones = opciones.getOpciones();
    List<DropdownMenuItem<opciones>> _dropwdownMenuItems;
    opciones _selectedOpcion;

    List<DropdownMenuItem<opciones>> buildDropdownMenuItems(List opciones){
      List<DropdownMenuItem<opciones>> items = List();
      for (opciones opcion in opciones) {
        items.add(
          DropdownMenuItem(
            value: opcion,
            child: Text(opcion.name),
          ),
        );
      }
      return items;

    }


    @override
    void initState(){
      _dropwdownMenuItems = buildDropdownMenuItems(_opciones);
      _selectedOpcion = _dropwdownMenuItems[0].value;
      super.initState();
    }
*/





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
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].cart_product_name,
                  cart.items.values.toList()[i].cart_product_picture,
                  cart.items.values.toList()[i].cart_product_count,
                  cart.items.values.toList()[i].cart_product_price,


                ),
                itemCount: cart.items.length,
            ),
          ),


     /*     Container(
            padding: const EdgeInsets.only(left: 14.0, top: 14.0),
            child: Text("Método de pago",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
              ),
            ),
          ),*/




          /*CheckboxGroup(
            labels: <String>[
              "Efectivo",
              "Tarjeta",
              "Loquesea"
            ],

            checked: _checked,
            onChange: (bool isChecked, String label, int index) =>
                print("isChecked: $isChecked   label: $label  index: $index"),
            onSelected: (List selected) => setState(() {
              if (selected.length > 1) {
                selected.removeAt(0);
                print('selected length  ${selected.length}');
              } else {
                print("only one");
              }
              _checked = selected;
              print(_checked.toString());
            }),
          ),*/

         /* OutlineButton(

            onPressed: (){},
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            child: Text('Realizar Pedido',style: TextStyle(color: Colors.blue,fontSize: 25),

          )

            ,)*/
         metodoPago(cart),
         // dropDownM(opciones,opcionselect,cart),
          DropdownButton<String>(
            items: opciones.map((String dropDrownStringItem){
              /*print("La longitud es:");
              print(geO_state.initialPosition.longitude);
              print("La latitud es:");
              print(geO_state.initialPosition.latitude);*/

              return DropdownMenuItem<String>(
                value: dropDrownStringItem,
                child: Text(dropDrownStringItem),
              );

            }).toList(),

            onChanged: (String newValueSelected){

              _onDropDownItemSelected(newValueSelected);

            },

            value: opcionselect,

          ),

          total(cart),
          CheckoutButton(cart: cart,email: widget.email,pago: opcionselect ,total: cart.totalAmmount,)

        ],
      ),
    );
  }

  void _onDropDownItemSelected(newValueSelected) {
    setState(() {
      this.opcionselect = newValueSelected;
    });
  }




}

class metodoPago extends StatefulWidget {
  final cart;
  metodoPago(this.cart);
  @override
  _metodoPagoState createState() => _metodoPagoState();
}

class _metodoPagoState extends State<metodoPago> {
  @override
  Widget build(BuildContext context) {
    if(widget.cart.totalAmmount<=0) {
      return Container();
    }else{
      return    Container(
        padding: const EdgeInsets.only(left: 14.0, top: 14.0),
        child: Text("Método de pago",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
          ),
        ),
      );


    }
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

class dropDownM extends StatefulWidget {

  var opciones;
  var opcion_select;
  final cart;

  dropDownM(this.opciones,this.opcion_select,this.cart);

  @override
  _dropDownMState createState() => _dropDownMState();
}

class _dropDownMState extends State<dropDownM> {



  @override
  Widget build(BuildContext context) {



    if(widget.cart.totalAmmount<=0){

      return Container();

    }else{
      return  DropdownButton<String>(
        items: widget.opciones.map((String dropDrownStringItem){
          return DropdownMenuItem<String>(
            value: dropDrownStringItem,
            child: Text(dropDrownStringItem),
          );

        }).toList(),

        onChanged: (String newValueSelected){

          widget.opcion_select(newValueSelected);

        },

        value: widget.opcion_select,

      );

    }


  }
}



class CheckoutButton extends StatefulWidget {
  final Carrito cart;
  final email;
  final pago;
  final total;



  const CheckoutButton({@required this.cart,@required this.email,this.pago,this.total});





  @override
  _CheckoutButtonState createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {

  var estado = false;
  Map cardData;

  Map card;


  pay(BuildContext context,card) async {

    // ProgressDialog dialog = new ProgressDialog(context);
    // dialog.style(
    //     message: 'Please wait...'
    // );
    // await dialog.show();
    // var expiryArr = card['expiryDate'].split('/');
    // CreditCard stripeCard = CreditCard(
    //   number: card['cardNumber'],
    //   expMonth: int.parse(expiryArr[0]),
    //   expYear: int.parse(expiryArr[1]),
    // );

    var response = StripeService.payViaExistingCard(
      amount: widget.total,
      currency: 'DOP'
    );

  }

  pago_stripe( id, amount)async{

    Map data={
      'id': id,
      'amount': amount.toString(),

    };

    final url1= "http://10.0.0.7:4000/api/checkout";
    final url2= "https://sade-app.herokuapp.com/api/checkout";

    print(amount);

    var jsonResponse = null;

    http.Response response = await http.post(url1, body:data);

    data = json.decode(response.body);


    jsonResponse = json.decode(response.body);

    if (response.statusCode == 200){
      Fluttertoast.showToast(msg: "Compra realiza");
    }


  }


  getcard() async{

    Map data={
      'email': widget.email

    };
    final url1= "http://10.0.0.7:4000/getcard";
    final url2= "https://sade-app.herokuapp.com/getcard";

    var jsonResponse = null;

    http.Response response = await http.post(url1, body:data);

    data = json.decode(response.body);


    jsonResponse = json.decode(response.body);
    if (response.statusCode == 200){

      setState(() {
        cardData = data['card'];
        print('los pedidos son:');
        print(cardData);
        estado=true;

        // card={
        //   'cardNumber': cardData[cardNumber],
        //   'expiryDate': '04/24',
        //   'cardHolderName': 'Muhammad Ahsan Ayaz',
        //   'cvvCode': '424',
        //   'showBackView': false,
        // };
      });


    }else if(response.statusCode == 400){
      setState(() {
        estado=false;
      });

    }


  }

  @override
  void initState() {
    // TODO: implement initState
    getcard();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    final geO_state = Provider.of<geo_state>(context);
    if(widget.cart.totalAmmount<=0){
      return  Container(
        padding: const EdgeInsets.only(left: 14.0, top: 14.0),
        child: Text("No tienes artículos agregados",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
          ),
        ),
      );
    }else{
      return OutlineButton(

        onPressed: () async{
          // print('El carrito tiene:');
          // print(widget.cart.items.values);
          // ignore: unnecessary_statements
          // print('El email es:');
          // print(widget.email);

            //await Provider.of<Orders>(context, listen: false).addOrder(widget.email, widget.cart.items.values.toList(), widget.pago);

          if(widget.pago == 'Tarjeta'){


            if(estado == false){
              print('No tarjeta');
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> new card_view(widget.email)));
              Fluttertoast.showToast(msg: "ERROR: Favor agregar tarjeta");

            }else{
              print('Tarjeta');
              var card = cardData;
              //pay(context, card);

              print(widget.total);
              //pago_stripe( cardData['_id'], widget.total);

              realizar_pedido(widget.email, widget.cart.items.values.toList(), widget.pago, geO_state.initialPosition.latitude, geO_state.initialPosition.longitude );
              widget.cart.clear();
            }



          }else{
            realizar_pedido(widget.email, widget.cart.items.values.toList(), widget.pago, geO_state.initialPosition.latitude, geO_state.initialPosition.longitude );
            // print('La pampara');

            widget.cart.clear();
          }





          print('LLego');
        },
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        child: Text('Realizar Pedido',style: TextStyle(color: Colors.blue,fontSize: 25),

        )

        ,);
    }


  }

  realizar_pedido(user, List<CartItem> cartProducts, pago, latclient, lngclient) async{
    final url = 'http://10.128.128.35:4000/pedido_api';
    final url2= "https://sade-app.herokuapp.com/pedido_api";
    final timeStamp = DateTime.now();
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List productos = [];
    List cantidad = [];

   /* Map<String,CartItem> _items = {};

    _items.forEach((key, CartItem) {

      print('El id es: ${CartItem.id}');
      print('La cantidad es: ${CartItem.cart_product_count}');

    });*/


    print(cartProducts);
    Session miSesion;

    Map data = {
      'user': user,
      'pago': pago,
      'cart': cartProducts.map((cp) => {
        'id':cp.id,
        'nombre_producto':cp.cart_product_name,
        'precio': cp.cart_product_price,
        'cantidad': cp.cart_product_count,

      }).toString(),
      'latclient': latclient.toString(),
      'lngclient': lngclient.toString(),

    };
    var jsonResponse = null;






    var response = await http.post(url, body: data);
    // final response = await http.post('http://10.0.0.7:4000/pedido_api',body: data);


    jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {

      Fluttertoast.showToast(msg: "Pedido Realizado");

    }else if(response.statusCode == 400){

      Fluttertoast.showToast(msg: "No tienes ningún artículo agregado");

    }else{
      final mensaje = response.body.toString();
      Fluttertoast.showToast( msg: mensaje);
      print(response.body);
    }

  }


}

class Session {
  Map<String, String> headers = {};

  Future<Map> get(String url) async {
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  Future<Map> post(String url, dynamic data) async {
    http.Response response = await http.post(url, body: data, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}

