import 'package:flutter/material.dart';

import 'package:strath_clean/services/api_service.dart';
import 'package:strath_clean/services/session.dart';
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

  bool _loading = false;
  bool _obscurePassword = true;

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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final userId = await ApiService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (userId != null) {
        Session.userId = userId; // needed later, e.g. to create issues
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showError('Incorrect email or password');
      }
    } catch (e) {
      debugPrint('Login error: $e');
      if (mounted) _showError("Couldn't reach the server");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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
                  enabled: !_loading,
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
                  enabled: !_loading,
                  obscureText: _obscurePassword,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _loading ? null : _submit(),
                  validator: _validatePassword,
                  decoration: _fieldDecoration.copyWith(
                    hintText: 'password',
                    suffixIcon: IconButton(
                      tooltip:
                          _obscurePassword ? 'Show password' : 'Hide password',
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
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
                    onPressed: _loading ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      disabledBackgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: cornerRadius,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
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