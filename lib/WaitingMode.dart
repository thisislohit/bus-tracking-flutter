import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class WaitingMode extends StatefulWidget {
  @override
  _WaitingModeState createState() => _WaitingModeState();
}

class _WaitingModeState extends State<WaitingMode> {
  DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _getPassengerLocations();
  }

  void _getPassengerLocations() {
    _databaseRef.onChildAdded.listen((event) {
      Map<String, dynamic> data = event.snapshot.value as Map<String, dynamic>;
      double latitude = data['latitude'];
      double longitude = data['longitude'];
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(event.snapshot.key ?? ""),
            position: LatLng(latitude, longitude),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waiting Mode'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 15,
        ),
        markers: Set<Marker>.of(_markers),
      ),
    );
  }
}
