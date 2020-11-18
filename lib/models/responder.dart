import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class Responder {
  String id = "";
  String fullName = "";
  String DoB = "";
  String address = "";
  String gender = "";
  String phoneNumber = "";
  String category = "";
  String passport = "";
  String idCard = "";
  String email = "";
  String photo = "";
  String statut = "Responder";
  String latitude = "";
  String longittude = "";

  Responder() {
    loadInfos();
  }

  void fromData(Map<String, dynamic> data) {
    this.id = data['id'];
    this.fullName = data['fullName'];
    this.DoB = data['DoB'];
    this.address = data['address'];
    this.gender = data['gender'];
    this.phoneNumber = data['phoneNumber'];
    this.category = data['category'];
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
      'DoB': DoB,
      'address': address,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'category': category,
      'passport': passport,
      'idCard': idCard,
      'email': email,
      'photo': photo,
      'statut': statut,
      'latitude': latitude,
      'longittude': longittude,
    };
  }

  Future<Responder> loadInfos() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser responderConnected;
    responderConnected = await _auth.currentUser;

    this.id = responderConnected.uid;
    this.fullName = responderConnected.displayName;
    this.DoB = "";
    this.address = "";
    this.gender = "";
    this.phoneNumber = "";
    this.category = "";
    this.passport = "";
    this.idCard = "";
    this.email = responderConnected.email;
    this.photo = "";
    this.latitude = "";
    this.longittude = "";

    try {
      var userData = await FirebaseFirestore.instance
          .collection("Responders")
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
