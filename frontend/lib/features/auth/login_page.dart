import 'package:flutter/material.dart';

import 'package:strath_clean/theme/app_colors.dart';
import 'package:strath_clean/widgets/gradient_outline_input_border.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Approximate line height of the 35pt title, used to land
  // "Login" at 1/3 of the screen height.
  static const double _titleHeight = 42;

  static const _fieldDecoration = InputDecoration(
    enabledBorder: GradientOutlineInputBorder(
      gradient: brandGradient,
      width: 1.5,
    ),
    focusedBorder: GradientOutlineInputBorder(
      gradient: brandGradient,
      width: 2.5,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: cornerRadius,
      borderSide: BorderSide(color: Colors.red, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: cornerRadius,
      borderSide: BorderSide(color: Colors.red, width: 2.5),
    ),
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    // TODO: hook up login logic here.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logging in as $email')),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Please enter your email';
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(email)) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Use the full screen height (minus status bar / home indicator) so the
    // layout doesn't jump when the keyboard opens.
    final media = MediaQuery.of(context);
    final screenHeight =
        media.size.height - media.padding.top - media.padding.bottom;

    final topGap = screenHeight / 5;
    final middleGap = (screenHeight / 3 - screenHeight / 5 - _titleHeight)
        .clamp(16.0, double.infinity);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: topGap),
                const Text(
                  'StrathClean',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
                SizedBox(height: middleGap),
                const Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                  decoration: _fieldDecoration.copyWith(
                    hintText: 'email@strath.ac.uk',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: _validatePassword,
                  decoration: _fieldDecoration.copyWith(
                    hintText: 'password',
                  ),
                ),
                const SizedBox(height: 16),
                // The gradient is painted behind the button; the button itself
                // is transparent so it shows through (ripple still works).
                DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: brandGradient,
                    borderRadius: cornerRadius,
                  ),
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: cornerRadius,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}