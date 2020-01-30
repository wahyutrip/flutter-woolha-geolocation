import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Geolocation',
      home: GeolocationExample(),
    );
  }
}

class GeolocationExample extends StatefulWidget {
  @override
  _GeolocationExample createState() => _GeolocationExample();
}

class _GeolocationExample extends State<GeolocationExample> {
  Geolocator _geolocator;
  Position _position;

  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    _geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }

  @override
  void initState() {
    super.initState();
    _geolocator = Geolocator();
    LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 1);

    checkPermission();
    updateLocation();

    StreamSubscription positionStream = _geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      _position = position;
    });
  }

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .timeout(new Duration(seconds: 5));

      setState(() {
        _position = newPosition;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: Center(
        child: Text(
            'Latitude: ${_position != null ? _position.latitude.toString() : '0'},'
            ' Longitude: ${_position != null ? _position.longitude.toString() : '0'}'),
      ),
    );
  }
}
