
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Core/AssetsManger/AssetsManger.dart';
import '../../../Core/Widgets/CustomTextForm.dart';
import '../../../Core/Widgets/Custom_Elvated button.dart';
import '../../../Core/Widgets/isvalidate.dart';
import '../../../Core/routesMnager/RoutesManger.dart';

class forgetPassword extends StatefulWidget {
  const forgetPassword({super.key});

  @override
  State<forgetPassword> createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<forgetPassword> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendPasswordResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset link sent to your email.'),
        ),
      );
      Navigator.pushReplacementNamed(context, RoutesManager.Logins);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Failed to send password reset email.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, RoutesManager.Logins);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Forget Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image(
                  image: AssetImage(Imagemanger.logoimage),
                  width: 136,
                  height: 150,
                ),
                const SizedBox(height: 32),
                Text(
                  'Enter your email',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'We will send you a link to reset your password.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                CustomTextForm(
                  controller: _emailController,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return 'Enter the email';
                    }
                    if (!Validator.isValidEmail(input.trim())) {
                      return "The email format isn't correct";
                    }
                    return null;
                  },
                  isObscure: false,
                  keyboardType: TextInputType.emailAddress,
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomElevatedButton(
                  text: 'Send reset link',
                  onPress: _sendPasswordResetEmail,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
