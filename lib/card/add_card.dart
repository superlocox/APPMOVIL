import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http ;
import 'package:loquesea/card/card_view.dart';


class add_card extends StatefulWidget {


  final email;

  add_card(
      this.email,
      );

  @override
  _add_cardState createState() => _add_cardState();
}

class _add_cardState extends State<add_card> {

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool showBackView = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onCreditCardModel(CreditCardModel creditCardModel){
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      cardHolderName = creditCardModel.cardHolderName;
      expiryDate = creditCardModel.expiryDate;
      cvvCode = creditCardModel.cvvCode;
      showBackView = creditCardModel.isCvvFocused;

    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregando tarjeta'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10,),

            CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                height: 210,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: showBackView,
              cardBgColor: Colors.blue[900],
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,

              ),
              animationDuration: Duration(milliseconds: 1200),
            ),

            Expanded(
                child: SingleChildScrollView(

                  child: Column(
                    children: [
                      CreditCardForm(

                        formKey: formKey,

                        onCreditCardModelChange: onCreditCardModel,
                        cursorColor: Colors.red,
                        themeColor: Colors.black,
                        cardNumberDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Número de la tarjeta',
                          hintText: 'XXXX XXXX XXXX XXXX',
                        ),
                        expiryDateDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Fecha de vencimiento',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nombre del dueño de la tarjeta',
                        ),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          child: const Text(
                            'Agregar',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'halter',
                              fontSize: 14,
                              package: 'flutter_credit_card',
                            ),
                          ),
                        ),
                        color: const Color(0xff1b447b),
                        onPressed: () {
                          if (formKey.currentState.validate()) {

                            print(expiryDate);

                            print('valid!');

                            salvar_tarjeta(cardNumber, expiryDate, cardHolderName, cvvCode, widget.email);
                          } else {
                            print('invalid!');

                            print(expiryDate);
                          }
                        },
                      ),
                    ],
                  )

                )
            ),

          ],
        ),
      )
    );
  }


  salvar_tarjeta (cardNumber, expiryDate, cardHolderName, cvvCode, email) async {

    Map data = {
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cardHolderName': cardHolderName,
      'cvvCode': cvvCode,
      'email': email,

    };

    var jsonResponse = null;
    String url1 = "https://sade-app.herokuapp.com/save_credit";
    String url2= "http://10.128.128.35:4000/save_credit";
    var response = await http.post(url2, body: data);

    jsonResponse = json.decode(response.body);

    if (response.statusCode == 200){
      Navigator.pop(context, MaterialPageRoute(builder: (context)=> new card_view(widget.email)));
      Fluttertoast.showToast(msg: "Se agregó la tarjeta");


    }else if (response.statusCode == 500){
      Fluttertoast.showToast(msg: "Algo salió mal");

    }



  }


}
