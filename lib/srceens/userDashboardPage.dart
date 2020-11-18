import 'package:flutter/material.dart';
import 'package:emergency/models/user.dart';
import 'package:emergency/srceens/Widget/userDrawer.dart';
import 'package:emergency/srceens/services.dart';
import 'package:emergency/srceens/userGPSPage.dart';
import 'package:emergency/srceens/userHomePage.dart';
import 'package:emergency/srceens/userProfilePage.dart';
import 'package:emergency/srceens/userRemoveAccountPage.dart';
import 'package:geocoding/geocoding.dart';

class UserDashboardPage extends StatefulWidget {
  @override
  _UserDashboardPageState createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  int index = 0;

  User user;

  List<Widget> list = [
    UserHomePage(),
    // UserProfilePage(User()),
    UserServicesPage(),
    UserGPSPage(),
    UserRemoveAccountPage()
  ];

  @override
  void initState() {
    // TODO: implement initState
    user = new User();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Patient Dashboard'),
        ),
        body: list[index],
        drawer: UserDrawer(
          user: user,
          onTap: (ctx, i) {
            setState(() {
              index = i;
              Navigator.pop(ctx);
            });
          },
        ));
  }
}
