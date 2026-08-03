import 'package:flutter/material.dart';

import '../../../../Core/ColorsManger/Colorsmanger.dart';
import '../../../../Core/Widgets/CustomTextForm.dart';
import '../../../../Core/Widgets/Custom_Elvated button.dart';
import '../../../../Core/Widgets/InfoTile.dart';
import '../../../../Core/Widgets/StatusChip.dart';
import '../../../../Models/PaymentModel.dart';
import '../../../../Models/representativeModel.dart';
import '../../../../l10n/app_localizations.dart';
import 'DateSelectorBar.dart';
import 'PaymentRepresentativeCard.dart';
import 'PaymentsViewModel.dart';
import 'TotalMoneyCard.dart';

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
    final formattedSelectedDate =
        "${viewModel.selectedDate.year}-${viewModel.selectedDate.month.toString().padLeft(2, '0')}-${viewModel.selectedDate.day.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: Colorsmanger.bg,
      appBar: AppBar(
        backgroundColor: Colorsmanger.darkblue,
        foregroundColor: Colorsmanger.White,
        title: Text(AppLocalizations.of(context)!.payments),
        actions: [
          IconButton(
            tooltip: "Daily Reset",
            icon: const Icon(Icons.restart_alt),
            onPressed: () async {
              final payments = await viewModel.paymentsStream.first;
              if (!mounted) return;
              _confirmDailyReset(context, payments);
            },

          ),
        ],
      ),
      body: StreamBuilder<List<PaymentModel>>(
        stream: viewModel.paymentsStream,
        builder: (context, paymentsSnapshot) {
          final payments = paymentsSnapshot.data ?? [];

          return Column(
            children: [
              DateSelectorBar(
                viewModel: viewModel,
                onPickDate: _pickDate,
              ),
              TotalMoneyCard(
                total: viewModel.totalPaid(payments),
                dateText: formattedSelectedDate,
                isToday: viewModel.isSelectedDateToday,
                onReset: () => _confirmDailyReset(context, payments),
              ),
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

                        return PaymentRepresentativeCard(
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: viewModel.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      viewModel.selectDate(picked);
    }
  }

  Future<void> _confirmDailyReset(
    BuildContext context,
    List<PaymentModel> payments,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final cancelText = AppLocalizations.of(context)!.cancel;
    final formattedDate =
        "${viewModel.selectedDate.year}-${viewModel.selectedDate.month.toString().padLeft(2, '0')}-${viewModel.selectedDate.day.toString().padLeft(2, '0')}";

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.restart_alt, color: Colors.orange),
            SizedBox(width: 8),
            Text("Daily Reset"),
          ],
        ),
        content: Text(
          "Are you sure you want to reset all payment collections for $formattedDate?\n\nThis will reset collected amounts for this day to unpaid.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              "Reset Day",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await viewModel.resetSelectedDay(payments);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            success
                ? "Daily reset completed for $formattedDate"
                : "Failed to reset day payments",
          ),
        ),
      );
    }
  }


  void _showPaymentSheet(
    RepresentativeModel representative,
    PaymentModel? payment,
  ) {
    viewModel.preparePayment(payment);
    final formattedDate =
        "${viewModel.selectedDate.year}-${viewModel.selectedDate.month.toString().padLeft(2, '0')}-${viewModel.selectedDate.day.toString().padLeft(2, '0')}";

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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  representative.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "Payment Date: $formattedDate",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colorsmanger.Grey,
                                  ),
                                ),
                              ],
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
    final messenger = ScaffoldMessenger.of(context);
    final isSaved = await viewModel.savePayment(representative);
    if (!mounted) return;

    messenger.showSnackBar(
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




