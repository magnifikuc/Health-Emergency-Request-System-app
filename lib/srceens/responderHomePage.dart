import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:emergency/models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geocoding/geocoding.dart';

class ResponderHomePage extends StatefulWidget {
  ResponderHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  __ResponderHomePageStateState createState() =>
      __ResponderHomePageStateState();
}

class __ResponderHomePageStateState extends State<ResponderHomePage> {
  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'HEALTH',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'EMERGENCY ',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'REQUEST SYSTEM',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView.builder(
        itemCount: numItems,
        padding: EdgeInsets.all(16),
        itemBuilder: (BuildContext context, int i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2 + 1;
          return _buildRow(index);
        },
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

  int numItems = 10;

  Widget _buildRow(int index) {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            child: Text(
              "$index",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
            ),
          ),
          Column(
            children: [
              Text(
                "Aizeimer",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
              Text(
                "Distance : $index km",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Time : 30min ",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          FlatButton(
            child: Icon(
              Icons.phone,
              color: Color(0xffff892b),
            ),
          ),

          /*ListTile(
              leading: CircleAvatar(
                child: Text(
                    "$index"
                ),
              ),
              title: Text(
                "Item $index",
                style: TextStyle(fontSize: 14),
              ),
              trailing: FlatButton(
                child: Icon(Icons.phone),
              ),
            )*/
        ],
      ),
    ));
  }
}
