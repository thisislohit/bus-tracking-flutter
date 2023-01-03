import 'package:email_password_login/screens/home_screen.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:email_password_login/screens/splash_screen.dart';
import 'package:email_password_login/screens/welcome_screen.dart';

const String welcomeRoute = "/welcome";
const String homeRoute = "/home";
const String loginRoute = "/login";
const String splashRoute = "/splash";

final routes = {
  welcomeRoute: (context) => welcomeScreen(),
  homeRoute: (context) => HomeScreen(),
  loginRoute: (context) => LoginScreen(),
  splashRoute: (context) => splashScreen()
};
