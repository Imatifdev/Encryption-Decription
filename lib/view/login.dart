// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, unused_element, no_leading_underscores_for_local_identifiers, avoid_print, use_build_context_synchronously

import 'package:ecndec/view/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../model/loginmodel.dart';
import 'forgot.dart';
import 'home.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool obsCheck = false;

  bool _isLoggingIn = false;
  bool _isPasswordVisible = false;

  final LoginViewModel _loginVM = LoginViewModel();

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return "null";
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return "null";
  }

  @override
  Widget build(BuildContext context) {
    void _submitForm() {
      if (_formKey.currentState!.validate()) {
        // Perform login or further actions
        String email = _emailController.text;
        String password = _passwordController.text;
        // Process the login credentials
        print('Email: $email');
        print('Password: $password');
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => Home()));
      }
    }

    var height = MediaQuery.of(context).size.height;

    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xff011826), // Customize the background color
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 200,
                        width: 200,
                      ),
                    ).centered(),
                    Text(
                      "Email",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {}
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {}
                        return null;
                      },
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.white),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          fillColor: Colors.white.withOpacity(0.2),
                          hintText: "Email Address",
                          hintStyle: TextStyle(color: Colors.white),
                          alignLabelWithHint: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true),
                    ),
                    SizedBox(
                      height: height / 32,
                    ),
                    Text(
                      "Password",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {}
                        if (value.length < 6) {}
                        return null;
                      },
                      obscureText: _isPasswordVisible,
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          errorStyle: TextStyle(color: Colors.white),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          fillColor: Colors.white.withOpacity(0.2),
                          hintText: "Password ",
                          hintStyle: TextStyle(color: Colors.white),
                          alignLabelWithHint: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => ForgitPassword()));
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Colors.orange,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    )
                  ],
                ).pSymmetric(h: 20),
                SizedBox(
                  height: height / 20,
                ),
                InkWell(
                  splashColor: Colors.white,
                  onTap: _isLoggingIn
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            if (_emailController.text.isEmpty &&
                                _passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  "Please fill all details",
                                  style: TextStyle(color: Colors.white),
                                ),
                                duration: const Duration(seconds: 1),
                                backgroundColor: Colors.red,
                              ));

                              return;
                            }
                            setState(() {
                              _isLoggingIn = true;
                            });
                            bool isLoggedIn = await _loginVM.login(
                                _emailController.text,
                                _passwordController.text);
                            setState(() {
                              _isLoggingIn = false;
                            });
                            if (!isLoggedIn) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  "Please a valid email address and Pass",
                                  style: TextStyle(color: Colors.white),
                                ),
                                duration: const Duration(seconds: 1),
                                backgroundColor: Colors.red,
                              ));
                            } else {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (ctx) => Home()),
                                  (Route<dynamic> route) => false);
                            }
                          }
                        },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xfffda93e), Color(0xfff75230)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _isLoggingIn
                          ? const CircularProgressIndicator().centered()
                          : const Text(
                              'Log In',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ).centered(),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 40,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Don\'t have an Account? ',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Signup',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()));
                          },
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
