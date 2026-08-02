import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../Core/AssetsManger/AssetsManger.dart';
import '../../../../Core/ColorsManger/Colorsmanger.dart';
import '../../../../Core/routesMnager/RoutesManger.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
    nevigatestate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> nevigatestate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    String nextRoute = RoutesManager.Logins;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        nextRoute = RoutesManager.Mainlayout;
      }
    } catch (_) {
      nextRoute = RoutesManager.Logins;
    }

    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      nextRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorsmanger.darkblue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(),
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    children: [
                      Container(
                        height: 122,
                        width: 122,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colorsmanger.White,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 22,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Image.asset(Imagemanger.logoimage),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        "SHOGHLY",
                        style: TextStyle(
                          color: Colorsmanger.White,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Motorcycle operations dashboard",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colorsmanger.Whiteblue,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(
                width: 34,
                height: 34,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colorsmanger.White,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Preparing workspace",
                style: TextStyle(
                  color: Colorsmanger.Whiteblue,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
