import 'dart:async';
import 'package:email_password_login/model/routes.dart';
import 'package:email_password_login/model/shared_preference.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:email_password_login/screens/otp_screen.dart';
import 'package:email_password_login/screens/registration_screen.dart';
import 'package:email_password_login/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'Forgot_Password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;

  // string for displaying the error Message
  String? errorMessage;

  bool _obscureText = true;

  PrefService _prefService = PrefService();

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        autofillHints: [AutofillHints.email],
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: _obscureText,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        } else if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.deepPurple,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return WillPopScope(
      onWillPop: () async {
        return await Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => welcomeScreen()));
      },
      child: Scaffold(
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
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => welcomeScreen()));
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
                      Lottie.asset('assets/images/user-anime.json',
                          width: 100, height: 100, fit: BoxFit.fill),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.poppins(
                            fontSize: 34, fontWeight: FontWeight.w700),
                      ),

                      // SizedBox(
                      //     height: 200,
                      //     child: Image.asset(
                      //       "assets/logo.png",
                      //       fit: BoxFit.contain,
                      //     )),
                      SizedBox(height: 25),
                      emailField,
                      SizedBox(height: 25),
                      passwordField,
                      SizedBox(height: 20),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassword()));
                                },
                                child: Container(
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      loginButton,
                      SizedBox(height: 15),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegistrationScreen()));
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            )
                          ])
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // login function
  void signIn(String email, String password) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: CircularProgressIndicator(
          color: Colors.deepPurple,
        ));
      },
    );

    if (_formKey.currentState!.validate()) {
      try {
        await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) async => {
                  await _prefService.createCache(
                      emailController.text, passwordController.text),
                  user = auth.currentUser!,
                  await user.reload(),
                  if (user.emailVerified)
                    {
                      Navigator.of(context).pop,
                      Navigator.of(context).pushReplacementNamed(homeRoute)
                    }
                  else
                    {
                      Navigator.of(context).pop,
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => otpscreen()))
                    }
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Navigator.of(context).pop;
        Navigator.of(context).pushReplacementNamed(loginRoute);
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
}
