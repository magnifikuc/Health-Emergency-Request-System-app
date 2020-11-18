import 'package:emergency/srceens/edit_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:emergency/constants.dart';
import 'show_location_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login_screen.dart';

final _firestore = FirebaseFirestore.instance.collection('Emergency');

auth.User loggedInUser;
Map others;

class Responder extends StatefulWidget {
  final Map users;
  bool send = false;
  Responder({this.users, this.send});

  static String id = "responder_screen";
  @override
  _ResponderState createState() => _ResponderState();
}

class _ResponderState extends State<Responder> {
  bool verif;
  final _auth = auth.FirebaseAuth.instance;
  String profileName = "";
  String uidClass = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SnackBar _snackbar;
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  var postUrl = "fcm.googleapis.com/fcm/send";

  void getCurrentUser() async {
    profileName = '${widget.users['firstName']} ${widget.users['lastName']}';
  }

  static Future<String> getToken(userId) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    var token;
    var a = await _db
        .collection('Users_infos')
        .where('uid', isEqualTo: userId)
        .get();

    if (a.docs.isNotEmpty) {
      var b = a.docs
          .map((snapshot) => ([snapshot.data(), snapshot.id]))
          .toList()[0];
      print(b);
    }

    return token;
  }

  Future<void> sendNotification(receiver, msg) async {
    var token = await getToken(receiver);
    print('token : $token');

    final data = {
      "notification": {
        "body": "Accept Ride Request",
        "title": "This is Ride Request"
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": "$token"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAYcIksVw:APA91bFmzdoKZC_4cRsf3le0JlIy-zVWRxsfbkTIqvYaG-b5aU8vlKs43Rt5fghohC4evH7I7_a8PvMeqE2ygvQi3g4bCCcc0xTu1ExH1_PhcD5fOJtL5kV0LRWjv6HEdbgzml4GtttN'
    };

    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );

    try {
      final response = await Dio(options).post(postUrl, data: data);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Request Sent To Driver');
      } else {
        print('notification sending failed');
        // on failure do sth
      }
    } catch (e) {
      print('exception $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('onMessage called: $message');
        return;
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume called: $message');
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch called: $message');
        return;
      },
    );

    // getList();
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
              onPressed: () async {
                await _auth.signOut();
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
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Responder(users: widget.users);
                        }));
                      },
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
                    child: ExpansionTile(
                      title: Text(
                        "Services",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(2.5),
                          child: Column(
                            children: [
                              Card(
                                child: ListTile(
                                  title: Text(
                                    'Inform hospital',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  trailing: Icon(Icons.local_hospital_outlined),
                                  onTap: () {},
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  title: Text(
                                    'Call an ambulance',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  trailing: Icon(Icons.call),
                                  onTap: () {
                                    final phoneCall =
                                        FlutterPhoneState.startPhoneCall(
                                            "480-555-1234");
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                      expandedAlignment: Alignment.topLeft,
                      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
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
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Login();
                        }));
                      },
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
    );
    return scal;
  }
}

class EmergenciesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .where('responded', isEqualTo: false)
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
            'Emergencies waiting',
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
                : 'Someone needs your help';
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
                    onSelected: (result) {
                      if (result == 'respond') {
                        _ResponderState.getToken(emer.data()['patientID']);
                        print(emer.data()['patientID']);
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "Emergency Response",
                          desc:
                              "Are You sure you want to respond to this emergency ?",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "CANCEL",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              color: Colors.red.shade500,
                            ),
                            DialogButton(
                              child: Text(
                                "YES",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                print("${emer.data()['damage']}");

                                //Responding
                                print(emer.id);
                                var conf;

                                try {
                                  _firestore.doc(emer.id).delete();

                                  Alert(
                                    context: context,
                                    type: AlertType.success,
                                    title: "Successfully responded",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "COOL",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        width: 120,
                                      )
                                    ],
                                  ).show();
                                } catch (e) {
                                  Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: "Failed",
                                    desc: e.message,
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        width: 120,
                                      )
                                    ],
                                  ).show();
                                }
                              },
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(116, 116, 191, 1.0),
                                Color.fromRGBO(52, 138, 199, 1.0)
                              ]),
                            )
                          ],
                        ).show();
                      } else if (result == 'location') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ShowLocation(points: {
                            'lat': emer.data()['lat'],
                            'lng': emer.data()['lng']
                          });
                        }));
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem(
                          value: 'respond',
                          child: Text('Respond'),
                        ),
                        const PopupMenuItem(
                          value: 'location',
                          child: Text('See the location'),
                        ),
                      ];
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
