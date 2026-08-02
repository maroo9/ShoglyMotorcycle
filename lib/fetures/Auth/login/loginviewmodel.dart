

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Utilits/Uitills.dart';
import '../../../Core/routesMnager/RoutesManger.dart';
import '../../../Providers/UserProvider.dart';
import '../../../Services/FirebaseServices.dart';

class LoginViewModel extends ChangeNotifier {
  Future <void> Login({
    required BuildContext context,
    required String email,
    required String password,


  }) async {
    try {
      UiUtils.Showloading(context);
      UserCredential userCredential = await FirebaseServices.login(
        email,
        password,
      );
      UiUtils.hidediaolog(context);
      UiUtils.showToastmassage("Success", Colors.green);
      await context.read<UserProvider>().loadUser();
      Navigator.pushReplacementNamed(context, RoutesManager.Mainlayout);
    } on FirebaseAuthException {
      UiUtils.hidediaolog(context);
      UiUtils.showToastmassage("failed to login", Colors.red);
    } catch (_) {
      UiUtils.hidediaolog(context);
      UiUtils.showToastmassage("failed to login", Colors.red);
    }
  }
}
