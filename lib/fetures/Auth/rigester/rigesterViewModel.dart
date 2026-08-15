import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Core/Utilits/Uitills.dart';
import '../../../Core/routesMnager/RoutesManger.dart';
import '../../../Models/UserModel (Operation Manager).dart';
import '../../../Services/FirebaseServices.dart';

class RegisterViewModel extends ChangeNotifier{
  Future<void>Register({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String phone,
  })async{
    try {
      UiUtils.Showloading(context);
      UserCredential userCredential = await FirebaseServices.registers(
        email,
        password,
        phone,
      );
      await FirebaseServices.addUserToFirestore(
        UserModel(
          id: userCredential.user!.uid,
          name: name,
          email: email,
          phone: phone,
          role: "operationManager",
          profileImage: null,
          createdAt: Timestamp.now(),

        ),
      );
      UiUtils.hidediaolog(context);
      UiUtils.showToastmassage("succefuly regested", Colors.green);
      Navigator.pushReplacementNamed(context, RoutesManager.Logins);
    } on FirebaseAuthException catch (e) {
      UiUtils.hidediaolog(context);
      UiUtils.showToastmassage(e.code, Colors.red);
    } catch (e) {
      UiUtils.hidediaolog(context);
      UiUtils.showToastmassage("failed to register ", Colors.red);
    }
  }

}

