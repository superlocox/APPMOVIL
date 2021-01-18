import 'dart:convert';

import 'package:loquesea/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:loquesea/views/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http ;
import 'package:form_field_validator/form_field_validator.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void validate(){
    if(formkey.currentState.validate()){
      print("Valido");
      signUp(nombreController.text, apellidoController.text, celularController.text, emailController.text, passwordController.text);

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

  final TextEditingController nombreController = new TextEditingController();
  final TextEditingController apellidoController = new TextEditingController();
  final TextEditingController celularController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool passwordVisible = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.green, Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          ),

        ),
        child: ListView(
          children: <Widget>[
            heardSection(),
            textSection(),
            buttonSection(),
          ],
        ),
      ),

    );
  }



  Container heardSection() {
    return Container(
        margin: EdgeInsets.only(top: 50.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Text("Registrar cuenta",
          style: TextStyle(
              color: Colors.white70,
              fontSize: 40.0,
              fontWeight: FontWeight.bold),)


    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Form(
        autovalidate: true,
        key: formkey,
        child: Column(
          children: <Widget>[




            TextFormField(
              controller: nombreController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                  icon: Icon(Icons.person, color: Colors.white70),
                  hintText: "Nombre",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70)),
                  hintStyle: TextStyle(color: Colors.white)
              ),
              validator:  RequiredValidator(errorText: "Requerido"),
            ),
            SizedBox(height: 30.0,),

            TextFormField(
              controller: apellidoController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                  icon: Icon(Icons.person, color: Colors.white70),
                  hintText: "Apellido",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70)),
                  hintStyle: TextStyle(color: Colors.white)
              ),
              validator:  RequiredValidator(errorText: "Requerido"),
            ),
            SizedBox(height: 30.0,),

            TextFormField(
              controller: celularController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                  icon: Icon(Icons.phone, color: Colors.white70),
                  hintText: "Número célular",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70)),
                  hintStyle: TextStyle(color: Colors.white)
              ),
              validator:  MultiValidator([
                RequiredValidator(errorText: "Requerido"),
                MinLengthValidator(10 ,errorText: "No menos de 10 caracteres"),
                MaxLengthValidator(10, errorText: "No mas de 10 caracteres")
              ]),
            ),
            SizedBox(height: 30.0,),

            TextFormField(
              controller: emailController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                  icon: Icon(Icons.email, color: Colors.white70),
                  hintText: "Correo",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70)),
                  hintStyle: TextStyle(color: Colors.white)
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
              controller: passwordController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white70),
              obscureText: passwordVisible,
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: Colors.white70),
                hintText: "Contraseña",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white70),
                  onPressed: () {
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

  Container buttonSection() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 50.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: RaisedButton(
        // ignore: unrelated_type_equality_checks
        onPressed: validate,

        /*emailController.text == "" || passwordController == ""
            ? null
            : () {
          setState(() {
            _isLoading = true;
          });
          //signIn(emailController.text, passwordController.text);
          signUp(nombreController.text, apellidoController.text, celularController.text, emailController.text, passwordController.text);
        },*/
        elevation: 0.0,
        color: Colors.purple,
        child: Text("Registrarse", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  signUp(String name, apellido, celular, email, pass,) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'name': name,
      'apellido': apellido,
      'celular': celular,
      'email': email,
      'password': pass
    };
    var jsonResponse = null;

    String url1 = "https://sade-app.herokuapp.com/singup_api";
    String url2= "http://10.128.128.35:4000/singup_api";

    var response = await http.post(url2, body: data);
    jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> new LoginPage()));
        Fluttertoast.showToast(msg: "Se registró correctamente");
      }
    }

    else {
      Fluttertoast.showToast(msg: "Correo ó contraseña equivocada");
      setState(() {
        _isLoading = false;
      });
      print(response.body);

    }

  }



}
