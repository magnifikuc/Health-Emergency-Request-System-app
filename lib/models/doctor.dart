import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';

class Doctor {
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
  String licenceNumber = "";
  String certificate = "";
  String referees = "";
  String photo = "";
  String statut = "Doctor";
  String latitude = "";
  String longittude = "";

  Doctor() {
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
    this.licenceNumber = data['licenceNumber'];
    this.certificate = data['certificate'];
    this.referees = data['referees'];
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
      'licenceNumber': licenceNumber,
      'certificate': certificate,
      'referees': referees,
      'photo': photo,
      'statut': statut,
      'latitude': latitude,
      'longittude': longittude,
    };
  }

  Future<Doctor> loadInfos() async {
    auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
    auth.User responderConnected;
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
    this.licenceNumber = "";
    this.certificate = "";
    this.referees = "";
    this.photo = responderConnected.photoUrl;
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
