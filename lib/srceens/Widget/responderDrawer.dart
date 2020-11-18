import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:emergency/models/responder.dart';
import 'package:emergency/models/user.dart';

class ResponderDrawer extends StatelessWidget {
  Responder responder = new Responder();
  final Function onTap;

  ResponderDrawer({
    this.responder,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Drawer(
        elevation: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              curve: Curves.easeInCirc,
              decoration: BoxDecoration(
                color: Color(0xfff79c4f),
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: CircleAvatar(
                        backgroundImage: responder.photo.startsWith("https", 0)
                            ? NetworkImage(responder.photo)
                            : AssetImage("assets/img1.jpg"),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      responder.fullName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      responder.email,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () => onTap(context, 0),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () => onTap(context, 1),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Services"),
              onTap: () => onTap(context, 2),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text("GPS"),
              onTap: () => onTap(context, 3),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("Remove account"),
              onTap: () => onTap(context, 4),
            ),
            ListTile(
                leading: Icon(Icons.all_out),
                title: Text("Log out"),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
