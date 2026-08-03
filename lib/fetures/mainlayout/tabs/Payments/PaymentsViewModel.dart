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
  DateTime selectedDate = DateTime.now();

  final List<String> paymentMethods = const [
    "Cash",
    "Instapay",
    "Wallet",
  ];

  void selectDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void changeDateByDays(int days) {
    selectedDate = selectedDate.add(Duration(days: days));
    notifyListeners();
  }

  void selectToday() {
    selectedDate = DateTime.now();
    notifyListeners();
  }

  bool get isSelectedDateToday {
    final now = DateTime.now();
    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
  }

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
    List<PaymentModel> payments, {
    DateTime? date,
  }) {
    final targetDate = date ?? selectedDate;
    for (final payment in payments) {
      if ((payment.representativeId == representative.id ||
              payment.driverId == representative.id) &&
          payment.isSameDay(targetDate)) {
        return payment;
      }
    }
    return null;
  }

  double totalPaid(List<PaymentModel> payments, {DateTime? date}) {
    final targetDate = date ?? selectedDate;
    return payments
        .where((payment) => payment.isPaid && payment.isSameDay(targetDate))
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

  String _generateDocId(String repId, DateTime date) {
    final yyyy = date.year.toString();
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return "${repId}_$yyyy-$mm-$dd";
  }

  Future<bool> savePayment(RepresentativeModel representative) async {
    if (formKey.currentState?.validate() != true) return false;

    isSaving = true;
    notifyListeners();

    final docId = _generateDocId(representative.id, selectedDate);
    final now = DateTime.now();
    final paymentDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      now.hour,
      now.minute,
      now.second,
    );

    final payment = PaymentModel(
      id: docId,
      representativeId: representative.id,
      motorcycleId: representative.motorcycleId,
      driverId: representative.id,
      amount: double.tryParse(amountController.text.trim()) ?? 0,
      paymentMethod: paymentMethod,
      isPaid: isPaid,
      paymentDate: Timestamp.fromDate(paymentDateTime),
      notes: notesController.text.trim(),
    );

    try {
      await FirebaseFirestore.instance
          .collection("Payments")
          .doc(docId)
          .set(payment.toJson());
      return true;
    } catch (_) {
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> resetSelectedDay(List<PaymentModel> payments) async {
    isSaving = true;
    notifyListeners();

    try {
      final targetPayments =
          payments.where((p) => p.isSameDay(selectedDate)).toList();

      if (targetPayments.isEmpty) {
        return true;
      }

      final batch = FirebaseFirestore.instance.batch();
      for (final payment in targetPayments) {
        final docRef =
            FirebaseFirestore.instance.collection("Payments").doc(payment.id);
        batch.update(docRef, {
          "isPaid": false,
          "amount": 0,
        });
      }

      await batch.commit();
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
