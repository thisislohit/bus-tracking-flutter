import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';

class PassengerMode extends StatefulWidget {
  @override
  _PassengerModeState createState() => _PassengerModeState();
}

class _PassengerModeState extends State<PassengerMode> {
  DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();

  late Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
    _uploadLocationToDatabase(position.latitude, position.longitude);
  }

  void _uploadLocationToDatabase(double latitude, double longitude) {
    _databaseRef.push().set({
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passenger Mode'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Latitude: ${_currentPosition.latitude}'),
            Text('Longitude: ${_currentPosition.longitude}'),
          ],
        ),
      ),
    );
  }
}
