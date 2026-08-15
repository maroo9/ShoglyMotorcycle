import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Core/ColorsManger/Colorsmanger.dart';
import '../../../../Core/routesMnager/RoutesManger.dart';
import '../../../../Models/MaintenanceModel.dart';
import '../../../../Models/MotorcycleModel.dart';
import '../../../../Models/PaymentModel.dart';
import '../../../../Models/UserModel (Operation Manager).dart';
import '../../../../Models/representativeModel.dart';
import '../../../../Providers/LocaleProvider.dart';
import '../../../../Providers/UserProvider.dart';
import '../../../../Services/FirebaseServices.dart';
import '../../../../l10n/app_localizations.dart';
import 'HomeViewModel.dart';
import 'Shortcuts/HomeShortcuts.dart';
import 'Statics/DashboardStats.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.onShortcutSelected});

  final ValueChanged<int> onShortcutSelected;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadUser();
    });
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserProvider>().currentUser;
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      backgroundColor: Colorsmanger.bg,
      body: StreamBuilder<List<MotorcycleModel>>(
        stream: viewModel.motorcyclesStream,
        builder: (context, motorcyclesSnapshot) {
          return StreamBuilder<List<RepresentativeModel>>(
            stream: viewModel.representativesStream,
            builder: (context, representativesSnapshot) {
              return StreamBuilder<List<PaymentModel>>(
                stream: viewModel.paymentsStream,
                builder: (context, paymentsSnapshot) {
                  return StreamBuilder<List<MaintenanceModel>>(
                    stream: viewModel.maintenanceStream,
                    builder: (context, maintenanceSnapshot) {
                      final motorcycles = motorcyclesSnapshot.data ?? [];
                      final representatives =
                          representativesSnapshot.data ?? [];
                      final payments = paymentsSnapshot.data ?? [];
                      final maintenances = maintenanceSnapshot.data ?? [];
                      final isLoading =
                          motorcyclesSnapshot.connectionState ==
                                  ConnectionState.waiting ||
                              representativesSnapshot.connectionState ==
                                  ConnectionState.waiting ||
                              paymentsSnapshot.connectionState ==
                                  ConnectionState.waiting ||
                              maintenanceSnapshot.connectionState ==
                                  ConnectionState.waiting;

                      return RefreshIndicator(
                        onRefresh: () async {
                          await context.read<UserProvider>().loadUser();
                        },
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            _HomeHeader(
                              currentUser: currentUser,
                              localeProvider: localeProvider,
                            ),
                            if (isLoading)
                              const Padding(
                                padding: EdgeInsets.all(24),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    _SectionTitle(
                                      title: AppLocalizations.of(context)!
                                          .dashboard,
                                    ),
                                    const SizedBox(height: 10),
                                    DashboardStats(
                                      items: [
                                        DashboardStatItem(
                                          title: AppLocalizations.of(context)!.total_collected_today,
                                          value:
                                              "${viewModel.totalCollected(payments).toStringAsFixed(0)} EGP",
                                          icon: Icons.payments,
                                          color: Colors.green,
                                        ),
                                        DashboardStatItem(
                                          title: AppLocalizations.of(context)!.motorcycles,
                                          value: motorcycles.length.toString(),
                                          icon: Icons.motorcycle,
                                          color: Colorsmanger.Blue,
                                        ),
                                        DashboardStatItem(
                                          title: AppLocalizations.of(context)!.rented,
                                          value: viewModel
                                              .rentedMotorcycles(
                                                motorcycles,
                                                representatives,
                                              )
                                              .toString(),
                                          icon: Icons.assignment_ind,
                                          color: Colors.orange,
                                        ),
                                        DashboardStatItem(
                                          title: AppLocalizations.of(context)!.available,
                                          value: viewModel
                                              .availableMotorcycles(
                                                motorcycles,
                                                representatives,
                                              )
                                              .toString(),
                                          icon: Icons.check_circle,
                                          color: Colors.teal,
                                        ),
                                        DashboardStatItem(
                                          title: AppLocalizations.of(context)!.representative,
                                          value:
                                              representatives.length.toString(),
                                          icon: Icons.people,
                                          color: Colors.purple,
                                        ),
                                        DashboardStatItem(
                                          title:  AppLocalizations.of(context)!.pending_maintenance,
                                          value: viewModel
                                              .pendingMaintenance(maintenances)
                                              .toString(),
                                          icon: Icons.build,
                                          color: Colorsmanger.Red,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 22),
                                     _SectionTitle(title:  AppLocalizations.of(context)!.shortcuts),
                                    const SizedBox(height: 10),
                                    HomeShortcuts(
                                      items: [
                                        HomeShortcutItem(
                                          title: AppLocalizations.of(context)!.motorcycles,
                                          subtitle: AppLocalizations.of(context)!.add_and_inspect_motorcycles,
                                          icon: Icons.motorcycle,
                                          color: Colorsmanger.Blue,
                                          onTap: () =>
                                              widget.onShortcutSelected(1),
                                        ),
                                        HomeShortcutItem(
                                          title: AppLocalizations.of(context)!.representative,
                                          subtitle:
                                          AppLocalizations.of(context)!.assign_rented_motorcycles,
                                          icon: Icons.person,
                                          color: Colors.purple,
                                          onTap: () =>
                                              widget.onShortcutSelected(2),
                                        ),
                                        HomeShortcutItem(
                                          title:AppLocalizations.of(context)!.payments,
                                          subtitle:
                                              "${viewModel.pendingPayments(payments)} "+ AppLocalizations.of(context)!.pending_rent_payments,
                                          icon: Icons.monetization_on,
                                          color: Colors.green,
                                          onTap: () =>
                                              widget.onShortcutSelected(3),
                                        ),
                                        HomeShortcutItem(
                                          title:AppLocalizations.of(context)!.maintenance,
                                          subtitle:
                                              "${viewModel.pendingMaintenance(maintenances)} open jobs",
                                          icon: Icons.settings,
                                          color: Colors.orange,
                                          onTap: () =>
                                              widget.onShortcutSelected(4),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.currentUser,
    required this.localeProvider,
  });

  final UserModel? currentUser;
  final LocaleProvider localeProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 46, 16, 22),
      decoration: const BoxDecoration(
        color: Colorsmanger.darkblue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.welcome_message!,
                  style: const TextStyle(
                    color: Colorsmanger.Whiteblue,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  currentUser?.name ?? "Operation Manager",
                  style: const TextStyle(
                    color: Colorsmanger.White,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colorsmanger.Whiteblue,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "PortSaid, Egypt",
                      style: TextStyle(color: Colorsmanger.Whiteblue),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: "Language",
            style: IconButton.styleFrom(backgroundColor: Colorsmanger.White),
            onPressed: localeProvider.toggleLocale,
            icon: Text(
              localeProvider.isArabic ? "EN" : "AR",
              style: const TextStyle(
                color: Colorsmanger.darkblue,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: AppLocalizations.of(context)!.logout,
            style: IconButton.styleFrom(backgroundColor: Colorsmanger.White),
            onPressed: () async {
              await FirebaseServices.logout();
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, RoutesManager.Logins);
            },
            icon: const Icon(Icons.logout, color: Colorsmanger.darkblue),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Colorsmanger.darkblue,
      ),
    );
  }
}
