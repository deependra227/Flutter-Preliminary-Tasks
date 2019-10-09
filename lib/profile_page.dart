import 'models/user_model.dart';
import 'services/user_management.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {

  final UserModel user;
  ProfilePage({
    @required this.user,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
      ),
     body: new Stack(
        children: <Widget>[
          Positioned(
            width: 350.0,
            left: 25,
            top: MediaQuery.of(context).size.height/7,
            child: Column(children: <Widget>[
              Container(
                width: 150,
                height: 150,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red,
                  image: DecorationImage(image: NetworkImage(widget.user.photoUrl),
                  fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.all(Radius.circular(75.0)),
                boxShadow: [
                  BoxShadow(blurRadius: 7.0, color: Colors.black)
                ]
                ),
              ),
              SizedBox(height: 20),
              (widget.user != null) ? _displayUserInfo() : CircularProgressIndicator()
            ],),
          )
        ],
      ),
      );
  }

  Widget _displayUserInfo() {
  return Column(
    children: <Widget>[
      Row(children: <Widget>[
      Text("Name: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
      Text("${widget.user.name}",style: TextStyle(fontSize: 18), textAlign: TextAlign.center)
    ]),
      Row(children: <Widget>[
      Text("Email: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18), textAlign: TextAlign.center),
      Text("${widget.user.email}",style: TextStyle(fontSize: 18), textAlign: TextAlign.center)
    ]),
    SizedBox(height: 55),
      _logoutButton(),
    ],
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
        UserManagement().signOut(context);
      },
    );
  }
}

