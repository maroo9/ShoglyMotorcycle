
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../Models/UserModel (Operation Manager).dart';
import '../Services/FirebaseServices.dart';

/// creating the state manger
class UserProvider extends ChangeNotifier{
  UserModel? _currentUser; ///  stores the  logged in user

  UserModel? get currentUser => _currentUser; ///You don’t allow screens to modify the user directly.
  bool get isLoggedIn => _currentUser != null;

  void setCurrentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> loadUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      _currentUser = null;
      notifyListeners();
      return;
    }

    _currentUser = UserModel(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? "Operation Manager",
      email: firebaseUser.email ?? "",
      phone: firebaseUser.phoneNumber,
      role: "operationManager",
      profileImage: firebaseUser.photoURL,
      createdAt: Timestamp.now(),
    );
    notifyListeners();

    try {
      final firestoreUser = await FirebaseServices.getUserById(firebaseUser.uid);
      if (firestoreUser != null) {
        _currentUser = firestoreUser;
        notifyListeners();
      }
    } catch (_) {
      // Keep the Firebase Auth user loaded so navigation is not blocked by Firestore.
    }
  }


}
