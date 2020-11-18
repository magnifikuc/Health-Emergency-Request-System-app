import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emergency/models/responder.dart';
import 'package:emergency/services/responderCRUD.dart';
import 'package:emergency/srceens/Widget/customContainer.dart';
import 'package:emergency/srceens/responderDashboardPage.dart';
import 'loginPage.dart';
import 'package:google_fonts/google_fonts.dart';

class ResponderSignUpPage extends StatefulWidget {
  ResponderSignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ResponderSignUpPageState createState() => _ResponderSignUpPageState();
}

class _ResponderSignUpPageState extends State<ResponderSignUpPage> {
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

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
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
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Full Name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  onSaved: (val) {
                                    _fullName = val;
                                  },
                                  validator: (val) {
                                    if (val.trim().isEmpty) {
                                      return 'Name can not be empty !';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Email',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  onSaved: (val) {
                                    _email = val;
                                  },
                                  validator: (val) {
                                    if (val.trim().isEmpty) {
                                      return 'Email can not be empty !';
                                    }
                                    if (!val.trim().contains('@')) {
                                      return 'Enter a correct email !';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Password',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  onSaved: (val) {
                                    _pass = val;
                                  },
                                  validator: (val) {
                                    _pass = val;
                                    if (val.trim().isEmpty) {
                                      return 'Password can not be empty !';
                                    }
                                    if (val.trim().length < 6) {
                                      return 'Password is too short !';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Repeat Password',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  onSaved: (val) {
                                    _repPass = val;
                                  },
                                  validator: (val) {
                                    if (val.trim().isEmpty) {
                                      return 'Repeat Password can not be empty !';
                                    }
                                    if (_pass != val) {
                                      return 'Passwords should match !';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          if (_isBusy) CircularProgressIndicator(),
                          if (!_isBusy)
                            Container(
                              width: MediaQuery.of(context).size.width,
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
                                  'Register',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                onTap: _submitForm,
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * .14),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }

  var _email = '';
  var _pass = '';
  var _repPass = '';
  var _fullName = '';

  Responder _responder = new Responder();
  ResponderCRUD responderCRUD = new ResponderCRUD();
  auth.User userConnected;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _isBusy = false;

  void _submitForm() async {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      _formKey.currentState.save();
      FocusScope.of(context).unfocus();
      setState(() {
        _isBusy = true;
      });

      _responder.fullName = _fullName;
      _responder.email = _email;

      auth.UserCredential authResult;
      try {
        authResult = await auth.FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _pass);

        userConnected = await auth.FirebaseAuth.instance.currentUser;

        _responder.id = userConnected.uid;
        _responder.fullName = _fullName;
        _responder.DoB = "";
        _responder.address = "";
        _responder.gender = "";
        _responder.phoneNumber = "";
        _responder.category = "";
        _responder.passport = "";
        _responder.idCard = "";
        _responder.email = _email;
        _responder.statut = "Responder";
        _responder.photo = "";
        _responder.latitude = "";
        _responder.longittude = "";

        responderCRUD.addData(_responder.toJson());

        _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text('Resgistered succefull ....')));

        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ResponderDashboardPage()));
      } on PlatformException catch (e) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(e.message)));
      } catch (ex) {
        print(ex);
      } finally {
        if (this.mounted) {
          setState(() {
            _isBusy = false;
          });
        }
      }
    }
  }
}
