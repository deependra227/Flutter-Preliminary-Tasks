import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServices {

  bool isLoggedIn() {
    if(FirebaseAuth.instance.currentUser() != null) {
      return true;
    }
    return false;
  }

  Future<void> addData(userPreferences) async {
    if(isLoggedIn()) {
      Firestore.instance.collection('testPreferences')
      .add(userPreferences)
      .catchError((e) {
        print("my_debug: $e");
      });
    }
    else {
      print('user is not logged in');
    }
  }


  getDataFromCollection(collection) async {
    QuerySnapshot qs = await Firestore.instance
      .collection(collection)
      .getDocuments()
      .catchError((e) {
        print("e #9: $e");
      });

    if(qs != null) {
      return qs;
    }
  }

  getDocFromCollection(collection, email, x) async {
    QuerySnapshot qs = await Firestore.instance
      .collection(collection)
      .where(email, isEqualTo: x)
      .limit(1)
      .getDocuments()
      .catchError((e) {
        print("e #15: $e");
      });

    if(qs != null) {
      final DocumentSnapshot doc = qs.documents[0];
      return doc;
    }
    else {
      return null;
    }
  }

  getUser() async {
    FirebaseUser user = await FirebaseAuth.instance
      .currentUser()
      .catchError((e) {
        print("e #10: $e");
      });

    if(user != null) {
      print("db #6: ${user.uid}");
      return user;
    }
  }
}