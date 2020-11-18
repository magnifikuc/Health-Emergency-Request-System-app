import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:emergency/models/emergency.dart';
import 'package:emergency/models/user.dart';
import 'package:emergency/srceens/Widget/customContainer.dart';
import 'package:emergency/srceens/selectResponserPage.dart';
import 'package:emergency/srceens/userDashboardPage.dart';
import 'package:google_fonts/google_fonts.dart';

class EmergencyPage extends StatefulWidget {
  EmergencyPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  __EmergencyPageStateState createState() => __EmergencyPageStateState();
}

class __EmergencyPageStateState extends State<EmergencyPage> {
  User _user = new User();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

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
              text: ' EMERGENCY ',
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
      appBar: AppBar(
        title: Text('Emergency description'),
      ),
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .25,
              right: -MediaQuery.of(context).size.width * .2,
              child: CustomContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Choose the type of emergency',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2)
                          ],
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xfffbb44f), Color(0xffffffff)])),
                      child: ListTile(
                        trailing: DropdownButton(
                          value: _emergencySelected,
                          hint: Text('Choose'),
                          onChanged: (String newValue) {
                            setState(() {
                              _emergencySelected = newValue;
                            });
                          },
                          items: _dropDownMenuItems,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2)
                          ],
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xfffbb44f), Color(0xffffffff)])),
                      child: TextField(
                        controller: this._controller,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          //counterText: '${this._controller.text.split(' ').length} words',
                          labelText: 'Enter the description of your emergency',
                          hintText: 'Describe your emergency here',
                          //border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                          _emergencyDescription = text;
                        },
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'How many human damages ?',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                    ListTile(
                      trailing: DropdownButton(
                        value: _humanDamages,
                        hint: Text('Choose'),
                        onChanged: (String newValue) {
                          setState(() {
                            _humanDamages = newValue;
                          });
                        },
                        items: _dropDownMenuItems2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: Offset(2, 4),
                                    blurRadius: 5,
                                    spreadRadius: 2)
                              ],
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xfffbb448),
                                    Color(0xfff7892b)
                                  ])),
                          child: InkWell(
                            child: Text(
                              'Back',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            onTap: () {
                              //Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UserDashboardPage()));
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: Offset(2, 4),
                                    blurRadius: 5,
                                    spreadRadius: 2)
                              ],
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xfffbb448),
                                    Color(0xfff7892b)
                                  ])),
                          child: InkWell(
                            child: Text(
                              'Next',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            onTap: () {
                              _getCurrentLocation();
                              sendRequest();
                              MapsLauncher.launchCoordinates(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                  'Google Headquarters are here');
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SelectResponderPage()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }

  String _emergencySelected;
  String _humanDamages;

  static const menuItems = <String>[
    "Asthma",
    "Diabetes",
    "Aizheimer",
    "Hypertension",
    "Epilepsy",
    "Bronchitic",
    "Sickle Cell Disease",
    "Heart Attack",
    "Accident",
    "Fine Outbreak",
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

  _getCurrentLocation() {
    setState(() async {
      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _currentPosition = position;
    });
  }

  sendRequest() {
    Emergency emergency = new Emergency();
    emergency.type = _emergencySelected;
    emergency.description = _emergencyDescription;
    emergency.damage = _humanDamages;
    emergency.longittude = -_currentPosition.longitude;
    emergency.latitude = _currentPosition.latitude;
  }
}
