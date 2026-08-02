
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Core/AssetsManger/AssetsManger.dart';
import '../../../Core/ColorsManger/Colorsmanger.dart';
import '../../../Core/Widgets/CustomTextForm.dart';
import '../../../Core/Widgets/Custom_Elvated button.dart';
import '../../../Core/Widgets/Custom_Text_Button.dart';
import '../../../Core/Widgets/isvalidate.dart';
import '../../../Core/routesMnager/RoutesManger.dart';
import '../../../Services/FirebaseServices.dart';
import '../../../l10n/app_localizations.dart';
import 'loginviewmodel.dart';

class Login extends StatefulWidget {

  const Login({super.key});

  State<Login> createState() => _LoginState();

}
///Yes — the controllers are the middle layer (bridge) between
/// your UI (TextFields) and your logic (Firebase login method).
///They hold the user’s input and let your logic read it easily.
///Controllers are part of the UI layer
///✅ They can pass data to backend or show backend data
///✅ They act as a bridge, but they “live” on the UI side, not the backend side
class _LoginState extends State<Login> {
  final viewModel=LoginViewModel();
  bool securePassword = true;
  late TextEditingController _namecontroller; // this
  late TextEditingController _emailcontroller;
  late TextEditingController _passwordcontroller;
  late TextEditingController _repasswordcontroller; //
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void initState() {
    _emailcontroller = TextEditingController();
    _passwordcontroller = TextEditingController();
    super.initState();
  }

  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 21, vertical: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image(image: AssetImage(Imagemanger.logoimage),
                    width: 136,
                    height: 150,),
                  SizedBox(height: 24,),
                  CustomTextForm(
                    controller: _emailcontroller,
                    validator: (input) {
                      if (input == null || input
                          .trim()
                          .isEmpty) {
                        return "enter the email :";
                      }
                      if (!Validator.isValidEmail(input)) {
                        return "the email format isn't coreect ";
                      }
                    },

                    isObscure: false,
                    keyboardType: TextInputType.emailAddress,
                    labelText: AppLocalizations.of(context)!.email,
                    prefixIcon: Icons.email,
                  ),
                  SizedBox(height: 16,),
                  CustomTextForm(
                    controller: _passwordcontroller,
                    validator: (input) {
                      if (input == null || input.trim().isEmpty) {
                        return "the password is empty  :";
                      }
                      if (input.length < 8) {
                        return " the password should be at least 6";
                      }
                      return null;
                    },
                    isObscure: securePassword,
                    labelText: AppLocalizations.of(context)!.password,
                    prefixIcon: Icons.lock,
                    suffixIcon: IconButton(onPressed: () {
                      securePassword = !securePassword;
                      setState(() {

                      });
                    },
                        icon: Icon(securePassword ? Icons.visibility_off : Icons
                            .visibility)),
                    keyboardType: TextInputType.visiblePassword,),
                  SizedBox(height: 16,),
                  SizedBox(height: 16.h),
                  CustomTextButton(
                    texts: "Forgot Password",
                    onTap: () {
                      Navigator.pushReplacementNamed(context, RoutesManager.ForgetPassword);
                    },
                  ),
                  SizedBox(height: 24.h),
                  CustomElevatedButton(
                      text: AppLocalizations.of(context)!.login,
                      onPress: (){
                        viewModel.Login(context: context, email: _emailcontroller.text, password: _passwordcontroller.text);
                      }
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.dont_have_account,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodySmall,),
                      CustomTextButton(
                        texts: AppLocalizations.of(context)!.create_account,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            RoutesManager.Rigesters,
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colorsmanger.Blue,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                      ),
                      Text("or"),
                      Expanded(
                        child: Divider(
                          color: Colorsmanger.Blue,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  OutlinedButton(

                    style: OutlinedButton.styleFrom(
                        padding: REdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colorsmanger.Blue),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r)
                        )
                    ),
                    onPressed: () async{
                   //   var user=await FirebaseServices.signInWithGoogle();
                     // print(user.user?.displayName);
                     // print(user.user?.email);

                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Imagemanger.Googleicon),
                        SizedBox(width: 4.w),
                        Text("Google",
                          style: GoogleFonts.inter(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: Colorsmanger.Blue,


                          ),
                        ),
                      ],
                    ),
                  ),

                ]

            ),
          ),
        ),
      ),
    );
  }

}


