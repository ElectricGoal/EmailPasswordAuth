import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/models/models.dart';
import 'package:login_app/screens/screens.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);
  static MaterialPage page() {
    return MaterialPage(
      name: AppPages.resetPassPath,
      key: ValueKey(AppPages.resetPassPath),
      child: const ResetPasswordScreen(),
    );
  }

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final Color color = const Color.fromRGBO(64, 143, 77, 1);

  final TextStyle focusedStyle =
      const TextStyle(color: Colors.green, height: 1);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          child: const Icon(
            Icons.chevron_left,
            size: 35,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              headerField(),
              const SizedBox(height: 70),
              emailField(),
              const SizedBox(height: 20),
              buildSendButton(),
              const SizedBox(height: 20),
              buildLogInButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 60),
        Text(
          'Reset Password.',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: const [
            Expanded(
              child: Text(
                'Enter your email and Reset Link will be sent to your email id !',
                style: TextStyle(
                  fontSize: 18,
                  //fontWeight: FontWeight.bold,
                  //color: Colors.green[700],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget emailField() {
    return TextFormField(
      autofocus: false,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        _emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: color,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
            width: 2,
          ),
        ),
        hintText: 'Email',
        hintStyle: focusedStyle,
        prefixIcon: Icon(
          Icons.mail,
          color: Colors.green[400],
        ),
      ),
    );
  }

  Widget buildSendButton() {
    return SizedBox(
      height: 55,
      child: MaterialButton(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: const Text(
          'Send email',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }
          resetPassword();
          //Provider.of<AppStateManager>(context, listen: false).resetPass(false);
        },
      ),
    );
  }

  void resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Password Reset Email has been sent !',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              'No user found for that email.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }

  Widget buildLogInButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Provider.of<AppStateManager>(context, listen: false).resetPass(false);
      },
      child: const Text(
        'Log in',
        style: TextStyle(
          fontSize: 16,
          color: Colors.green,
        ),
      ),
    );
  }
}
