import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserManagement {

  storeNewGoogleUser(user, context) {
    Firestore.instance.collection('/users').document(user.uid.toString()).setData({
      'email' : user.email,
      'uid' : user.uid,
      'name' : user.displayName,
      'tags' :[]      
    }).then((value) {
      // Navigator.of(context).pushReplacementNamed('/homepage');

    }).catchError((e) {
      // TODO: handle this error properly
      print("my_debug: $e"); 
    });
  }

  signOut(context) {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context).pushReplacementNamed('/landingpage');
    }).catchError((e) {
      // TODO: handle this error properly
      print("my_debug: $e");
    });
  }

  isFirstGoogleLogin(signedInUser) async {
    final QuerySnapshot snapshot = await Firestore.instance
      .collection('users')
      .where('email', isEqualTo: signedInUser.email)
      .limit(1)
      .getDocuments()
      .catchError((e) {
        print("e #10: $e");
      });

    final List<DocumentSnapshot> documents = snapshot.documents;
    print("db #41: ${documents} ${documents.length}");
    final bool isFirstLogin = (documents.length == 0);
    print("db #42: $isFirstLogin");
    if(!isFirstLogin) {
      print("db #12: ${signedInUser.email} already exists");
    }

    return isFirstLogin;
  }

  void signInWithGoogle(context) async {
    final GoogleSignIn _googleSignIn = new GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("db #38: ${user.email}");
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();

    print("signed in as ${currentUser.displayName}");
    await UserManagement().isFirstGoogleLogin(currentUser)
    .then((isFirstLogin) {
      if(isFirstLogin == true) {
        print("db #40: Storing new user ${user.email}");
        UserManagement().storeNewGoogleUser(currentUser, context);
      }
    })
    .catchError((e) {
      print("e #40: $e");
    });
    
    assert(user.uid == currentUser.uid);
    Navigator.of(context).pushReplacementNamed('/homepage');
  }


}