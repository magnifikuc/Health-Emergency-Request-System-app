import 'package:emergency/srceens/choose_location.dart';
import 'package:emergency/srceens/edit_user_screen.dart';
import 'package:emergency/srceens/patient_emergencies_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency/constants.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'login_screen.dart';

final _firestore = FirebaseFirestore.instance.collection('Emergency');

auth.User loggedInUser;
Map others;

class Patient extends StatefulWidget {
  final Map users;
  bool send = false;
  Patient({this.users, this.send});

  static String id = "patient_screen";
  @override
  _PatientState createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  bool verif;
  final _auth = auth.FirebaseAuth.instance;
  String profileName = "";
  String uidClass = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SnackBar _snackbar;

  void getCurrentUser() async {
    profileName = '${widget.users['firstName']} ${widget.users['lastName']}';
  }

  void showSnack(
      {Color color = kColorLoading,
      String message = "Your emergency has been sent"}) {
    _snackbar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: color,
    );
    _scaffoldKey.currentState.showSnackBar(_snackbar);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    // getList();
  }

  // retrieve all emergencies

  @override
  Widget build(BuildContext context) {
    var scal = Scaffold(
      key: _scaffoldKey,
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Login();
                }));

                // messagesStream();
              }),
        ],
        title: Text('Welcome  ${widget.users['firstName']}'),
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
                        'Home',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      trailing: Icon(Icons.home),
                      onTap: () {},
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(
                        'Edit my profile',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      trailing: Icon(Icons.settings),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EditUserprofile(users: widget.users);
                        }));
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(
                        'My emergencies list',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      trailing: Icon(Icons.logout),
                      onTap: () {
                        print('passed');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return PatientEmergencies(users: widget.users, send: false);
                            }));
                      },
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
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    widget.send ? Text('Message sent') : Text(''),
                    GestureDetector(
                      child: CircleAvatar(
                        child: Image.asset('images/alert_480px.png'),
                        backgroundColor: Colors.white,
                        radius: 50.0,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Location(users: widget.users);
                        }));
                      },
                    ),
                    Text(
                      'Send an emergency',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    GestureDetector(
                      child: CircleAvatar(
                        child: Image.asset('images/medical_bag_480px.png'),
                        backgroundColor: Colors.white,
                        radius: 50.0,
                      ),
                      onTap: () {
                        MapsLauncher.launchQuery('Pharmacies');
                      },
                    ),
                    Text(
                      'Pharmacies',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    GestureDetector(
                      child: CircleAvatar(
                        child: Image.asset('images/clinic_208px.png'),
                        backgroundColor: Colors.white,
                        radius: 50.0,
                      ),
                      onTap: () {
                        MapsLauncher.launchQuery('Hospital');
                      },
                    ),
                    Text(
                      'Hospital',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Location(users: widget.users);
          }));
        },
        child: Image.asset('images/alert_96px.png'),
        backgroundColor: Color(0xffe46b10),
      ),
    );
    return scal;
  }
}
