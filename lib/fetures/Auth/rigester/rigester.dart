
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoghly/fetures/Auth/rigester/rigesterViewModel.dart';

import '../../../Core/AssetsManger/AssetsManger.dart';
import '../../../Core/Widgets/CustomTextForm.dart';
import '../../../Core/Widgets/Custom_Elvated button.dart';
import '../../../Core/routesMnager/RoutesManger.dart';
import '../../../l10n/app_localizations.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}
class _RegisterState extends State<Register> {
  final viewmodel = RegisterViewModel();
  bool securePassword = true; // this
  late TextEditingController _namecontroller; // this
  late TextEditingController _emailcontroller;
  late TextEditingController _passwordcontroller;
  late TextEditingController _phonecontroller;
  late TextEditingController _repasswordcontroller; //
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void initState() {
    // TODO: implement initState
    super.initState();
    _namecontroller = TextEditingController();
    _emailcontroller = TextEditingController();
    _passwordcontroller = TextEditingController();
    _repasswordcontroller = TextEditingController();
    _phonecontroller = TextEditingController();
  } // this
  void dispose() {
    _namecontroller.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _repasswordcontroller.dispose();
    _phonecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery
        .of(context)
        .viewInsets);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, RoutesManager.Logins);
              }
          ),
          title: Text(AppLocalizations.of(context)!.register)

      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 21, vertical: 20),

        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Image(image: AssetImage(Imagemanger.logoimage,),
                  width: 136,
                  height: 150,),
                SizedBox(height: 24,),
                CustomTextForm(
                  controller: _namecontroller,
                  validator: (input) {
                    if (input == null || input
                        .trim()
                        .isEmpty) {
                      return "enter the name :";
                    }
                  },
                  isObscure: false,
                  labelText: AppLocalizations.of(context)!.name,
                  prefixIcon: Icons.person,),
                SizedBox(height: 16,),
                CustomTextForm(
                  validator: (input) {
                    if (input == null || input
                        .trim()
                        .isEmpty) {
                      return "enter the email :";
                    }
                  },
                  isObscure: false,
                  controller: _emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  labelText: AppLocalizations.of(context)!.email,
                  prefixIcon: Icons.email,
                ),

                SizedBox(height: 16,),
                CustomTextForm(
                  controller: _passwordcontroller,
                  //You call validate() inside the ElevatedButton to check all user input before sending it to your backend or Firebase.
                  // It’s the step that ensures all input conditions are correct.
                  validator: (input) {
                    if (input == null || input
                        .trim()
                        .isEmpty) {
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
                CustomTextForm(
                  controller: _phonecontroller,
                  validator: (input) {
                    if (input == null || input
                        .trim()
                        .isEmpty) {
                      return "Phone number is required";
                    }

                    if (input.length < 11) {
                      return "Phone number must be 11 digits";
                    }

                    if (!RegExp(r'^[0-9]+$').hasMatch(input)) {
                      return "Phone must contain numbers only";
                    }

                    return null;
                  },

                  labelText: AppLocalizations.of(context)!.phone,
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10,),
                    CustomElevatedButton(
                        text: AppLocalizations.of(context)!.login,
                        onPress: () {
                          viewmodel.Register(context:
                          context,
                              name: _namecontroller.text,
                              email: _emailcontroller.text,
                              password: _passwordcontroller.text,
                              phone: _phonecontroller.text);
                        }),

                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }


}
