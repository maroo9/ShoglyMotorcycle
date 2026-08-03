
import 'package:flutter/cupertino.dart';

import '../../fetures/Auth/forgetPassword/forgetPassword.dart';
import '../../fetures/Auth/login/login.dart';
import '../../fetures/Auth/rigester/rigester.dart';
import '../../fetures/mainlayout/mainlayout.dart';
import '../../fetures/mainlayout/tabs/splashScreen/SplashScreen.dart';

abstract class RoutesManager {
  static const String splashscreen="/Splashscreen/";
  static const String Mainlayout="/mainlayout/";
  static const String Logins="/Login/";
  static const String Rigesters="/Register/";
  //static const String Maps="/Googlemaps/";
  //static const String Chats="/ChatScreen/";
  static const String ForgetPassword="/forgetPassword/";
  static Map<String,WidgetBuilder> routes={
    splashscreen:(context)=>Splashscreen(),
    Mainlayout :(context)=>MainLayout(),
     Logins :(context)=>Login(),
    Rigesters :(context)=>Register(),
    // Maps :(context)=>GoogleMaps(),
    // Chats:(context)=>ChatScreen(otherUserId: "",),
     ForgetPassword:(context)=>forgetPassword(),

  };
}