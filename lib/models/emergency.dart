import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';

class Emergency {
  String id = "";
  String type = "";
  String description = "";
  String address = "";
  String damage = "";
  String patientID = "";
  String photo = "";
  double latitude = 0;
  double longittude = 0;
  String resolved = "";

  Emergency() {
    loadInfos();
  }

  void fromData(Map<String, dynamic> data) {
    this.id = data['id'];
    this.type = data['type'];
    this.description = data['description'];
    this.address = data['address'];
    this.damage = data['damage'];
    this.patientID = data['patientID'];
    this.photo = data['photo'];
    this.latitude = data['latitude'];
    this.longittude = data['longittude'];
    this.resolved = data['resolved'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'address': address,
      'damage': damage,
      'patientID': patientID,
      'photo': photo,
      'latitude': latitude,
      'longittude': longittude,
      'resolved': resolved,
    };
  }

  Future<Emergency> loadInfos() async {
    auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
    auth.User userConnected;
    userConnected = await _auth.currentUser;

    this.id = "";
    this.type = "";
    this.description = "";
    this.address = "";
    this.damage = "";
    this.patientID = userConnected.uid;
    this.photo = "";
    this.latitude = 0;
    this.longittude = 0;
    this.resolved = "NO";

    try {
      var userData = await FirebaseFirestore.instance
          .collection("Emergencies")
          .doc(this.id)
          .get();
      fromData(userData.data());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        print(e.message);
      }
      print(e.toString());
    }
    return this;
  }
}
