import 'package:emergency/srceens/choose_location.dart';
import 'package:emergency/srceens/edit_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

final _firestore = FirebaseFirestore.instance.collection('Emergency');

auth.User loggedInUser;
Map others;

class PatientEmergencies extends StatefulWidget {
  final Map users;
  bool send = false;
  PatientEmergencies({this.users, this.send});

  @override
  _PatientEmergenciesState createState() => _PatientEmergenciesState();
}

class _PatientEmergenciesState extends State<PatientEmergencies> {
  bool verif;
  final _auth = auth.FirebaseAuth.instance;
  String profileName = "";
  String uidClass = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SnackBar _snackbar;

  void getCurrentUser() async {
    profileName = '${widget.users['firstName']} ${widget.users['lastName']}';
  }

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
                        'Edit profile',
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
                      height: 40.0,
                    ),
                  ],
                ),
              ),
              EmergenciesStream(),
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

class EmergenciesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .where('patiendID',
              isEqualTo: auth.FirebaseAuth.instance.currentUser.uid)
          .orderBy(
            'date_sending',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final emergencies = snapshot.data.docs;
        List<Widget> F = [
          Text(
            'Your emergencies list',
            style: TextStyle(
              fontSize: 20.0,
              color: Color(0xfff56942),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 4.0,
          )
        ];

        if (emergencies.length == 0) {
          F.add(
            Text(
              'Empty list',
              style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xfff56942),
                  fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          for (var emer in emergencies) {
            var response = "";
            if (!emer.data()['responded']) {
              response = 'Not yet';
            }

            var message = emer.data()['responded'] == true
                ? 'Someone has already picked your request'
                : 'Emergency request not yet responded';
            // message += ' Sent on: ${emer.data()['date_response']}';

            var icon = emer.data()['responded'] == true
                ? Image.asset('images/ok_480px.png')
                : Image.asset('images/wait_480px.png');

            var val;
            F.add(
              Card(
                child: ListTile(
                  leading: icon,
                  title: Text(
                      '${emer.data()['damage']} at ${emer.data()['address']}'),
                  subtitle: Text('$message'),
                  trailing: PopupMenuButton<String>(
                    onSelected: val,
                    itemBuilder: (BuildContext context) {
                      return {'Edit', 'Delete'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                  isThreeLine: true,
                ),
              ),
            );
          }
        }

        return Column(
          children: F,
        );
      },
    );
  }
}

void handleClick(String value) {
  switch (value) {
    case 'Logout':
      break;
    case 'Settings':
      break;
  }
}
