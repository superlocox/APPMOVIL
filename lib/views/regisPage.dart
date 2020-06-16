import 'dart:convert';

import 'package:loquesea/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:loquesea/views/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http ;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

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
      child: Column(
        children: <Widget>[




          TextField(
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
          ),
          SizedBox(height: 30.0,),

          TextField(
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
          ),
          SizedBox(height: 30.0,),

          TextField(
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
          ),
          SizedBox(height: 30.0,),

          TextField(
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
          ),
          SizedBox(height: 30.0,),

          TextField(
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



          ),
          SizedBox(height: 30.0,),
        ],
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
        onPressed: emailController.text == "" || passwordController == ""
            ? null
            : () {
          setState(() {
            _isLoading = true;
          });
          //signIn(emailController.text, passwordController.text);
          signUp(nombreController.text, apellidoController.text, celularController.text, emailController.text, passwordController.text);
        },
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
    var response = await http.post(
        "http://10.0.0.7:4000/singup_api", body: data);
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
