import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main_shell.dart';
import 'auth_screen_base.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.firebaseIsReady});
  static const routeName = '/sign-up';
  final bool firebaseIsReady;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _isLoading = false;
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!widget.firebaseIsReady) {
      _show(
        'Firebase is not configured yet. Add your FlutterFire configuration files to enable sign-up.',
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _email.text.trim(),
            password: _password.text,
          );
      await credential.user?.updateDisplayName(_name.text.trim());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
            'name': _name.text.trim(),
            'email': _email.text.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          });
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
    title: 'Create an account',
    subtitle: 'Start keeping your coin stories in one place.',
    child: Form(
      key: _formKey,
      child: Column(
        children: [
          AuthTextField(
            controller: _name,
            label: 'name',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
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
              onPressed: _isLoading ? null : _signUp,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create account'),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
