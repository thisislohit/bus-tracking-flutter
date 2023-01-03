import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/shared_preference.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  PrefService _prefService = PrefService();

  Future<bool?> _onBackPressed() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Do you want to exit?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  SystemNavigator.pop();
                },
              ),
            ],
          );
        });
  }

  final Stream<QuerySnapshot>users=
    FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        if (result == null) {
          result = false;
        }
        return result;
      },
      child: new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              _onBackPressed();
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  child: Image.asset("assets/images/logo.png",
                      fit: BoxFit.contain),
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height:250,
                  padding:const EdgeInsets.symmetric(vertical:20),
                  child:StreamBuilder<QuerySnapshot>(
                    stream:users,
                    builder:(
                        BuildContext context,
                      AsyncSnapshot<QuerySnapshot>snapshot,){
                        if(snapshot.hasError){
                          return Text('Something went wrong.');
                        }
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Text('Loading');
                        }
                        final data=snapshot.requireData;

                        return ListView.builder(
                        itemCount:data.size,
                          itemBuilder:(context,index){
                            return Text('${data.docs[index]['fullname']} ${data.docs[index]['email']}');
                          }
                        );
                      }
                    )
                  ),  
                // Text("${loggedInUser.fullName}",
                //     style: TextStyle(
                //       color: Colors.black54,
                //       fontWeight: FontWeight.w500,
                //     )),
                // Text("${loggedInUser.email}",
                //     style: TextStyle(
                //       color: Colors.black54,
                //       fontWeight: FontWeight.w500,
                //     )),
                // SizedBox(
                //   height: 15,
                // ),
                ActionChip(
                  label: Text("Logout"),
                  onPressed: () async {
                    await _prefService
                      .removeCache("email", "password")
                      .whenComplete(() => {
                        logout(context),
                      });
                  }
                ),
              ],
            ),
          ),
        )
      )
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
