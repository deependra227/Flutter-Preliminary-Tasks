
import 'services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewDataPage extends StatefulWidget {

  @override
  _ViewDataPageState createState() => _ViewDataPageState();
}

class _ViewDataPageState extends State<ViewDataPage> {

  FirestoreServices firestoreServices;

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
        title: Text('list'),
      ),
      body: Center(
        child: FutureBuilder(
          future: firestoreServices.getDataFromCollection('testPreferences'),
          builder: (_, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          }
          if(snapshot.hasData) {
            if(snapshot.data != null) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(10.0),
                      children: snapshot.data.documents.map<Widget>((DocumentSnapshot document) {
                        return SizedBox(
                          child: Text(document['events'], style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),)
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }
          }
          else {
            CircularProgressIndicator();
          }
        },),
      ),
    );
  } 
}