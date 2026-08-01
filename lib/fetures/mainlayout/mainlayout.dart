
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide Create;
import 'package:shoghly/fetures/mainlayout/tabs/Home/Home.dart';
import 'package:shoghly/fetures/mainlayout/tabs/Maintenance/Maintance.dart';
import 'package:shoghly/fetures/mainlayout/tabs/Motorcycles/Motorcycles.dart';
import 'package:shoghly/fetures/mainlayout/tabs/Payments/Payments.dart';

import '../../Core/ColorsManger/Colorsmanger.dart';
import '../../l10n/app_localizations.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late final List<Widget> _tabs = [
    Home(),
    Motorcycles(),
    Payments(),
    Maintance(),
  ];

  int selectedIndex = 0;

  void _onTap(int newIndex) {
    if (newIndex == selectedIndex) return;
    setState(() {
      selectedIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: selectedIndex,
        children: _tabs,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: _onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colorsmanger.darkblue,
      unselectedItemColor: Colorsmanger.Grey,
      backgroundColor: Colorsmanger.White,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: AppLocalizations.of(context)!.dashboard,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.motorcycle),
          label: AppLocalizations.of(context)!.motorcycles,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: AppLocalizations.of(context)!.maintenance,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.monetization_on),
          label: AppLocalizations.of(context)!.payments,
        ),
      ],
    );
  }
}
