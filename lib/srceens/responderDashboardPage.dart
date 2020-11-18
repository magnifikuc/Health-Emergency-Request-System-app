import 'package:flutter/material.dart';
import 'package:emergency/models/responder.dart';
import 'package:emergency/models/user.dart';
import 'package:emergency/srceens/Widget/userDrawer.dart';
import 'package:emergency/srceens/responderHomePage.dart';
import 'package:emergency/srceens/services.dart';
import 'package:emergency/srceens/userGPSPage.dart';
import 'package:emergency/srceens/userHomePage.dart';
import 'package:emergency/srceens/userProfilePage.dart';
import 'package:emergency/srceens/userRemoveAccountPage.dart';

import 'Widget/responderDrawer.dart';

class ResponderDashboardPage extends StatefulWidget {
  @override
  _ResponderDashboardPageState createState() => _ResponderDashboardPageState();
}

class _ResponderDashboardPageState extends State<ResponderDashboardPage> {
  int index = 0;

  // User user = User();
  Responder responder;

  List<Widget> list = [
    ResponderHomePage(),
    // UserProfilePage(User()),
    UserServicesPage(),
    UserGPSPage(),
    UserRemoveAccountPage()
  ];

  @override
  void initState() {
    // TODO: implement initState
    responder = new Responder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Responder Dashboard'),
        ),
        body: list[index],
        drawer: ResponderDrawer(
          responder: responder,
          onTap: (ctx, i) {
            setState(() {
              index = i;
              Navigator.pop(ctx);
            });
          },
        ));
  }
}
