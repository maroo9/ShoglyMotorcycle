import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../Models/PaymentModel.dart';
import '../../../../Models/representativeModel.dart';
import '../../../../Services/FirebaseServices.dart';

class PaymentsViewModel extends ChangeNotifier {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String paymentMethod = "Cash";
  bool isPaid = true;
  bool isSaving = false;

  final List<String> paymentMethods = const [
    "Cash",
    "Instapay",
    "Wallet",
  ];

  Stream<List<RepresentativeModel>> get representativesStream {
    return FirebaseServices.streamRepresentatives();
  }

  Stream<List<PaymentModel>> get paymentsStream {
    return FirebaseFirestore.instance
        .collection("Payments")
        .withConverter<PaymentModel>(
          fromFirestore: (snapshot, _) =>
              PaymentModel.fromJson(snapshot.data() ?? {}),
          toFirestore: (payment, _) => payment.toJson(),
        )
        .snapshots()
        .map((query) => query.docs.map((doc) => doc.data()).toList());
  }

  PaymentModel? paymentForRepresentative(
    RepresentativeModel representative,
    List<PaymentModel> payments,
  ) {
    for (final payment in payments) {
      if (payment.representativeId == representative.id ||
          payment.driverId == representative.id) {
        return payment;
      }
    }
    return null;
  }

  double totalPaid(List<PaymentModel> payments) {
    return payments
        .where((payment) => payment.isPaid)
        .fold(0, (total, payment) => total + payment.amount);
  }

  void preparePayment(PaymentModel? payment) {
    amountController.text = payment == null ? "" : payment.amount.toString();
    notesController.text = payment?.notes ?? "";
    paymentMethod = payment?.paymentMethod.isNotEmpty == true
        ? payment!.paymentMethod
        : "Cash";
    isPaid = payment?.isPaid ?? true;
    notifyListeners();
  }

  void updatePaymentMethod(String? method) {
    if (method == null) return;
    paymentMethod = method;
    notifyListeners();
  }

  void updatePaidStatus(bool value) {
    isPaid = value;
    notifyListeners();
  }

  Future<bool> savePayment(RepresentativeModel representative) async {
    if (formKey.currentState?.validate() != true) return false;

    isSaving = true;
    notifyListeners();

    final payment = PaymentModel(
      id: representative.id,
      representativeId: representative.id,
      motorcycleId: representative.motorcycleId,
      driverId: representative.id,
      amount: double.tryParse(amountController.text.trim()) ?? 0,
      paymentMethod: paymentMethod,
      isPaid: isPaid,
      paymentDate: Timestamp.now(),
      notes: notesController.text.trim(),
    );

    try {
      await FirebaseFirestore.instance
          .collection("Payments")
          .doc(representative.id)
          .set(payment.toJson());
      return true;
    } catch (_) {
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  String? amountValidator(String? value) {
    final amount = double.tryParse(value?.trim() ?? "");
    if (amount == null || amount < 0) {
      return "Enter a valid amount";
    }
    return null;
  }

  @override
  void dispose() {
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
