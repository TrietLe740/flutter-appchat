// import 'package:appchat/screens/chat_screen.dart';
import 'package:appchat/App.dart';
import 'package:appchat/stores/AuthManager.dart';
import 'package:appchat/utils/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatefulWidget {
  static const id = 'SignIn';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  AuthScreen({Key? key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;

  final Map<String, String> _authData = {
    'email': '',
    'displayName': '',
    'password': '',
  };
  final _isSubmitting = ValueNotifier<bool>(false);
  final _passwordController = TextEditingController();

  Future _checkSession(context) async {
    final user = await AuthManager.currentUser();
    if (user != null) {
      Navigator.of(context).pushReplacementNamed(App.id);
    }
  }

  Future<void> _submit(context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    _isSubmitting.value = true;
    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        final user = await AuthManager.signIn(
          email: _authData['email']!,
          password: _authData['password']!,
        );
        if (user != null) {
          Navigator.of(context).pushReplacementNamed(App.id);
        }
      } else {
        // Sign user up
        final user = await AuthManager.signUp(
          email: _authData['email']!,
          displayName: _authData['displayName']!,
          password: _authData['password']!,
        );
        if (user != null) {
          Navigator.of(context).pushReplacementNamed(App.id);
        }
      }
    } on FirebaseAuthException catch (error) {
      print(error.code);
      switch (error.code) {
        case 'invalid-email':
          showErrorDialog(context, 'Please enter a valid email.');
          break;
        case 'user-not-found':
          showErrorDialog(context, 'User not found.');
          break;
        case 'user-disabled':
          showErrorDialog(context, 'This user has been disabled.');
          break;
        case 'wrong-password':
          showErrorDialog(context, 'Wrong password');
          break;
        case 'email-already-in-use':
          showErrorDialog(context, 'Email already in use.');
          break;
        default:
          showErrorDialog(context, error.code);
      }
    }

    _isSubmitting.value = false;
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkSession(context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Center(
          child: Text(
            _authMode == AuthMode.login ? 'Sign In' : 'Sign Up',
            style: const TextStyle(fontSize: 25),
          ),
        ),
      ),
      body: Center(
        child: Form(key: _formKey, child: buildFormSignIn(context)),
      ),
    );
  }

  Widget buildFormSignIn(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildEmailField(),
          const SizedBox(height: 8.0),
          if (_authMode == AuthMode.signup) _buildDisplayNameField(),
          _buildPasswordField(),
          if (_authMode == AuthMode.signup) _buildPasswordConfirmField(),
          if (_authMode == AuthMode.signup) const SizedBox(height: 8.0),
          const SizedBox(height: 24.0),
          _buildSubmitButton(context),
          // TextButton(
          //   onPressed: () {
          //     _submit(context);
          //   },
          //   child: const Text(
          //     'Sign in',
          //     style: TextStyle(color: Colors.blue),
          //   ),
          // ),
          const SizedBox(height: 20.0),
          _buildAuthModeSwitchButton(),
        ],
      ),
    );
  }

  Widget _buildAuthModeSwitchButton() {
    return Column(
      children: [
        Text(
          _authMode == AuthMode.login
              ? 'Or create account'
              : 'Already have an account',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
        // const SizedBox(height: 6.0),
        TextButton(
          onPressed: _switchAuthMode,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          child: Text(_authMode == AuthMode.login ? 'Sign Up' : 'Sign In'),
        )
      ],
    );
  }

  Widget _buildSubmitButton(context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isSubmitting,
      builder: (context, isSubmitting, child) {
        if (isSubmitting) {
          return const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
        return ElevatedButton(
          onPressed: () {
            _submit(context);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            primary: Colors.black,
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
            textStyle: TextStyle(
              color: Theme.of(context).primaryTextTheme.headline6?.color,
            ),
          ),
          child: Text(_authMode == AuthMode.login ? 'Sign in' : 'Sign Up'),
        );
      },
    );
  }

  Widget _buildPasswordConfirmField() {
    return TextFormField(
      enabled: _authMode == AuthMode.signup,
      decoration: const InputDecoration(labelText: 'Confirm Password'),
      obscureText: true,
      validator: _authMode == AuthMode.signup
          ? (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match!';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Password'),
      controller: _passwordController,
      obscureText: true,
      validator: (value) {
        if (value == null || value.length < 5) {
          return 'Password is too short!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['password'] = value!;
      },
    );
  }

  Widget _buildDisplayNameField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Display Name'),
      validator: (value) {
        if (value == null) {
          return 'Is required';
        }
        return null;
      },
      onSaved: (value) {
        _authData['displayName'] = value!;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'E-Mail'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Invalid email!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['email'] = value!;
      },
    );
  }
}
