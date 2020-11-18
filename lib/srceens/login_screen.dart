import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency/models/emergency_model.dart';
import 'package:emergency/models/user_model.dart';
import 'package:emergency/srceens/patient_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:emergency/components/rounded_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'responder_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

class Login extends StatefulWidget {
  static String id = 'login_screen';
  final title;
  Login({Key key, this.title}) : super(key: key);

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  bool showSpinner = false;
  double latitude = 0;
  double longitude = 0;
  String email;
  String password;
  String confirmPassword;
  final _formKey = GlobalKey<FormState>();

  // final String title;
  final inputController = TextEditingController();
  final _auth = auth.FirebaseAuth.instance;
  final _authFirestore = FirebaseFirestore.instance;
  String messageLogin = "";
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //snackBar
  SnackBar _snackbar;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void getLocation() async {
    try {
      LocationPermission permission = await requestPermission();

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position =
            await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });
      }
    } catch (e) {
      print(e);
    }
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showSpinner = false;
  }

  void showSnack(
      {Color color = const Color(0xff366b41),
      String message = "Login in progress"}) {
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '$messageLogin',
                          style: TextStyle(
                            color: Colors.red,
                            fontStyle: FontStyle.italic,
                            fontSize: 13.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10.0,
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
                            } else {
                              if (value.length < 6) {
                                return 'password must be at least 6 caracter';
                              }
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        RoundedButton(
                            color: Color(0xffe46b10),
                            title: 'Login',
                            onPressed: () async {
                              //Form Validation
                              if (_formKey.currentState.validate()) {
                                // showSpinner = true;
                                showSnack();
                                // User user = User();

                                var sign_in = await User().userSignInCredential(
                                    {'email': email, 'password': password});

                                if (sign_in is String) {
                                  showSnack(
                                      color: Color(0xffb85132),
                                      message: sign_in);
                                } else {
                                  print("passed");
                                  var datas = await User().getUserData();

                                  if (datas is String) {
                                    showSnack(
                                        color: Color(0xffb85132),
                                        message: datas);
                                  } else {
                                    print(datas[0]);
                                    Emergency em = Emergency();

                                    // var emergencies;
                                    // datas[0]['statut'] == 'Patient'
                                    //     ? emergencies =
                                    //         await em.getPatientEmergency()
                                    //     : emergencies =
                                    //         await em.getEmergenciesUnsolved();
                                    //print(emergencies);

                                    print(datas[0]['statut']);
                                    await datas[0]['statut'] == 'Patient'
                                        ? Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                            return Patient(
                                              users: datas[0],
                                              send: false,
                                            );
                                          }))
                                        : Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                            return Responder(
                                                users: datas[0], send: false);
                                          }));

                                    // if (emergencies is String) {
                                    //   print("error");
                                    //   showSnack(
                                    //       color: Color(0xffb85132),
                                    //       message: emergencies);
                                    // } else {
                                    //
                                    // }
                                  }
                                }
                              }
                            }),
                        Row(children: <Widget>[
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 15.0),
                                child: Divider(
                                  color: Color(0xffe46b10),
                                  height: 36,
                                )),
                          ),
                          Text(
                            "OR",
                            style: TextStyle(
                              color: Color(0xffe46b10),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 10.0),
                                child: Divider(
                                  color: Color(0xffe46b10),
                                  height: 36,
                                )),
                          ),
                        ]),
                        RaisedButton.icon(
                          padding: EdgeInsets.all(10.0),
                          onPressed: () async {
                            try {
                              await googleSignIn.disconnect();
                              GoogleSignInAccount googleSignInAccount =
                                  await googleSignIn.signIn();

                              print(googleSignInAccount.email);

                              final dbRef = await FirebaseDatabase.instance
                                  .reference()
                                  .child("User_infos");

                              var a = await dbRef
                                  .orderByChild("email")
                                  .equalTo(googleSignInAccount.email)
                                  .limitToFirst(1)
                                  .once()
                                  .then((value) {
                                print(value.value);
                              });

                              // GoogleSignInAuthentication
                              //     googleSignInAuthentication =
                              //     await googleSignInAccount.authentication;
                              //
                              // print(googleSignInAuthentication);

                              // auth.AuthCredential credential =
                              //     await auth.GoogleAuthProvider.credential(
                              //         accessToken: googleSignInAuthentication
                              //             .accessToken,
                              //         idToken:
                              //             googleSignInAuthentication.idToken);
                              print('passed');
                              //print(credential);
                            } catch (e) {
                              print(e.message);
                            }

                            if (_formKey.currentState.validate()) {
                              // showSpinner = true;
                              // showSnack(message: 'Sign in with google...');
                              // User user = User();
                              //
                              // var sign_in = await user.userSignInCredential(
                              //     {'email': email, 'password': password});

                            }
                          },
                          icon: Image.asset("images/google_20px.png"),
                          label: Text(
                            "Sign in with google",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15.0,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Color(0xffe46b10)),
                          ),
                          color: Colors.white,
                          disabledColor: Color(0xffe46b10),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
