import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AuthScreenLayout extends StatelessWidget {
  const AuthScreenLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2A2520), Color(0xFF0A0A0A)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 48,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      tooltip: 'Back',
                    ),
                    const SizedBox(height: 36),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.goldLight, AppColors.gold],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.layers,
                        color: AppColors.navyDark,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: Colors.white.withValues(alpha: .72),
                      ),
                    ),
                    const SizedBox(height: 32),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    obscureText: isPassword,
    keyboardType: isPassword
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
    textInputAction: textInputAction,
    autocorrect: false,
    enableSuggestions: !isPassword,
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter your $label.';
      }
      if (label == 'email' && !value.contains('@')) {
        return 'Enter a valid email address.';
      }
      if (label == 'password' && value.length < 6) {
        return 'Password must be at least 6 characters.';
      }
      return null;
    },
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label[0].toUpperCase() + label.substring(1),
      labelStyle: TextStyle(color: Colors.white.withValues(alpha: .7)),
      filled: true,
      fillColor: Colors.white.withValues(alpha: .09),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: .2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: .2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.gold, width: 2),
      ),
    ),
  );
}

String firebaseErrorMessage(Object error) {
  final text = error.toString();
  if (text.contains('invalid-credential') || text.contains('wrong-password')) {
    return 'The email or password is incorrect.';
  }
  if (text.contains('email-already-in-use')) {
    return 'An account already exists for this email.';
  }
  if (text.contains('weak-password')) {
    return 'Please choose a stronger password.';
  }
  return 'We could not complete that request. Please try again.';
}
