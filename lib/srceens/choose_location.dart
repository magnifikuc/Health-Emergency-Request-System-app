import 'package:emergency/srceens/Widget/send_emergency.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

const apiKey = "AIzaSyBf5vU8OiDXzufPAtbA-KqWdqhIm0O7xr4";

auth.User loggedInUser;

class Location extends StatefulWidget {
  Map users;
  Location({this.users});

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final _auth = auth.FirebaseAuth.instance;
  String profileName = "";

  Map location = {
    'lat': '',
    'lng': '',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.logout,
                semanticLabel: 'logout',
              ),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                // messagesStream();
              }),
        ],
        title: Text('Pick Your location'),
        backgroundColor: Color(0xffe46b10),
        centerTitle: true,
      ),
      drawer: SafeArea(
        child: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            children: <Widget>[
              Container(
                color: Color(0xffe46b10),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CircleAvatar(
                        child: Image.asset('images/nurse_male_480px.png'),
                        backgroundColor: Color(0xffe46b10),
                        radius: 40.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        profileName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          wordSpacing: 10.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Text(
                        'Requests List',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      trailing: Icon(Icons.local_hospital),
                      onTap: () {},
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(
                        'Requests List',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      trailing: Icon(Icons.help_center),
                      onTap: () {},
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(
                        'Edit profile',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      trailing: Icon(Icons.settings),
                      onTap: () {},
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(
                        'About',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      trailing: Icon(Icons.help),
                      onTap: () {},
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      trailing: Icon(Icons.logout),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: PlacePicker(
        apiKey: apiKey, // Put YOUR OWN KEY here.
        onPlacePicked: (result) {
          print(result.geometry.location);
          setState(() {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SendEmergency(users: widget.users, result: result);
            }));
          });
        },
        initialPosition: LatLng(-1.23, 3.45),
        useCurrentLocation: true,
      ),
    );
  }
}
