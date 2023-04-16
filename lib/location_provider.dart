import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

class LocationProvider with ChangeNotifier {
  late Location _location;
  Location get location => _location;
  late LatLng _locationPosition;
  LatLng get locationposition => _locationPosition;

  bool locationServiceActive = true;

  LocationProvider() {
    _location = Location();
  }

  initalization() async {
    await getUserLocation();
  }

  getUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();

      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen(
      (LocationData currenLocation) {
        _locationPosition = LatLng(
          currenLocation.latitude!,
          currenLocation.longitude!,
        );
      },
    );
  }
}
