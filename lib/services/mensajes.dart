
import 'package:flutter/material.dart';
//import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sms_maintained/sms.dart';

class mensajes extends StatefulWidget {

  final telefono;
  final List sm;


  mensajes(
      this.telefono,
      this.sm,
      );

  @override
  _mensajesState createState() => _mensajesState();
}

class _mensajesState extends State<mensajes> {


 // var sm = ["Estoy de camino","Llegue a la ubicación"];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Mensajes rápidos", style: TextStyle(color: Colors.white)),
      ),
      body: new ListView.builder( itemCount: widget.sm.length , itemBuilder: (BuildContext context, int index){
        return Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, ),
          child: Row(children: <Widget>[

            Spacer(),


            MaterialButton( onPressed: (){

              //Navigator.push(context, MaterialPageRoute(builder: (context)=> new ubicacion(widget.latclient, widget.lngclient)));

              enviar_mensaje(widget.telefono, widget.sm[index], context);

            },
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              color: Colors.green,
              textColor: Colors.white,
              elevation: 0.2,
              child: new Text("${widget.sm[index]}",style: TextStyle(fontSize: 20),textAlign: TextAlign.left,),
            )

            ]),
        );




      }),

    );
  }
}


enviar_mensaje(telefono, mensaje, BuildContext context) async {


  SmsSender sender = SmsSender();
  String address = "+1"+telefono.toString();

  print(address+mensaje);

  ProgressDialog dialog = new ProgressDialog( context);
  dialog.style(
      message: 'Enviando mensaje...'
  );
  await dialog.show();

  SmsMessage message = SmsMessage(address, mensaje);
  message.onStateChanged.listen((state) {
    if (state == SmsMessageState.Sent) {
      print("SMS is sent!");
    } else if (state == SmsMessageState.Delivered) {
      print("SMS is delivered!");
    }
  });
  sender.sendSms(message);

  await dialog.hide();

}
