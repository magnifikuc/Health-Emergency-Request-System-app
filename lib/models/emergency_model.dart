import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

//Emergency class
import 'package:emergency/models/emergency.dart';
import 'package:flutter/cupertino.dart';

class Emergency {
  Map<String, dynamic> _emmergency = {};
  auth.User _user = auth.FirebaseAuth.instance.currentUser;
  final _store = FirebaseFirestore.instance.collection('Emergency');

  // Constructor

  //setDatas
  void initializeData(Map map) {
    _emmergency.addAll(map);
  }

  //get Datas
  Map getDatas() {
    return _emmergency;
  }

  //send datas to firestore
  Future addDatas() async {
    if (_emmergency.isNotEmpty) {
      //sending datas using firestore
      try {
        final new_emergency = await _store.add(_emmergency);
        return true;
      } catch (e) {
        return e.message;
      }
    } else {
      return "empty datas";
    }
  }

  //retrieve all emergencies of a user
  Future getPatientEmergency() async {
    try {
      var emergencies_list =
          await _store.where('patiendID', isEqualTo: _user.uid).get();

      if (emergencies_list.docs.isNotEmpty) {
        return emergencies_list.docs
            .map((snapshot) => (snapshot.data()))
            .toList();
      }
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.message;
    }
  }

  //Retrieve all emergencies unresponded
  Future getEmergenciesUnsolved() async {
    try {
      Map data;
      var emergencies_list =
          await _store.where('resolved', isEqualTo: false).get();

      if (emergencies_list.docs.isNotEmpty) {
        return emergencies_list.docs
            .map((snapshot) => data.addAll(snapshot.data()))
            .toList();
      }
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  //delete an emergency
  Future deleteEmergency(String id) async {
    try {
      await _store.doc(id).delete();
    } catch (e) {
      return e.toString();
    }
  }

  //update an emergency
  Future updateEmergency(Map map, String emergency_id) async {
    try {
      await _store.doc(emergency_id).update(map);
    } catch (e) {
      return e.toString();
    }
  }
}
