import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';

class User {
  String id = "";
  String fullName = "";
  String dateOfBirth = "";
  String address = "";
  String gender = "";
  String phoneNumber = "";
  String healthIssues = "";
  String passport = "";
  String idCard = "";
  String email = "";
  String photo = "";
  String statut = "Patient";
  String latitude = "";
  String longittude = "";

  User() {
    loadInfos();
  }

  void fromData(Map<String, dynamic> data) {
    this.id = data['id'];
    this.fullName = data['fullName'];
    this.dateOfBirth = data['dateOfBirth'];
    this.address = data['address'];
    this.gender = data['gender'];
    this.phoneNumber = data['phoneNumber'];
    this.healthIssues = data['healthIssues'];
    this.passport = data['passport'];
    this.idCard = data['idCard'];
    this.email = data['email'];
    this.photo = data['photo'];
    this.statut = data['statut'];
    this.latitude = data['latitude'];
    this.longittude = data['longittude'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'healthIssues': healthIssues,
      'passport': passport,
      'idCard': idCard,
      'email': email,
      'photo': photo,
      'statut': statut,
      'latitude': latitude,
      'longittude': longittude,
    };
  }

  Future<User> loadInfos() async {
    auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
    auth.User userConnected;
    userConnected = await _auth.currentUser;

    this.id = userConnected.uid;
    this.fullName = userConnected.displayName;
    this.dateOfBirth = "";
    this.address = "";
    this.gender = "";
    this.phoneNumber = "";
    this.healthIssues = "";
    this.passport = "";
    this.idCard = "";
    this.email = userConnected.email;
    this.photo = userConnected.photoURL;
    this.latitude = "";
    this.longittude = "";

    try {
      var userData = await FirebaseFirestore.instance
          .collection("Users")
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
