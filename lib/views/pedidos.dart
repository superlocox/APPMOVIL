import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:loquesea/services/geolocator_service.dart';
import 'package:loquesea/views/en_proceso.dart';
import 'package:loquesea/views/mapa.dart';
import 'package:loquesea/views/mapa_p.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http ;
import 'package:loquesea/views/lista_pedidos.dart';
import 'package:loquesea/views/finger.dart';

import 'package:loquesea/views/mapa_p.dart';


import 'package:square_in_app_payments/google_pay_constants.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';


import 'loginPage.dart';

// ignore: camel_case_types
class pedidos extends StatefulWidget {

  final email;
  final bool wantsTouchId;
  final password;

  pedidos({
    this.email,
    this.wantsTouchId,
    this.password
});


  @override
  _pedidosState createState() => _pedidosState();
}

// ignore: camel_case_types
class _pedidosState extends State<pedidos> {

  final geoService = GeolocatorService();
  final LocalAuthentication auth = LocalAuthentication();
  final storage = FlutterSecureStorage();

  SharedPreferences sharedPreferences;

  @override
  void initState(){

    checkLoginStatus();

    if (widget.wantsTouchId) {
      authenticate();
    }

    super.initState();


  }

  void pay(){
    InAppPayments.setSquareApplicationId('sandbox-sq0idb-alQms5FlG4Oo-4DbCKXmcg');
    InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: _cardSuccess,
      onCardEntryCancel: _cardCancel
    );
  }

  void _cardCancel(){
    //Cancel card entry
  }

  void _cardSuccess(CardDetails res){

    print(res.nonce);

    InAppPayments.completeCardEntry(
      onCardEntryComplete: _cardEntry,
    );

  }

  void _cardEntry (){

  }




  void authenticate() async {
    final canCheck = await auth.canCheckBiometrics;

    if (canCheck) {
      List<BiometricType> availableBiometrics =
      await auth.getAvailableBiometrics();


        if (availableBiometrics.contains(BiometricType.fingerprint)) {
          // Face ID.
          final authenticated = await auth.authenticateWithBiometrics(
              localizedReason: 'Enable Face ID to sign in more easily');
          if (authenticated) {
            storage.write(key: 'email', value: widget.email);
            storage.write(key: 'password', value: widget.password);
            storage.write(key: 'usingBiometric', value: 'true');
          }
        }
      /*  else if (availableBiometrics.contains(BiometricType.face)) {
          // Touch ID.
        }*/

    } else {
      print('cant check');
    }
  }

  checkLoginStatus() async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token")==null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> LoginPage()),(Route<dynamic> route)=> false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("App Mensajero", style: TextStyle(color: Colors.white)),
          actions: <Widget>[


            FlatButton(
              onPressed: (){
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> LoginPage()),(Route<dynamic> route)=> false);
              },
              child: Text("Logout", style: TextStyle(color: Colors.white),),
            ),

          ],
        ),

        drawer: Drawer(
          child: new ListView(
            children: <Widget>[

              new UserAccountsDrawerHeader(
                accountName: new Text(widget.email),
               // accountEmail: new Text(widget.email),
                currentAccountPicture: GestureDetector(
                  child: new CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white,),
                  ),
                ),
              ),
              new ListTile(title: new Text("Lista de Pedidos"),
                trailing: new Icon(Icons.list),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> new listaPedidos( widget.email)));
                },
              ),


              // InkWell(
              //   onTap: (){
              //
              //     Navigator.push(context, MaterialPageRoute(builder: (context)=> new en_proceso()));
              //
              //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>  FutureProvider(
              //     //     create: (context)=>geoService.getInitialLocation(),
              //     //     child: Consumer<Position>(builder: (context, position, widget){
              //     //   return (position != null) ? mapa(position) : Center(child: CircularProgressIndicator(),);
              //     //
              //     //
              //     // } ,)
              //     // ),
              //     // )
              //     // );
              //   },
              //   child: ListTile(
              //     title: Text("Mapa"),
              //     leading: Icon(Icons.map, color: Colors.green,),
              //   ),
              // ),
              //
              // InkWell(
              //   onTap: (){
              //
              //     pay();
              //
              //   },
              //   child: ListTile(
              //     title: Text("Pago"),
              //     leading: Icon(Icons.payment, color: Colors.green,),
              //   ),
              // ),
              //
              // InkWell(
              //   onTap: (){
              //
              //     Navigator.push(context, MaterialPageRoute(builder: (context)=> new finger()));
              //
              //   },
              //   child: ListTile(
              //     title: Text("Huella"),
              //     leading: Icon(Icons.security, color: Colors.green,),
              //   ),
              // ),
              //
              // InkWell(
              //   onTap: (){
              //
              //     Navigator.push(context, MaterialPageRoute(builder: (context)=> new mapa_p()));
              //
              //   },
              //   child: ListTile(
              //     title: Text("Mapa Pedido"),
              //     leading: Icon(Icons.map, color: Colors.green,),
              //   ),
              // ),









            ],
          ),
        ),

      );

  }
}
