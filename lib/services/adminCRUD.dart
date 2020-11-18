import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorCRUD {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(Map<String, dynamic> UserData) async {
    if (isLoggedIn()) {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        CollectionReference reference =
            FirebaseFirestore.instance.collection('Admins');
        reference.doc(UserData['id']).set(UserData);
      });
    } else {
      print('you need to be logged in');
    }
  }

  Future<Stream> getData() async {
    return await FirebaseFirestore.instance.collection('Admins').snapshots();
  }

  updateData(String selectedDocument, Map<String, dynamic> newValues) async {
    FirebaseFirestore.instance
        .collection('Admins')
        .doc(selectedDocument)
        .update(newValues)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(String documentID) async {
    Firestore.instance
        .collection('Admins')
        .doc(documentID)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
