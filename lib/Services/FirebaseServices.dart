import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shoghly/Models/MotorcycleModel.dart';
import 'package:shoghly/Models/PaymentModel.dart';
import 'package:shoghly/Models/representativeModel.dart';
import 'package:shoghly/fetures/mainlayout/tabs/Motorcycles/Motorcycles.dart';

import '../Models/MaintenanceModel.dart';
import '../Models/UserModel (Operation Manager).dart';

class FirebaseServices {
  /// git the instance of the firebase firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<UserCredential> registers(String email, String password,
      String phone) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  static Future<UserCredential> login(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }
  static addUserToFirestore(UserModel user) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference<UserModel> usercollection =
    db.collection("Users").withConverter<UserModel>(
      fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson(),
    );
    DocumentReference<UserModel> userDocument = usercollection.doc(user.id);
    return userDocument.set(user);
  }
  static Future<UserModel?> getUserById(String id) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference<UserModel> usercollection =
    db.collection("Users").withConverter<UserModel>(
      fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson(),
    );
    DocumentReference<UserModel> userDocument = usercollection.doc(id);
    DocumentSnapshot<UserModel> userSnapshot = await userDocument.get();
    return userSnapshot.data();
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
  /// add the motor cycles to fire store :
  static Future<void> addMotorCyclesTofirestore(MotorcycleModel Motor) {
    FirebaseFirestore dbs = FirebaseFirestore.instance;
    CollectionReference<MotorcycleModel> MotorCollections =
    dbs.collection("Motors").withConverter<MotorcycleModel>(
      fromFirestore: (snapshot, _) => MotorcycleModel.fromJson(snapshot.data()!),
      toFirestore: (Motor, _) => Motor.toJson(),
    );
    DocumentReference<MotorcycleModel> Motordocument = MotorCollections.doc(Motor.id);
    return Motordocument.set(Motor);
  }
  /// function to  update the user to fire base fire store
  static Future<void>UpdateUserToFirestore(MotorcycleModel Motor) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference<MotorcycleModel> MotorCollections =
    db.collection("Motors").withConverter<MotorcycleModel>(
      fromFirestore: (snapshot, _) => MotorcycleModel.fromJson(snapshot.data()!),
      toFirestore: (Motor, _) => Motor.toJson(),
    );
    DocumentReference<MotorcycleModel> userDocument = MotorCollections.doc(Motor.id);
    return userDocument.update(Motor.toJson());
  }



  static Future<void> addMotorRepresttiveTofirestore(RepresentativeModel representative) {
    FirebaseFirestore dbs = FirebaseFirestore.instance;
    CollectionReference<RepresentativeModel> RepresentativeCollections =
    dbs.collection("Representatives").withConverter<RepresentativeModel>(
      fromFirestore: (snapshot, _) => RepresentativeModel.fromJson(snapshot.data()!),
      toFirestore: (representative, _) => representative.toJson(),
    );
    DocumentReference<RepresentativeModel> representativedocument = RepresentativeCollections.doc(representative.id);
    return representativedocument.set(representative);
  }

  static Future<void> addPaymentsTofirestore(PaymentModel payment) {
    FirebaseFirestore dbs = FirebaseFirestore.instance;
    CollectionReference<PaymentModel>paymentCollections =
    dbs.collection("Payments").withConverter<PaymentModel>(
      fromFirestore: (snapshot, _) => PaymentModel.fromJson(snapshot.data()!),
      toFirestore: (payment, _) => payment.toJson(),
    );
    DocumentReference<PaymentModel> paymentedocument = paymentCollections.doc(payment.id);
    return paymentedocument.set(payment);
  }


  static Future<void> addMentanceTofirestore(MaintenanceModel Maintenance ) {
    FirebaseFirestore dbs = FirebaseFirestore.instance;
    CollectionReference<MaintenanceModel>MaintenanceCollections =
    dbs.collection("Maintenances").withConverter<MaintenanceModel>(
      fromFirestore: (snapshot, _) => MaintenanceModel.fromJson(snapshot.data()!),
      toFirestore: (payment, _) => payment.toJson(),
    );
    DocumentReference<MaintenanceModel> Maintenancedocument = MaintenanceCollections.doc(Maintenance.id);
    return Maintenancedocument.set(Maintenance);
  }
























///..........................................................................................
  ///Streams  of data

/// get the motor cycles from fire store :
  static Stream<List<MotorcycleModel>> streamMotorcycles() {
    FirebaseFirestore ff = FirebaseFirestore.instance;
    CollectionReference<MotorcycleModel> allMotors =
    ff.collection("Motors").withConverter<MotorcycleModel>(
      fromFirestore: (snapshot, _) => MotorcycleModel.fromJson(snapshot.data()!),
      toFirestore: (Motor, _) => Motor.toJson(),
    );

    return allMotors
        .snapshots()
        .map((query) => query.docs.map((doc) => doc.data()).toList());
  }

  static Stream<List<RepresentativeModel>> streamRepresentatives() {
    FirebaseFirestore ff = FirebaseFirestore.instance;
    CollectionReference<RepresentativeModel> allReprestitive =
    ff.collection("Representatives").withConverter<RepresentativeModel>(
      fromFirestore: (snapshot, _) => RepresentativeModel.fromJson(snapshot.data()!),
      toFirestore: (representative, _) => representative.toJson(),
    );

    return allReprestitive
        .snapshots()
        .map((query) => query.docs.map((doc) => doc.data()).toList());
  }

  static Stream<List<PaymentModel>> streamPayments() {
    FirebaseFirestore ff = FirebaseFirestore.instance;
    CollectionReference<PaymentModel> allPayments =
    ff.collection("Payments").withConverter<PaymentModel>(
      fromFirestore: (snapshot, _) => PaymentModel.fromJson(snapshot.data()!),
      toFirestore: (payment, _) => payment.toJson(),
    );

    return allPayments
        .snapshots()
        .map((query) => query.docs.map((doc) => doc.data()).toList());
  }


  static Stream<List<MaintenanceModel>> streamMaintenance() {
    FirebaseFirestore ff = FirebaseFirestore.instance;
    CollectionReference<MaintenanceModel> allMaintances =
    ff.collection("Maintenances").withConverter<MaintenanceModel>(
      fromFirestore: (snapshot, _) => MaintenanceModel.fromJson(snapshot.data()!),
      toFirestore: (payment, _) => payment.toJson(),
    );

    return allMaintances
        .snapshots()
        .map((query) => query.docs.map((doc) => doc.data()).toList());
  }



























}


