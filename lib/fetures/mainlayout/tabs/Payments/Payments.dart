import 'package:flutter/material.dart';

import '../../../../Core/ColorsManger/Colorsmanger.dart';
import '../../../../Core/Widgets/CustomTextForm.dart';
import '../../../../Core/Widgets/Custom_Elvated button.dart';
import '../../../../Core/Widgets/InfoTile.dart';
import '../../../../Core/Widgets/StatusChip.dart';
import '../../../../Models/PaymentModel.dart';
import '../../../../Models/representativeModel.dart';
import '../../../../l10n/app_localizations.dart';
import 'PaymentsViewModel.dart';

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  late final PaymentsViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = PaymentsViewModel();
    viewModel.addListener(_refreshUi);
  }

  @override
  void dispose() {
    viewModel.removeListener(_refreshUi);
    viewModel.dispose();
    super.dispose();
  }

  void _refreshUi() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorsmanger.bg,
      appBar: AppBar(
        backgroundColor: Colorsmanger.darkblue,
        foregroundColor: Colorsmanger.White,
        title: Text(AppLocalizations.of(context)!.payments),
      ),
      body: StreamBuilder<List<PaymentModel>>(
        stream: viewModel.paymentsStream,
        builder: (context, paymentsSnapshot) {
          final payments = paymentsSnapshot.data ?? [];

          return Column(
            children: [
              _TotalMoneyCard(total: viewModel.totalPaid(payments)),
              Expanded(
                child: StreamBuilder<List<RepresentativeModel>>(
                  stream: viewModel.representativesStream,
                  builder: (context, representativesSnapshot) {
                    if (paymentsSnapshot.connectionState ==
                            ConnectionState.waiting ||
                        representativesSnapshot.connectionState ==
                            ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (paymentsSnapshot.hasError ||
                        representativesSnapshot.hasError) {
                      return const Center(child: Text("Could not load payments"));
                    }

                    final representatives = representativesSnapshot.data ?? [];

                    if (representatives.isEmpty) {
                      return Center(
                        child: Text(AppLocalizations.of(context)!.no_payments),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                      itemBuilder: (context, index) {
                        final representative = representatives[index];
                        final payment = viewModel.paymentForRepresentative(
                          representative,
                          payments,
                        );

                        return _PaymentRepresentativeCard(
                          representative: representative,
                          payment: payment,
                          onEdit: () => _showPaymentSheet(
                            representative,
                            payment,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: representatives.length,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPaymentSheet(
    RepresentativeModel representative,
    PaymentModel? payment,
  ) {
    viewModel.preparePayment(payment);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colorsmanger.White,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Form(
                key: viewModel.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              representative.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      InfoRow(
                        icon: Icons.motorcycle,
                        text: representative.motorcycleId,
                      ),
                      const SizedBox(height: 14),
                      CustomTextForm(
                        controller: viewModel.amountController,
                        labelText: AppLocalizations.of(context)!.amount_paid,
                        prefixIcon: Icons.payments,
                        keyboardType: TextInputType.number,
                        validator: viewModel.amountValidator,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: viewModel.paymentMethod,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.payment_method,
                          prefixIcon: const Icon(Icons.account_balance_wallet),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: viewModel.paymentMethods.map((method) {
                          return DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          );
                        }).toList(),
                        onChanged: (method) {
                          viewModel.updatePaymentMethod(method);
                          setSheetState(() {});
                        },
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        value: viewModel.isPaid,
                        onChanged: (value) {
                          viewModel.updatePaidStatus(value);
                          setSheetState(() {});
                        },
                        title: const Text("Rent paid"),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 12),
                      CustomTextForm(
                        controller: viewModel.notesController,
                        labelText: "Notes",
                        prefixIcon: Icons.notes,
                        validator: (_) => null,
                        Lines: 2,
                      ),
                      const SizedBox(height: 18),
                      viewModel.isSaving
                          ? const Center(child: CircularProgressIndicator())
                          : CustomElevatedButton(
                              text: AppLocalizations.of(context)!.save,
                              onPress: () => _savePayment(representative),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _savePayment(RepresentativeModel representative) async {
    final isSaved = await viewModel.savePayment(representative);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSaved ? "Payment saved successfully" : "Failed to save payment",
        ),
      ),
    );

    if (isSaved) {
      Navigator.pop(context);
    }
  }
}

class _TotalMoneyCard extends StatelessWidget {
  const _TotalMoneyCard({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colorsmanger.darkblue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total collected",
            style: TextStyle(
              color: Colorsmanger.Whiteblue,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${total.toStringAsFixed(2)} EGP",
            style: const TextStyle(
              color: Colorsmanger.White,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentRepresentativeCard extends StatelessWidget {
  const _PaymentRepresentativeCard({
    required this.representative,
    required this.payment,
    required this.onEdit,
  });

  final RepresentativeModel representative;
  final PaymentModel? payment;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final isPaid = payment?.isPaid ?? false;
    final amount = payment?.amount ?? 0;
    final method = payment?.paymentMethod ?? "Not selected";

    return Card(
      color: Colorsmanger.White,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: Colorsmanger.lightgrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        representative.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        representative.phone,
                        style: const TextStyle(color: Colorsmanger.Grey),
                      ),
                    ],
                  ),
                ),
                StatusChip(status: isPaid ? "Paid" : "Not paid"),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(height: 12),
            InfoRow(icon: Icons.motorcycle, text: representative.motorcycleId),
            const SizedBox(height: 6),
            InfoRow(
              icon: Icons.payments,
              text: "${amount.toStringAsFixed(2)} EGP",
            ),
            const SizedBox(height: 6),
            InfoRow(icon: Icons.account_balance_wallet, text: method),
            const SizedBox(height: 6),
            InfoRow(
              icon: Icons.calendar_month,
              text:
                  "${representative.rentalDate.year}-${representative.rentalDate.month}-${representative.rentalDate.day}",
            ),
          ],
        ),
      ),
    );
  }
}
