import 'dart:ui';

import 'package:emergency/srceens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:emergency/srceens/signupMenuPage.dart';

class WelcomePage extends StatefulWidget {
  static String id = 'welcome_screen';

  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Login.id);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffdf8e33).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Color(0xfff7892b)),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SinUpMenuPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Hero(
          tag: 'trans',
          child: Text(
            'Register now',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: CircleAvatar(
                  child: Image.asset('images/nurse_male_480px.png'),
                  backgroundColor: Colors.orange,
                  radius: 50.0,
                ),
              ),
              SizedBox(
                height: 18.0,
              ),
              Text(
                'HEALTH EMERGENCY REQUEST SYSTEM',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              _submitButton(),
              SizedBox(
                height: 20,
              ),
              _signUpButton(),
              SizedBox(
                height: 30,
              ),
              Text(
                'Welcome to your Health Emergency Request System',
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontFamily: "Arial",
                ),
                textAlign: TextAlign.center,
              ),
              Flexible(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Copyright \u00a9 ${DateTime.now().year} Godswill',
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontFamily: "Arial",
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
