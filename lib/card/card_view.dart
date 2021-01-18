import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http ;
import 'package:loquesea/card/add_card.dart';

class card_view extends StatefulWidget {
  final email;

  card_view(
      this.email,
      );

  @override
  _card_viewState createState() => _card_viewState();
}

class _card_viewState extends State<card_view> {

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


    }else {
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
   if(estado==false){
     return Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.green,
         title: Text("Tarjeta de crédito/debito", style: TextStyle(color: Colors.white)),
       ),
       body: Container(

       ),
       floatingActionButton: FloatingActionButton(
         onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=> new add_card(widget.email)));
         },
         child: Text('+'),
         backgroundColor: Colors.green,
       ),
     );
   }else if(estado==true){
     return Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.green,
         title: Text("Tarjeta de crédito/debito", style: TextStyle(color: Colors.white)),
       ),
       body: Container(
         padding: EdgeInsets.all(20),
         child: InkWell(
           child: CreditCardWidget(
             cardNumber: cardData['cardNumber'],
             expiryDate: cardData['expiryDate'],
             cardHolderName: cardData['cardHolderName'],
             cvvCode: cardData['cvvCode'],
             showBackView: false,
           ),
         ),

       ),

     );
   }
  }
}
