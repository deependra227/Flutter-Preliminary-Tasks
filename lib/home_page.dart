import 'dart:async';

import 'package:agnysapp/profile_page.dart';
import 'package:agnysapp/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'view_data.dart';

import 'models/user_model.dart';
class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String data;
  FirestoreServices firestoreServices;
  
  UserModel currUser;
  
  @override
  void initState() { 
    super.initState();
    setState(() {
      firestoreServices = new FirestoreServices();
    });
      

  }
   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
        centerTitle: true,
        actions: <Widget>[
          _profilePageButton(),
        ],
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You are now logged in.'),
              SizedBox(height: 15.0),
              _logoutButton(),
              _addTestDataButton(),
              _viewTestDataButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profilePageButton() {
    return IconButton(
      icon: Icon(Icons.person),
      onPressed: () {
        firestoreServices.getUser().then((user) {
          this.currUser = new UserModel(
            name: user.displayName,
            email: user.email,
            uid: user.uid,
            photoUrl: user.photoUrl,
          
          );
          print("db#8: ${this.currUser.uid}");
          Navigator.push(context, MaterialPageRoute(builder: (context) => new ProfilePage(user: this.currUser)));
        });
      },
    );
  }

  Future<bool> addDialog(BuildContext context) async {
    return  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add data", style: TextStyle(fontSize: 15.0),),
          content: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: 'Events interested in'),
                onChanged: (value) {
                  this.data = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Add"),
              onPressed: () {
                Navigator.of(context).pop();
                Map<String, String> userPreferences = {
                  'events' : this.data,
                  'uid' : this.currUser.uid,
                };
                firestoreServices.addData(userPreferences).then((result) {
                  dialogTrigger(context);
                }).catchError((e) {
                  print("my_debug: $e");
                });
              },
            ),
          ],
        );
      }
    );
  }

  Future<bool> dialogTrigger(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Data successfully added', style: TextStyle(fontSize: 15.0),),
          content: Text('Added'),
          actions: <Widget>[
            FlatButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  Widget _logoutButton() {
    return OutlineButton(
      borderSide: BorderSide(
        color: Colors.red,
        style: BorderStyle.solid,
        width: 3.0,
      ),
      child: Text('Logout'),
      onPressed: () {
        FirebaseAuth.instance.signOut().then((value) {
          Navigator.of(context).pushReplacementNamed('/landingpage');
        }).catchError((e) {
          // TODO: handle this error properly
          print("my_debug: $e");
        });
      },
    );
  }

  Widget _addTestDataButton() {
    return OutlineButton(
      borderSide: BorderSide(
        color: Colors.red,
        style: BorderStyle.solid,
        width: 3.0,
      ),
      child: Text('Add test data'),
      onPressed: () {
        if(this.currUser.uid != null) {
          addDialog(context);
        }
        else {
          print("err #3: userUid is null");
          // TODO: handle this error properly
        }
      }
    );
  }

  Widget _viewTestDataButton() {
    return OutlineButton(
      borderSide: BorderSide(
        color: Colors.red,
        style: BorderStyle.solid,
        width: 3.0,
      ),
      child: Text('View test data'),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> new ViewDataPage()));
      }
    );
  }
}
