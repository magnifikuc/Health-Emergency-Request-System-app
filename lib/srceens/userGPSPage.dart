import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class UserGPSPage extends StatefulWidget {
  @override
  _UserGPSPageState createState() => _UserGPSPageState();
}

class _UserGPSPageState extends State<UserGPSPage> {
  @override
  Widget build(BuildContext context) {
    _getCurrentLocation();
    // TODO: implement build
    return Container(
      child: Center(
        child: Text(
          _currentAddress,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress;

  _getCurrentLocation() {
    setState(() async {
      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _currentPosition = position;
    });
    _getAddressFromLatLng();
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
}

// geolocator
//     .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
// .then((Position position) {
// setState(() {
// _currentPosition = position;
// });
