
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Core/ColorsManger/Colorsmanger.dart';
import '../../../../Models/UserModel (Operation Manager).dart';
import '../../../../l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController _searchcontroler;
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _searchcontroler = TextEditingController();
//    _loadingCurrentUser();
  }

  // Future<void> _loadingCurrentUser() async {
  //   currentUser =
  //   await FirebaseServices.getUserById(FirebaseAuth.instance.currentUser!.uid);
  //
  //   if (!mounted) return;
  //   setState(() {});
  // }

  @override
  void dispose() {
    _searchcontroler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  //  final localeProvider = context.watch<LocaleProvider>();
    //final viewModel = context.watch<HomeViewModel>();

    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colorsmanger.bg,
        body: Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20.r)),
                      color: Colorsmanger.darkblue,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),

                                Container(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .welcome_message!,
                                    style: GoogleFonts.dmSerifDisplay(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colorsmanger.Whiteblue,
                                    ),

                                  ),
                                ),
                                Text(
                                  currentUser!.name,
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colorsmanger.offwhite,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Colorsmanger.Whiteblue),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Cairo, Egypt',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Colorsmanger.Whiteblue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),

                  ),
                ],
              ),
            ]
        ),
      ),
    );
  }
  }