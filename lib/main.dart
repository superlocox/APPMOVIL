import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:loquesea/card/card_view.dart';
import 'package:loquesea/views/DirectionsProvider.dart';
import 'package:loquesea/views/carrito.dart';
import 'package:loquesea/views/carrito_screen.dart';
import 'package:loquesea/views/cart.dart';
import 'package:loquesea/views/geo_state.dart';
import 'package:loquesea/views/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:loquesea/views/mi_pedido.dart';
import 'package:loquesea/views/orders.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loquesea/views/listProducts.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    String email = "";
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Carrito()),
        ChangeNotifierProvider.value(value: Orders()),
        ChangeNotifierProvider.value(value: geo_state()),
        ChangeNotifierProvider.value(value: DirectionProvider()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App Nodejs',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home: MainPage(email: email,),
       /* routes: {
          carrito_screen.routeName: (context)=>carrito_screen(),
        },*/
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final email;
  bool wantsTouchId;
  final password;

  MainPage({
    this.email,
    this.wantsTouchId,
    this.password
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  


  SharedPreferences sharedPreferences;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var list;
  var random;

  final LocalAuthentication auth = LocalAuthentication();
  final storage = FlutterSecureStorage();

  @override
  void initState(){
    //super.initState();
    checkLoginStatus();

    if(widget.wantsTouchId == null){
      widget.wantsTouchId = false;
    }

    if (widget.wantsTouchId) {
      authenticate();
    }

    random = Random();
    refreshList();

    super.initState();
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

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      //list = List.generate(random.nextInt(10), (i) => "Item $i");
    });

    return null;
  }

  Future<Null> _onRefresh() {
    Completer<Null> completer = new Completer<Null>();

    new Timer(new Duration(seconds: 3), () {
      print("timer complete");
      completer.complete();
    });

    return completer.future;
  }

  checkLoginStatus() async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token")==null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> LoginPage()),(Route<dynamic> route)=> false);
    }
  }

  @override
  Widget build(BuildContext context) {

    final geO_state = Provider.of<geo_state>(context);

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("SADE", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          new IconButton(icon: Icon(
              Icons.shopping_cart,
              color: Colors.white
          ), onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=> new Cart()));
            //Navigator.of(context).pushNamed(carrito_screen.routeName);
            Navigator.push(context, MaterialPageRoute(builder: (context)=> new carrito_screen(widget.email)));
          }),

          FlatButton(
            onPressed: (){
              sharedPreferences.clear();
              //sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> LoginPage()),(Route<dynamic> route)=> false);
            },
            child: Text("Logout", style: TextStyle(color: Colors.white),),
          ),

        ],
      ),
      body: RefreshIndicator(
        key: refreshKey,

        child: new ListView(
          children: <Widget>[
            Container(
              height: 600.0,
              child: ListProducts(),
            )
          ],
        ),

        onRefresh: refreshList,

      ),
      drawer: Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              //accountName: new Text("Nodejs"),
              accountEmail: new Text(widget.email),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white,),
                ),
              ),
            ),
            // new ListTile(title: new Text("Lista de Pedidos"),
            //   trailing: new Icon(Icons.list),
            //   onTap: (){
            //
            //     Navigator.push(context, MaterialPageRoute(builder: (context)=> new mip_pedido(widget.email)));
            //   },
            // ),
            //
            // InkWell(
            //   onTap: (){
            //     print("La longitud es:");
            //     print(geO_state.initialPosition.longitude);
            //     print("La latitud es:");
            //     print(geO_state.initialPosition.latitude);
            //   },
            //   child: ListTile(
            //     title: Text('Página Principal'),
            //     leading: Icon(Icons.home, color: Colors.green,),
            //   ),
            // ),

            InkWell(
              onTap: (){

                Navigator.push(context, MaterialPageRoute(builder: (context)=> new mip_pedido(widget.email)));
              },
              child: ListTile(
                title: Text('Mis pedidos'),
                leading: Icon(Icons.shopping_basket, color: Colors.green,),
              ),
            ),

            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> new card_view(widget.email)));
              },
              child: ListTile(
                title: Text("Tarjeta"),
                leading: Icon(Icons.credit_card, color: Colors.green,),
              ),
            ),

            // InkWell(
            //   onTap: (){},
            //   child: ListTile(
            //     title: Text('Configuraciones'),
            //     leading: Icon(Icons.settings, color: Colors.grey,),
            //   ),
            // ),

          ],
        ),
      ),

    );
  }
}
