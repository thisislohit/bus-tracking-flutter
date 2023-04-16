// ignore_for_file: unnecessary_new, dead_code, unnecessary_const

//import 'dart:js';
import 'dart:async';

import 'package:bus_tracking_app/tracking/WaitingMode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'google_map.dart';

class BlackTint extends StatefulWidget {
  const BlackTint({Key? key}) : super(key: key);

  @override
  State<BlackTint> createState() => _BlackTintState();
}

// Future<bool?> _onBackPressed() async {
//   var context;
//   return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Do you want to exit?'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('No'),
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//             ),
//             TextButton(
//               child: Text('Yes'),
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//                 SystemNavigator.pop();
//               },
//             ),
//           ],
//         );
//       });
// }

class _BlackTintState extends State<BlackTint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.grey.shade300,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => PassengerMode(),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.deepPurple,
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(4, 4),
                        ),
                        BoxShadow(
                          color: Colors.white,
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(-4, -4),
                        )
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Passenger Mode',
                        style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(msg: 'Welcome to Kru Buses');
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => WaitingMode()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.deepPurple,
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(4, 4),
                        ),
                        BoxShadow(
                          color: Colors.white,
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(-4, -4),
                        )
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Waiting Mode',
                        style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
