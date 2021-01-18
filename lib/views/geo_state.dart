



import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'google_maps_request.dart';

class geo_state with ChangeNotifier{

  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;
  Set<Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;
  String destino = "Shoreline Golf Links";

  bool locationServiceActive = true;




  geo_state(){
    getUserLocation();
    _loadingInitialPosition();
  }


  // Recoger Localizacion
  void getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);

      _initialPosition = LatLng(position.latitude, position.longitude);
      locationController.text = placemark[0].name;
      notifyListeners();

  }

  // Crear Ruta
  void createRoute(String encodedPoly){

      _polylines.add(Polyline(
          polylineId: PolylineId(_lastPosition.toString()),
          width: 5,
          points: _convertToLatLng(_decodePoly(encodedPoly)),
          color: Colors.blueAccent));
        //sleep(const Duration(seconds: 1));
      notifyListeners();

  }

  // Agregar marker
  void _addMarker(LatLng location, String address) {
     _markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "Destino"),
        icon: BitmapDescriptor.defaultMarker));

    notifyListeners();
  }


  // Convertidor latlng
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  void sendRequest(String intendedLocation) async{
    List<Placemark> placemark = await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);

    _addMarker(destination,intendedLocation);

    String route = await _googleMapsServices.getRouteCoordinates(_initialPosition, destination);
    createRoute(route);
    notifyListeners();

  }

  void sendRequestx(Position intendedLocation) async{
    List<Placemark> placemark = await Geolocator().placemarkFromPosition(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);

    _addMarkerx(destination);

     String route = await _googleMapsServices.getRouteCoordinates(_initialPosition, destination);
    createRoute(route);
    notifyListeners();

  }

  void _addMarkerx(LatLng location) {
      _markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position: location,
        infoWindow: InfoWindow( snippet: "Destino"),
        icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  void onCameraMove(CameraPosition position){
    _lastPosition = position.target;
    sendRequest(destino);
    notifyListeners();
  }

  actualizando(){
    sendRequest(destino);
    notifyListeners();

}

  void onCreated(GoogleMapController controller){
    _mapController = controller;
    notifyListeners();
  }
  
  void _loadingInitialPosition() async {

    await Future.delayed(Duration(seconds: 3)).then((value){
      if(_initialPosition == null){
        locationServiceActive = false;
        notifyListeners();
      }
    });



  }

  




}