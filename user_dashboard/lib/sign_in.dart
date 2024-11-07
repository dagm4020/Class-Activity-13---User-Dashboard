import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  final AuthService authService;
  final VoidCallback? onAuthSuccess;

  SignIn({Key? key, required this.authService, this.onAuthSuccess})
      : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await widget.authService.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sign in successful!'),
          backgroundColor: Colors.green,
        ));

        _formKey.currentState!.reset();
      } on FirebaseAuthException catch (e) {
        String message = '';
        switch (e.code) {
          case 'user-not-found':
            message = 'No user found for that email.';
            break;
          case 'wrong-password':
            message = 'Wrong password provided for that user.';
            break;
          case 'invalid-email':
            message = 'The email address is badly formatted.';
            break;
          default:
            message = 'An error occurred. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sign in failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showPasswordResetDialog() {
    final TextEditingController _resetEmailController = TextEditingController();
    final _resetFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reset Password'),
          content: Form(
            key: _resetFormKey,
            child: TextFormField(
              controller: _resetEmailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_resetFormKey.currentState!.validate()) {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: _resetEmailController.text.trim(),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Password reset email sent.'),
                      backgroundColor: Colors.green,
                    ));
                    Navigator.of(context).pop();
                  } on FirebaseAuthException catch (e) {
                    String message = '';
                    switch (e.code) {
                      case 'user-not-found':
                        message = 'No user found for that email.';
                        break;
                      case 'invalid-email':
                        message = 'The email address is badly formatted.';
                        break;
                      default:
                        message = 'An error occurred. Please try again.';
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(message),
                      backgroundColor: Colors.red,
                    ));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('An unexpected error occurred.'),
                      backgroundColor: Colors.red,
                    ));
                  }
                }
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Sign In',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      child: Text('Sign In'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
