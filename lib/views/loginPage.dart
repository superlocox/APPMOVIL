import 'dart:convert';

import 'package:loquesea/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:loquesea/views/pedidos.dart';
import 'package:loquesea/views/regisPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http ;
import 'package:form_field_validator/form_field_validator.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void validate(){
    if(formkey.currentState.validate()){
      print("Valido");
      signIn(emailController.text, passwordController.text);
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

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent));

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
      'password': pass
    };
    var jsonResponse = null;
    var response = await http.post(
        //"https://sade-app.herokuapp.com/sigin_api", body: data)
        "http://10.0.0.7:4000/sigin_api", body: data)

    ;
    jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MainPage()), (
            Route<dynamic> route) => false);
        Fluttertoast.showToast(msg: "Se conectó correctamente");
      }
    }

    if (response.statusCode == 201){

      jsonResponse = json.decode(response.body);

      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => pedidos()), (
            Route<dynamic> route) => false);
        Fluttertoast.showToast(msg: "Se conectó correctamente el mensajero");
      }


    }

    else {

      setState(() {
        _isLoading = false;
      });



      Fluttertoast.showToast(msg: "Correo ó contraseña equivocada");
      print(response.body);

    }

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
        child: Text("SignIn",style: TextStyle(color: Colors.white70)),
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
}
