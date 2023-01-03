import 'dart:async';
import 'package:email_password_login/model/shared_preference.dart';
import 'package:email_password_login/model/routes.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  final PrefService _prefService = PrefService();

  @override
  void initState() {
    _prefService.readCache("email").then((value) {
      print(value.toString());
      if (value != null) {
        return Timer(Duration(seconds: 1),
            () => Navigator.of(context).pushReplacementNamed(homeRoute));
      } else {
        return Timer(Duration(seconds: 1),
            () => Navigator.of(context).pushNamed(welcomeRoute));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
                child:
                    Image.asset("assets/images/logo.png", fit: BoxFit.contain),
              ),
            ]
          )
        )
      )
    );
  }
}
