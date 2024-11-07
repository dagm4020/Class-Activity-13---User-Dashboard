import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  final AuthService authService;

  ProfileScreen({Key? key, required this.authService}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();

  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _displayNameController.text = _currentUser?.displayName ?? '';
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _currentUser!.updatePassword(_newPasswordController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password updated successfully'),
          backgroundColor: Colors.green,
        ));
        _newPasswordController.clear();
      } on FirebaseAuthException catch (e) {
        String message = '';
        if (e.code == 'requires-recent-login') {
          message = 'Please re-authenticate to change your password.';
          _showReauthenticateDialog();
        } else if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else {
          message = 'An error occurred. Please try again.';
        }
        if (message.isNotEmpty &&
            message != 'Please re-authenticate to change your password.') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An unexpected error occurred.'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  void _logout() async {
    try {
      await widget.authService.signOut();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Logout failed: ${e.toString()}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _showReauthenticateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _passwordController =
            TextEditingController();
        final _formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: Text('Re-authenticate'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Current Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your current password';
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
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  await _reauthenticate(_passwordController.text.trim());
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _reauthenticate(String currentPassword) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: _currentUser!.email!,
        password: currentPassword,
      );
      await _currentUser!.reauthenticateWithCredential(credential);
      await _currentUser!.updatePassword(_newPasswordController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password updated successfully'),
        backgroundColor: Colors.green,
      ));
      _newPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'wrong-password') {
        message = 'Incorrect password. Please try again.';
      } else {
        message = 'Re-authentication failed. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An unexpected error occurred during re-authentication.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _updateDisplayName() async {
    String displayName = _displayNameController.text.trim();
    if (displayName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Display name cannot be empty.'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    try {
      await _currentUser!.updateDisplayName(displayName);
      await _currentUser!.reload();
      _currentUser = _auth.currentUser;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Display name updated successfully.'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update display name: ${e.toString()}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    String userEmail = _currentUser?.email ?? 'No Email';

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          TextButton(
            onPressed: _logout,
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(userEmail),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Display Name'),
              subtitle: TextFormField(
                controller: _displayNameController,
                decoration: InputDecoration(
                  hintText: 'Enter your display name',
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateDisplayName,
              child: Text('Update Display Name'),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Change Password',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 6) {
                        return 'Password should be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _changePassword,
                    child: Text('Update Password'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
