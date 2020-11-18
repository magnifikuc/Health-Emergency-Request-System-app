import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

//User Class

class User {
  Map<String, dynamic> _user_datas = {};
  auth.User _user = auth.FirebaseAuth.instance.currentUser;
  final _auth = auth.FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance.collection('Users_infos');

  // Constructor
  void setData(Map<String, dynamic> map) {
    _user_datas.addAll(map);
    print(_user_datas);
  }

  //get Datas
  Map getDatas() {
    return _user_datas;
  }

  //send datas to firestore
  Future userRegistration() async {
    if (_user_datas.isNotEmpty) {
      //sending datas using firestore
      try {
        await _store.add(_user_datas);
        return true;
      } catch (e) {
        return e.message;
      }
    } else {
      return false;
    }
  }

  Future userRegistrationCredential(Map map) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: map['email'], password: map['password']);
      return true;
    } catch (e) {
      return e.message;
    }
  }

  Future userSignInCredential(Map map) async {
    try {
      print(map);
      await _auth.signInWithEmailAndPassword(
          email: map['email'], password: map['password']);
      return true;
    } catch (e) {
      print(e.code);
      return e.message;
    }
  }

  //retrieve all emergencies of a user
  Future getUserData() async {
    try {
      var users = await _store.where('uid', isEqualTo: _user.uid).get();
      print(users);
      if (users.docs.isNotEmpty) {
        return users.docs
            .map((snapshot) => ([snapshot.data(), snapshot.id]))
            .toList()[0];
      }
      return "no datas";
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.message;
    }
  }

  //delete user
  Future deleteUser() async {
    try {
      await _store.doc(_user.uid).delete();
      return true;
    } catch (e) {
      return e.message;
    }
  }

  //update user infos
  Future updateUser(Map map, String id) async {
    try {
      try {
        await _user.updateEmail(map['email']);
        await _user.updatePassword(map['password']);
      } catch (e) {
        print("gg");
        if (e.code == 'requires-recent-login') {
          return 'login';
        }
        return e.message;
      }
      await _store.doc(id).update(map);
      return true;
    } catch (e) {
      return e.message;
    }
  }

// get UserLocation
  Future getLocation() async {
    try {
      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return {
        'succeed': true,
        'lat': position.latitude,
        'lng': position.longitude
      };
    } catch (e) {
      return {'succeed': false, 'error': e.message};
    }
  }
}
