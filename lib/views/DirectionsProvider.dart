import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:google_maps_webservice/directions.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

class DirectionProvider extends ChangeNotifier {
  GoogleMapsDirections directionsApi =
  GoogleMapsDirections(apiKey: "AIzaSyB7la-FupTRMVOmEyDV_5ABtzWcKbgotnY");

  Set<maps.Polyline> _route = Set();

  Set<maps.Polyline> get currentRoute => _route;

  findDirections(maps.LatLng from, maps.LatLng to) async {
    var origin = Location(from.latitude, from.longitude);
    var destination = Location(to.latitude, to.longitude);

    final result = await directionsApi.directionsWithLocation(
      origin,
      destination,
      travelMode: TravelMode.driving,
    );

    final Set<maps.Polyline> newRoute = {};

    if (result.isOkay) {
      final route = result.routes[0];
      final enumPoints = decodePolyline(route.overviewPolyline.points);
      final List<maps.LatLng> points = [];

      for (final punto in enumPoints) {
        final coordenadas = maps.LatLng.fromJson(punto);
        points.add(coordenadas);
      }

      final line = maps.Polyline(
        points: points,
        polylineId: maps.PolylineId("mejor ruta"),
        color: Colors.red,
        width: 4,
      );
      newRoute.add(line);
      _route = newRoute;
      notifyListeners();
    } else {
      print("ERRROR !!! ${result.status}");
    }
  }
}