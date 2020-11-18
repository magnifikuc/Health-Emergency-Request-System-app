import 'package:emergency/srceens/login_screen.dart';
import 'package:emergency/srceens/patient_screen.dart';
import 'package:emergency/srceens/patient_screen.dart';
import 'package:emergency/srceens/userSignupPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'srceens/welcomePage.dart';
import 'srceens/signupMenuPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is  the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Emergency app',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomePage.id,
      routes: {
        WelcomePage.id: (context) => WelcomePage(),
        SinUpMenuPage.id: (context) => SinUpMenuPage(),
        Patient.id: (context) => Patient(),
        Login.id: (context) => Login(),
      },
    );
  }
}
