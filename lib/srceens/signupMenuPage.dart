import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:emergency/components/rounded_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'login_screen.dart';

class SinUpMenuPage extends StatefulWidget {
  static String id = 'signup_screen';
  final title;
  SinUpMenuPage({Key key, this.title}) : super(key: key);

  @override
  __SinUpMenuPageStateState createState() => __SinUpMenuPageStateState();
}

class __SinUpMenuPageStateState extends State<SinUpMenuPage> {
  bool showSpinner = false;
  String statut = "Responder";
  double latitude = 0;
  double longitude = 0;
  String firstName;
  String lastName;
  String email;
  String password;
  String confirmPassword;
  String my_token;
  final _formKey = GlobalKey<FormState>();
  var credent;

  // final String title;
  final inputController = TextEditingController();
  final _auth = auth.FirebaseAuth.instance;
  final _authFirestore = FirebaseFirestore.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  //snackBar
  SnackBar _snackbar;

  void initState() {
    // TODO: implement initState
    super.initState();

    firebaseMessaging.getToken().then((token) {
      setState(() {
        my_token = token;
      });
      print('FCM Token: $token');
    });
    // getList();
  }

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

  void showSnack(
      {Color color = const Color(0xff366b41),
      String message = "Registration in progress"}) {
    _scaffoldKey.currentState.removeCurrentSnackBar();

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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'trans',
                    child: _title(),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              firstName = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Cannot be empty';
                              }
                              return null;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'First Name',
                            )),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            lastName = value;
                          },
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Last Name',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Email',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Cannot be empty';
                            } else if (!EmailValidator.validate(email)) {
                              return 'wrong email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          obscureText: true,
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Password',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Cannot be empty';
                            }
                            if (value.length < 6) {
                              return 'password must be at least 6 caracter';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          obscureText: true,
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            confirmPassword = value;
                          },
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Confirm your password',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Cannot be empty';
                            } else if (password != confirmPassword) {
                              return 'passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Radio(
                              value: "Responder",
                              groupValue: statut,
                              onChanged: (value) {
                                setState(() {
                                  statut = value;
                                });
                              },
                            ),
                            Text(
                              'Responder',
                              style: kRadioTextStyle,
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Radio(
                                value: "Patient",
                                groupValue: statut,
                                onChanged: (value) {
                                  setState(() {
                                    statut = value;
                                  });
                                }),
                            Text(
                              'Patient',
                              style: kRadioTextStyle,
                            ),
                          ],
                        ),
                        RoundedButton(
                            color: Color(0xffe46b10),
                            title: 'Register',
                            onPressed: () async {
                              //Form Validation
                              if (_formKey.currentState.validate()) {
                                // showSpinner = true;
                                showSnack();

                                User user = User();
                                var loc = await user.getLocation();

                                if (loc is String) {
                                  showSnack(
                                      color: Color(0xffb85132), message: loc);
                                } else {
                                  var reg =
                                      await user.userRegistrationCredential({
                                    'email': email,
                                    'password': password,
                                  });

                                  //Registering with credentials
                                  if (reg is String) {
                                    showSnack(
                                        color: Color(0xffb85132), message: reg);
                                  } else {
                                    // await user.userSignInCredential(
                                    //     {'email': email, 'password': password});

                                    var map = {
                                      'date_registration': DateTime.now(),
                                      'date_update': DateTime.now(),
                                      'uid': _auth.currentUser.uid,
                                      'firstName': firstName,
                                      'lastName': lastName,
                                      'email': email,
                                      'password': password,
                                      'statut': statut,
                                      'latitude': loc['lat'],
                                      'longitude': loc['lng'],
                                      'token': my_token,
                                    };
                                    user.setData(map);

                                    var finalReg =
                                        await user.userRegistration();

                                    if (finalReg is String) {
                                      showSnack(
                                          color: Color(0xffb85132),
                                          message: finalReg.toString());
                                    } else {
                                      // statut == 'Responder'
                                      //     ? Navigator.push(context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) {
                                      //         return Responder(
                                      //           users: map,
                                      //           send: false,
                                      //         );
                                      //       }))
                                      //     : Navigator.push(context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) {
                                      //         return Patient(
                                      //             users: map, send: false);
                                      //       }));

                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Login();
                                      }));

                                      setState(() {
                                        showSpinner = false;
                                      });
                                    }
                                  }
                                }
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
