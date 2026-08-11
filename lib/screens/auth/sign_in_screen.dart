import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main_shell.dart';
import 'auth_screen_base.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.firebaseIsReady});
  static const routeName = '/sign-in';
  final bool firebaseIsReady;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    if (!widget.firebaseIsReady) {
      _show(
        'Firebase is not configured yet. Add your FlutterFire configuration files to enable sign-in.',
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text,
      );
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(MainShell.routeName, (_) => false);
      }
    } on FirebaseAuthException catch (e) {
      _show(firebaseErrorMessage(e.code));
    } catch (e) {
      _show(firebaseErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _show(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) => AuthScreenLayout(
    title: 'Welcome back',
    subtitle: 'Sign in to continue your collecting journey.',
    child: Form(
      key: _formKey,
      child: Column(
        children: [
          AuthTextField(
            controller: _email,
            label: 'email',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          AuthTextField(
            controller: _password,
            label: 'password',
            isPassword: true,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isLoading ? null : _signIn,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Sign in'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(SignUpScreen.routeName),
            child: const Text("Don't have an account? Sign up"),
          ),
        ],
      ),
    ),
  );
}
