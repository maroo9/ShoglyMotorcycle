import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../Core/AssetsManger/AssetsManger.dart';
import '../../../../Core/ColorsManger/Colorsmanger.dart';
import '../../../../Core/routesMnager/RoutesManger.dart';
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    nevigatestate();
  }

  Future<void> nevigatestate() async {
    await Future.delayed(Duration(seconds: 3));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    Navigator.pushReplacementNamed(
      context,
      user == null ? RoutesManager.Logins : RoutesManager.Mainlayout,
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorsmanger.Whiteblue,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 200,
          ),
          Container(
            width: 200,
            height: 150,
            child: Image(
              image: AssetImage(
                Imagemanger.logoimage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
