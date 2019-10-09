import 'package:flutter/widgets.dart';

class UserModel {
  
  final String name;
  final String email;
  final String uid;
  final String photoUrl;


  UserModel({
    @required this.name,
    @required this.email,
    @required this.uid,
    this.photoUrl,
    
  });

}
