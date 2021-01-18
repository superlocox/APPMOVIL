import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loquesea/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:loquesea/views/geo_state.dart';
import 'package:loquesea/views/pedidos.dart';
import 'package:loquesea/views/regisPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http ;
import 'package:form_field_validator/form_field_validator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  LatLng cord;




  void validate(){
   // double lat = cord.latitude;
   // double long = cord.longitude;
    if(formkey.currentState.validate()){

      signIn(emailController.text, passwordController.text);
      print("Valido");
    }else{
      print("No valido");
    }
  }

  String validatepass(value){
    if(value.isEmpty){
      return "Requerido";

    }else if(value.length <8){
      return "No puede ser menor que 8 carácteres";
    }else {
      return null;
    }

  }

  bool _isLoading = false;

  bool userHasTouchId = false;
  bool _useTouchId = false;

  final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool passwordVisible = true;

  @override
  void initState() {

    getSecureStorage();
   //delete();


    super.initState();
  }

  void getSecureStorage() async {
    final isUsingBio = await storage.read(key: 'usingBiometric');
    setState(() {
      userHasTouchId = isUsingBio == 'true';
    });
  }

  void delete() async{

    final isUsingBio = await storage.read(key: 'usingBiometric');
    setState(() {
      userHasTouchId = isUsingBio == 'false';
    });


  }



  @override
  Widget build(BuildContext context) {

 /*   final geO_state = Provider.of<geo_state>(context);

  geO_state.getUserLocation();
  cord= geO_state.lastPosition;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent));*/

    return Scaffold(

      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.green, Colors.teal],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
            ),

          ),

          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView(
              children: <Widget>[
              heardSection(),
              textSection(),
              buttonSection(),
              sign_up(),
            ],
          )
      ),

    );
  }

  signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email,
      'password': pass,
     // 'lat': lat as String,
      //'lng': lng as String,
    };
    var jsonResponse = null;
    String url1 = "https://sade-app.herokuapp.com/sigin_api";
    String url2= "http://10.128.128.35:4000/sigin_api";
    var response = await http.post(url2, body: data);


    jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MainPage(
              email: data['email'],
              wantsTouchId: _useTouchId,
              password: data['password'],
            )), (
            Route<dynamic> route) => false);
        Fluttertoast.showToast(msg: "Se conectó correctamente");
      }
    } else if (response.statusCode == 201){

      jsonResponse = json.decode(response.body);

      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => pedidos(
              email: data['email'],
              wantsTouchId: _useTouchId,
              password: data['password'],

            )), (
            Route<dynamic> route) => false);
        Fluttertoast.showToast(msg: "Se conectó correctamente el mensajero");
      }


    } else {

      setState(() {
        _isLoading = false;
      });



      Fluttertoast.showToast(msg: "Correo ó contraseña equivocada");
      print(response.body);

    }

  }

  userLocationUpdate(String email){



  }

  Container buttonSection(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: RaisedButton(
        // ignore: unrelated_type_equality_checks
        onPressed: validate
        //Ctrl+shif+/ para uncomment/comment

       /* emailController.text == "" || passwordController == "" ? null : (){
          setState(() {
            _isLoading = true;
          });
          signIn(emailController.text, passwordController.text);
        }*/
        ,
        elevation: 0.0,
        color: Colors.purple,
        child: Text("Iniciar Sesión",style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  Container textSection(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Form(
        autovalidate: true,
        key: formkey,
        child: Column(
          children: <Widget>[

            TextFormField(
              controller:  emailController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                  icon: Icon(Icons.email, color: Colors.white70),
                  hintText: "Correo",
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.white),
                  labelText: "Correo"
              ),
              validator: MultiValidator(
                [
                  RequiredValidator(errorText: "Requerido"),
                  EmailValidator(errorText: "Email no válido")
                ]

              ),
            ),
            SizedBox(height: 30.0,),

            TextFormField(
              controller:  passwordController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white70),
              obscureText: passwordVisible,
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: Colors.white70),
                hintText: "Contraseña",
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.white),
                labelText: "Contraseña",
                suffixIcon: IconButton(
                  icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
                  onPressed: (){
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),

              ),
              validator: validatepass,


            ),
            SizedBox(height: 30.0,),
            userHasTouchId
                ? InkWell(
              onTap: () => authenticate(),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.purple,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    FontAwesomeIcons.fingerprint,
                    size: 30,
                  )),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Checkbox(
                  activeColor: Colors.orange,
                  value: _useTouchId,
                  onChanged: (newValue) {
                    setState(() {
                      _useTouchId = newValue;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Usar Lector de Huella',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Container heardSection(){
    return Container(
        margin: EdgeInsets.only(top: 50.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 30.0),
        child: Text("SADE",
          style: TextStyle(
              color: Colors.white70,
              fontSize: 40.0,
              fontWeight: FontWeight.bold),)



    );

  }
  Container sign_up(){
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> new SignUp()));
          },
          child: Text("Registrate", style: TextStyle(color: Colors.red),),
        )
      ),

    );

  }

  void authenticate() async {
    final canCheck = await auth.canCheckBiometrics;

    if (canCheck) {
      List<BiometricType> availableBiometrics =
      await auth.getAvailableBiometrics();


        if (availableBiometrics.contains(BiometricType.fingerprint)) {
          // Face ID.
          final authenticated = await auth.authenticateWithBiometrics(
              localizedReason: 'Por favor colocar su huella en el lector de huellas');
          if (authenticated) {
            final userStoredEmail = await storage.read(key: 'email');
            final userStoredPassword = await storage.read(key: 'password');

            signIn(userStoredEmail,  userStoredPassword);
          }
        }

       /* else if (availableBiometrics.contains(BiometricType.face)) {
          // Touch ID.
        }*/

    } else {
      print('cant check');
    }
  }
}
