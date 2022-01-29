import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_app/models/models.dart';
import 'package:provider/provider.dart';

import 'app_pages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  static MaterialPage page() {
    return MaterialPage(
      name: AppPages.loginPath,
      key: ValueKey(AppPages.loginPath),
      child: const LoginScreen(),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color color = const Color.fromRGBO(64, 143, 77, 1);

  final TextStyle focusedStyle =
      const TextStyle(color: Colors.green, height: 1);

  final TextStyle unfocusedStyle = const TextStyle(color: Colors.grey);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final _auth = FirebaseAuth.instance;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              headerField(),
              const SizedBox(height: 100),
              emailField(context),
              const SizedBox(height: 20),
              passwordField(context),
              const SizedBox(height: 30),
              buildLoginButton(context),
              const SizedBox(height: 20),
              buildSignUpButton(context),
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
          'Log in.',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: const [
            Expanded(
              child: Text(
                'Welcome back! Login with your data that you entered during registration',
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

  Widget buildLoginButton(BuildContext context) {
    return SizedBox(
      height: 55,
      child: MaterialButton(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }
          signIn(emailController.text, passwordController.text);
        },
      ),
    );
  }

  Widget buildSignUpButton(BuildContext context) {
    return SizedBox(
      height: 55,
      child: MaterialButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.green,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Text(
          'Don\'t have an account, Sign Up here',
          style: TextStyle(color: Colors.green),
        ),
        onPressed: () async {
          Provider.of<AppStateManager>(context, listen: false)
              .goToRegisterScreen();
        },
      ),
    );
  }

  Widget emailField(BuildContext context) {
    return TextFormField(
      autofocus: false,
      controller: emailController,
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
        emailController.text = value!;
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

  Widget passwordField(BuildContext context) {
    return TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      cursorColor: color,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
            width: 2,
          ),
        ),
        hintText: 'Password',
        hintStyle: focusedStyle,
        prefixIcon: Icon(
          Icons.vpn_key,
          color: Colors.green[400],
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then(
              (uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Provider.of<AppStateManager>(context, listen: false).login(),
              },
            );
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your email or password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        // ignore: avoid_print
        print(error.code);
      }
    }
  }
}
