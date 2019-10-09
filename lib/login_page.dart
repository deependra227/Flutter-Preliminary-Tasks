import 'services/user_management.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              googleLoginButton(),
                
            ],
          ),
        ),
      ),
    );
  }

  Widget googleLoginButton() {
    return RaisedButton(
      child: Text('Login with Google'),
      color: Colors.blue,
      textColor: Colors.white,
      elevation: 7.0,
      onPressed: () async {
        UserManagement().signInWithGoogle(context);
      },
    );
  }
  

  
  
  
  }
  

 
  












