import 'package:flutter/material.dart';
import 'package:emergency/srceens/Widget/send_emergency.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

const apiKey = "AIzaSyBf5vU8OiDXzufPAtbA-KqWdqhIm0O7xr4";

class ShowLocation extends StatefulWidget {
  final Map points;

  ShowLocation({this.points});

  @override
  _ShowLocationState createState() => _ShowLocationState();
}

class _ShowLocationState extends State<ShowLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        title: Text('Location'),
        backgroundColor: Color(0xffe46b10),
        centerTitle: true,
      ),
      body: PlacePicker(
        apiKey: apiKey, // Put YOUR OWN KEY here.
        initialPosition: LatLng(widget.points['lat'], widget.points['lng']),
        useCurrentLocation: false,
      ),
    );
  }
}
