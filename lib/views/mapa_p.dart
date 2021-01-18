
import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart';
import 'package:loquesea/services/geolocator_service.dart';
import 'package:loquesea/views/geo_state.dart';
import 'package:loquesea/views/google_maps_request.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http ;
import 'package:location/location.dart';


class mapa_p extends StatefulWidget {


  @override
  _mapa_pState createState() => _mapa_pState();
}

class _mapa_pState extends State<mapa_p> {

  GoogleMapController _mapController;
  Location _location =  Location();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initLocation();
  }

  _initLocation() async{
    var _serviceEnabled = await _location.serviceEnabled();
    if( !_serviceEnabled){
      _serviceEnabled = await _location.requestService();
      if(! _serviceEnabled){
        return;
      }
    }

    var _permisisionGranted = await _location.hasPermission();
    if(_permisisionGranted == PermissionStatus.denied){
      _permisisionGranted = await _location.requestPermission();
      if(_permisisionGranted == PermissionStatus.granted){
        print("No permission");
        return;
      }
    }

    _location.onLocationChanged.listen((LocationData event){
      
      if (_mapController == null){
        _mapController.animateCamera(CameraUpdate.newLatLng(LatLng(event.latitude,event.longitude)));
      }
      print("${event.latitude}, ${event.longitude}");
    });

  }



  @override
  Widget build(BuildContext context) {

    final geO_state = Provider.of<geo_state>(context);


    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido en progreso"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(geO_state.initialPosition.latitude, geO_state.initialPosition.longitude),
          zoom: 15.0,
        ),
        zoomGesturesEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (controller)=> _mapController = controller,
      ),
    );
  }
}


