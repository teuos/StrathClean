import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

const _brandTeal = Color.fromARGB(255, 58, 181, 183);
const _brandBlue = Color(0xFF2E6FD8);

const _brandGradient = LinearGradient(
  colors: [Color.fromARGB(255, 241, 154, 229), _brandBlue],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const _cornerRadius = BorderRadius.all(Radius.circular(12));

void main() {
  runApp(const StrathCleanApp());
}

class StrathCleanApp extends StatelessWidget {
  const StrathCleanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StrathClean',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _brandTeal),
      ),
      home: const LoginPage(),
    );
  }
}

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
  // "Create an account" at 1/3 of the screen height.
  static const double _titleHeight = 42;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    // TODO: hook up sign-up / login logic here.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Continuing with $email')),
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
    final password = value?.trim() ?? '';
    if (password.isEmpty) return 'Please enter your password';
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
    final middleGap =
        (screenHeight / 3 - screenHeight / 5 - _titleHeight).clamp(16.0, double.infinity);

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
                const SizedBox(height: 4),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: _validateEmail,
                  decoration: const InputDecoration(
                    hintText: 'email@strath.ac.uk',
                    enabledBorder: GradientOutlineInputBorder(
                      gradient: _brandGradient,
                      width: 1.5,
                    ),
                    focusedBorder: GradientOutlineInputBorder(
                      gradient: _brandGradient,
                      width: 2.5,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: _cornerRadius,
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: _cornerRadius,
                      borderSide: BorderSide(color: Colors.red, width: 2.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: _validatePassword,
                  decoration: const InputDecoration(
                    hintText: 'password',
                    enabledBorder: GradientOutlineInputBorder(
                      gradient: _brandGradient,
                      width: 1.5,
                    ),
                    focusedBorder: GradientOutlineInputBorder(
                      gradient: _brandGradient,
                      width: 2.5,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: _cornerRadius,
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: _cornerRadius,
                      borderSide: BorderSide(color: Colors.red, width: 2.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // The gradient is painted behind the button; the button itself
                // is transparent so it shows through (ripple still works).
                DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: _brandGradient,
                    borderRadius: _cornerRadius,
                  ),
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: _cornerRadius,
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

/// An outline input border that strokes its outline with a [Gradient]
/// instead of a solid colour. Use it for `enabledBorder` / `focusedBorder`.
class GradientOutlineInputBorder extends OutlineInputBorder {
  const GradientOutlineInputBorder({
    required this.gradient,
    this.width = 1.5,
    super.borderRadius = _cornerRadius,
  }) : super(borderSide: const BorderSide(width: 0));

  final Gradient gradient;
  final double width;

  @override
  GradientOutlineInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
  }) {
    return GradientOutlineInputBorder(
      gradient: gradient,
      width: borderSide?.width ?? width,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  // Smoothly animate between two gradient borders (e.g. unfocused -> focused).
  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is GradientOutlineInputBorder) {
      return GradientOutlineInputBorder(
        gradient: Gradient.lerp(a.gradient, gradient, t)!,
        width: lerpDouble(a.width, width, t)!,
        borderRadius: BorderRadius.lerp(a.borderRadius, borderRadius, t)!,
      );
    }
    if (a != null) return t < 0.5 ? a : this;
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is GradientOutlineInputBorder) {
      return GradientOutlineInputBorder(
        gradient: Gradient.lerp(gradient, b.gradient, t)!,
        width: lerpDouble(width, b.width, t)!,
        borderRadius: BorderRadius.lerp(borderRadius, b.borderRadius, t)!,
      );
    }
    if (b != null) return t < 0.5 ? this : b;
    return super.lerpTo(b, t);
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final outline = borderRadius.toRRect(rect).deflate(width / 2);
    canvas.drawRRect(outline, paint);
  }

  @override
  bool operator ==(Object other) =>
      other is GradientOutlineInputBorder &&
      other.gradient == gradient &&
      other.width == width &&
      other.borderRadius == borderRadius;

  @override
  int get hashCode => Object.hash(gradient, width, borderRadius);
}