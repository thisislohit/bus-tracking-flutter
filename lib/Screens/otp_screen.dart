import 'dart:async';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'home_screen.dart';

class otpscreen extends StatefulWidget {
  const otpscreen({Key? key}) : super(key: key);

  @override
  State<otpscreen> createState() => _otpscreenState();
}

class _otpscreenState extends State<otpscreen> {
  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController otpController = new TextEditingController();

  // form key
  final _formKey = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;

  @override
  void initState() {
    var user = auth.currentUser;
    user!.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 4), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //email field
    // final emailField = TextFormField(
    //     autofocus: false,
    //     controller: emailController,
    //     keyboardType: TextInputType.emailAddress,
    //     validator: (value) {
    //       if (value!.isEmpty) {
    //         return ("Please Enter Your Email");
    //       }
    //       // reg expression for email validation
    //       if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
    //           .hasMatch(value)) {
    //         return ("Please Enter a valid email");
    //       }
    //       return null;
    //     },
    //     onSaved: (value) {
    //       emailController.text = value!;
    //     },
    //     textInputAction: TextInputAction.next,
    //     decoration: InputDecoration(
    //       prefixIcon: Icon(Icons.mail),
    //       contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    //       hintText: "Email",
    //       border: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //     ));

    final verifyOtp = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.deepPurple,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            checkEmailVerified();

              showDialog(
                context: context,
                builder: (context) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ));
                },
              );
          },
          child: Text(
            "Verify Email",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
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
            // passing this to our root
            Navigator.of(context).pop(LoginScreen());
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Lottie.asset('assets/images/otp.json',
                        width: 200, height: 200, fit: BoxFit.fill),
                    Text(
                      'Verification',
                      style: GoogleFonts.poppins(
                          fontSize: 34, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 15),
                    // emailField,
                    // SizedBox(height: 25),
                    verifyOtp,
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Note: ",
                        style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),),

                        Text("Please check your spam folder"),
                        
                      ]
                    )
                    
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {

    var user = auth.currentUser!;
    await user.reload();

    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pop;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
      Fluttertoast.showToast(msg: "Verification Successful");
      
    }
  }
}
