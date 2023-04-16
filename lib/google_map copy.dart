// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../login/home_screen.dart';
import '../login/login/login_screen.dart';
import '../model/shared_preference.dart';
import '../screens/home.dart';
import 'google_map.dart';
import 'google_map_api.dart';

class LocationTrack extends StatefulWidget {
  const LocationTrack({Key? key}) : super(key: key);

  @override
  _LocationTrackState createState() => _LocationTrackState();
}

class _LocationTrackState extends State<LocationTrack> {
  LatLng sourceLocation = LatLng(28.432864, 77.002563);
  LatLng destinationLatlng = LatLng(28.431626, 77.002475);
  PrefService _prefService = PrefService();

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _marker = Set<Marker>();

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  late StreamSubscription<LocationData> subscription;

  LocationData? currentLocation;
  late LocationData destinationLocation;
  late Location location;

  int index = 1;

  Future<bool?> _onBackPressed() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Do you want to exit?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  SystemNavigator.pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();

    location = Location();
    polylinePoints = PolylinePoints();

    subscription = location.onLocationChanged.listen((clocation) {
      currentLocation = clocation;

      updatePinsOnMap();
    });

    setInitialLocation();
  }

  void setInitialLocation() async {
    await location.getLocation().then((value) {
      currentLocation = value;
      setState(() {});
    });

    destinationLocation = LocationData.fromMap({
      "latitude": destinationLatlng.latitude,
      "longitude": destinationLatlng.longitude,
    });
  }

  void showLocationPins() {
    var sourceposition = LatLng(
        currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0);

    var destinationPosition =
        LatLng(destinationLatlng.latitude, destinationLatlng.longitude);

    _marker.add(Marker(
      markerId: MarkerId('sourcePosition'),
      position: sourceposition,
    ));

    _marker.add(
      Marker(
        markerId: MarkerId('destinationPosition'),
        position: destinationPosition,
      ),
    );

    setPolylinesInMap();
  }

  void setPolylinesInMap() async {
    var result = await polylinePoints.getRouteBetweenCoordinates(
      GoogleMapApi().url,
      PointLatLng(
          currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0),
      PointLatLng(destinationLatlng.latitude, destinationLatlng.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setState(() {
      _polylines.add(Polyline(
        width: 5,
        polylineId: PolylineId('polyline'),
        color: Colors.blueAccent,
        points: polylineCoordinates,
      ));
    });
  }

  void updatePinsOnMap() async {
    CameraPosition cameraPosition = CameraPosition(
      zoom: 20,
      target: LatLng(
          currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0),
    );

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    var sourcePosition = LatLng(
        currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0);

    setState(() {
      _marker.removeWhere((marker) => marker.mapsId.value == 'sourcePosition');

      _marker.add(Marker(
        markerId: MarkerId('sourcePosition'),
        position: sourcePosition,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: 20,
      tilt: 80,
      bearing: 30,
      target: currentLocation != null
          ? LatLng(currentLocation!.latitude ?? 0.0,
              currentLocation!.longitude ?? 0.0)
          : LatLng(0.0, 0.0),
    );

    return currentLocation == null
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: WillPopScope(
              onWillPop: () async {
                bool? result = await _onBackPressed();
                if (result == null) {
                  result = false;
                }
                return result;
              },
              child: Scaffold(
                bottomNavigationBar: CurvedNavigationBar(
                    index: 2,
                    onTap: (index) {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => HomeScreen(),
                          ));
                    },
                    backgroundColor: Colors.transparent,
                    color: Colors.deepPurple,
                    animationDuration: const Duration(milliseconds: 300),
                    height: 60,
                    items: [
                      IconButton(
                          icon: Icon(
                            Icons.directions_bus_filled_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PassengerMode()),
                            );
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()),
                            );
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.person_pin_circle_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LocationTrack()),
                            );
                          }),
                    ]),
                //extendBodyBehindAppBar: true,
                appBar: AppBar(
                  //toolbarHeight: 70,
                  brightness: Brightness.dark,
                  title: const Text(
                    'KRU BUSES',
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),

                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 4.0,
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        color: Colors.white),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.logout_rounded,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        await _prefService
                            .removeCache("email", "password")
                            .whenComplete(() => {
                                  logout(context),
                                });
                      },
                    )
                  ],
                ),

                body: GoogleMap(
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  //compassEnabled: true,
                  markers: _marker,
                  polylines: _polylines,
                  mapType: MapType.normal,
                  initialCameraPosition: initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    showLocationPins();
                  },
                ),
              ),
            ),
          );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
