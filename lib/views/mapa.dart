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
import 'package:google_maps_webservice/places.dart';
import 'package:loquesea/services/geolocator_service.dart';
import 'package:loquesea/views/geo_state.dart';
import 'package:loquesea/views/google_maps_request.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http ;




class mapa extends StatefulWidget {
  final Position initialPosition;

  mapa(this.initialPosition);



  @override
  _mapaState createState() => _mapaState();
}

class _mapaState extends State<mapa> {
  final GeolocatorService geoService = GeolocatorService();
  Completer<GoogleMapController> _controller = Completer();



 /* TextEditingController locationController = TextEditingController();
  //TextEditingController destinationController = TextEditingController();
  static LatLng _initialPosition;*/

  String destinationController = "PUCMM Santiago";

  //String destinationController = "Charleston Campus";


 /* LatLng _lastPosition = _initialPosition;*/




  //BitmapDescriptor customIcon;

  BitmapDescriptor icon;






  @override
  void initState() {
    geoService.getCurrentLocation().listen((position) {
      centerScreen(position);
    });
    getIcons();
    super.initState();
    //_getUserLocation();

  }

  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 3.0), "assets/UIHere.png");
    setState(() {
      this.icon = icon;
    });
  }

//crear Marker
  /*Set<Marker> _createMarker() {
    var marker = Set<Marker>();

    marker.add(Marker(
      markerId: MarkerId("MarkerCurrent"),
      position: _lastPosition,
      icon: icon,
      infoWindow: InfoWindow(
        title: "Mi Ubicacion",
        snippet: "Lat ${_lastPosition.latitude} - Lng ${_lastPosition.longitude} ",
      ),
      draggable: true,

    ));

    return marker;
  }*/



  @override
  Widget build(BuildContext context) {
    final geO_state = Provider.of<geo_state>(context);

    return SafeArea(
       child: geO_state.initialPosition == null ? Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitWave(
                    color: Colors.black,
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Visibility(
                visible: geO_state.locationServiceActive == false,
                child: Text("Por favor habilitar los servicios de localización", style: TextStyle(color: Colors.lightBlue),
                ),
              )
            ],
          ),

        )
            : Stack( children:<Widget>[
         GoogleMap(
           initialCameraPosition: CameraPosition(target: LatLng(geO_state.initialPosition.latitude, geO_state.initialPosition.longitude), zoom: 15.0),
           //mapType: MapType.hybrid,
           myLocationEnabled: true,
           myLocationButtonEnabled: true,
           markers: geO_state.markers,
           polylines: geO_state.polylines,
          // onCameraMove: geO_state.actualizando(),
           onCameraMove: geO_state.onCameraMove,


           onMapCreated: (GoogleMapController controller){
             //controller.setMapStyle('[{"featureType": "administrative.land_parcel","elementType": "labels","stylers": [{"visibility": "off"}]},{"featureType": "poi","elementType": "labels.text","stylers": [{"visibility": "off"}]},{"featureType": "road.local","elementType": "labels","stylers": [{"visibility": "off"}]}]');


             _controller.complete(controller);

             geO_state.sendRequest(destinationController);


           },


         ),




         /* Material(

              child: Container(
                height: 59.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 5.0),
                        blurRadius: 10,
                        spreadRadius: 3)
                  ],
                ),
                child: TextField(
                  onTap: ()async{
                    Prediction p = await PlacesAutocomplete.show(context: context,
                        apiKey: "AIzaSyB7la-FupTRMVOmEyDV_5ABtzWcKbgotnY",
                        language: "es", components: [
                          Component(Component.country, "us" ),
                        ]),
                  },
                  cursorColor: Colors.black,
                  controller: geO_state.destinationController,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) {
                    geO_state.sendRequest(value);
                  },
                  decoration: InputDecoration(
                    icon: Container(
                      margin: EdgeInsets.only(left: 20, top: 5),
                      width: 10,
                      height: 15,
                      child: Icon(
                        Icons.local_taxi,
                        color: Colors.black,
                      ),
                    ),
                    hintText: "Destino",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                  ),
                ),
              ),

          ),*/





          /*  Positioned(
        top: 50.0,
        right: 15.0,
        left: 15.0,
        child: Container(
          height: 50.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 5.0),
                  blurRadius: 10,
                  spreadRadius: 3)
            ],
          ),
          child: TextField(
            cursorColor: Colors.black,
            //controller: appState.locationController,
            decoration: InputDecoration(
              icon: Container(
                margin: EdgeInsets.only(left: 20, top: 5),
                width: 10,
                height: 10,
                child: Icon(
                  Icons.location_on,
                  color: Colors.black,
                ),
              ),
              hintText: "pick up",
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
            ),
          ),
        ),
      ),*/


          /*Positioned(
        top: 40,
        right: 10,
        child: FloatingActionButton(onPressed: _onAddMarkedPressed,
        tooltip: "add marker",
          backgroundColor: Colors.black,
        ),
      )*/
        ],


        )
    );
      /*Scaffold(
      body: StreamBuilder<Position>(
        stream: geoService.getCurrentLocation(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
          return Center(child: Text(' Lat: ${snapshot.data.latitude} , Lng: ${snapshot.data.longitude}',
            style: TextStyle(
              fontSize: 20.0
            ),
          ),
          );
        }),
    );*/
  
      
  }


  
  
  Future<void> centerScreen(Position position) async{
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude),zoom: 18.0)));

  }

  // ! CREATE LAGLNG LIST




/*  void _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      locationController.text = placemark[0].name;
    });
  }*/











  /*void _onAddMarkedPressed(){
    setState(() {
      _markers.add(Marker(markerId: MarkerId(_lastPosition.toString()),
      position: _lastPosition,
        infoWindow: InfoWindow(
          title: "Recordatorio",
          snippet: "Buen sitio"
        )
      ));
    });

  }*/
      
}
