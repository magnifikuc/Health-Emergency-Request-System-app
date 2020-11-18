import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:emergency/models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geocoding/geocoding.dart';

class SelectResponderPage extends StatefulWidget {
  SelectResponderPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  __SelectResponderPageStateState createState() =>
      __SelectResponderPageStateState();
}

class __SelectResponderPageStateState extends State<SelectResponderPage> {
  User _user = new User();

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'R',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'eal ',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'Emergency',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Responder'),
      ),
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

  String _emergencySelected;
  String _humanDamages;

  static const menuItems = <String>[
    "Emergency 1",
    "Emergency 2",
    "Emergency 3",
    "Emergency 4",
    "Emergency 5",
    "Emergency 6",
    "Emergency 7",
    "Emergency 8",
    "Emergency 9",
    "Emergency 10",
  ];

  static const menuItems2 = <String>[
    "1 Person",
    "2 Persons",
    "3 Persons",
    "4 Persons",
    "5 Persons",
    "6 Persons",
    "7 Persons",
    "8 Persons",
    "9 Persons",
    "10 Persons",
  ];

  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
      .map(
        (String values) => DropdownMenuItem<String>(
          value: values,
          child: Text(
            values,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
        ),
      )
      .toList();

  final List<DropdownMenuItem<String>> _dropDownMenuItems2 = menuItems2
      .map(
        (String values) => DropdownMenuItem<String>(
          value: values,
          child: Text(
            values,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
        ),
      )
      .toList();

  final _controller = TextEditingController();

  String _emergencyDescription;

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

  int numItems = 20;

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
                "Atangana Ngono Paul Josef $index",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
              Text(
                "Distance : 130 km",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Time : 2h30 ",
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
