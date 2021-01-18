import 'dart:async';
import 'dart:convert';

//import 'dart:html';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';
import 'package:loquesea/services/geolocator_service.dart';
import 'package:loquesea/views/geo_state.dart';
import 'package:loquesea/views/google_maps_request.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http ;


class ubicacion extends StatefulWidget {

  final latclient;
  final lngclient;

  ubicacion(
      this.latclient,
      this.lngclient
      );


  @override
  _ubicacionState createState() => _ubicacionState();
}

class _ubicacionState extends State<ubicacion> {

  GoogleMapController mapController;
  Location _location = Location();
  StreamSubscription<LocationData> subscription;

  List<Marker> allmarkers = [];


  //
  // Set<Marker> _createMarker() {
  //   var marker = Set<Marker>();
  //
  //   marker.add(Marker(
  //     markerId: MarkerId("MarkerCurrent"),
  //     position: LatLng(widget.latclient,widget.lngclient),
  //     infoWindow: InfoWindow(
  //       title: "Mi Ubicacion",
  //       snippet: "Lat ${widget.latclient} - Lng ${widget.lngclient} ",
  //     ),
  //     draggable: true,
  //
  //   ));
  //
  //   return marker;
  // }



  


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    allmarkers.add(Marker(
      markerId: MarkerId('Destino'),
      draggable: false,
      onTap: (){
        print('Marker Tapped');
      },
      position: LatLng (widget.latclient, widget.lngclient)
    ));
  }

  _initLocation() async{
    var _serviceEnabled = await  _location.serviceEnabled();
    if(!_serviceEnabled){
      _serviceEnabled = await _location.requestService();
      if(!_serviceEnabled){
        return;
      }
    }

    var _permisionGranted = await _location.hasPermission();
    if(_permisionGranted == PermissionStatus.denied){
      _permisionGranted = await _location.requestPermission();
      if(_permisionGranted == PermissionStatus.granted){
        print("No permission");
        return;
      }
    }

    subscription =_location.onLocationChanged.listen((LocationData event) {
      if( mapController == null){
        mapController.animateCamera(
          CameraUpdate.newLatLng(LatLng(event.latitude,event.longitude)),
        );
      }
      print("${event.latitude},  ${event.longitude} ");

    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(subscription == null){
      subscription.cancel();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context){

  final geO_state = Provider.of<geo_state>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Ubicación del pedido"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target:  LatLng(geO_state.lastPosition.latitude, geO_state.lastPosition.longitude),
          zoom: 16
      ),
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: Set.from(allmarkers),
        onMapCreated: (controller)=> mapController = controller,

      ),
    );
  }
}
