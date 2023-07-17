// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, unused_element, no_leading_underscores_for_local_identifiers, avoid_print, sort_child_properties_last, use_build_context_synchronously

import 'package:ecndec/view/verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/registermodel.dart';
import 'login.dart';
import 'package:velocity_x/velocity_x.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _lastname = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confpasswordController = TextEditingController();

  final RegisterViewModel _registerVM = RegisterViewModel();

  bool obsCheck = false;

  bool _isLoggingIn = false;
  bool _isPasswordVisible = false;
  String errMsg = "";
  bool _isSigningUp = false;

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

  String _validatename(String value) {
    if (value.isEmpty) {
      return 'Please enter a name';
    }
    if (value.length < 3) {
      return 'Name should be valid';
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

        Navigator.push(context,
            MaterialPageRoute(builder: (ctx) => EmailVerificationScreen()));
        print('Email: $email');
        print('Password: $password');
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 200,
                      width: 200,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "First Name",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {}
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {}
                            return null;
                          },
                          controller: _name,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.white),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),
                              fillColor: Colors.white.withOpacity(0.2),
                              hintText: "First Name",
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
                      ),
                      SizedBox(
                        height: height / 34,
                      ),
                      Text(
                        "last Name",
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
                        controller: _lastname,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.white),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            fillColor: Colors.white.withOpacity(0.2),
                            hintText: "Last Name ",
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
                        height: height / 34,
                      ),
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
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
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
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
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
                        height: height / 32,
                      ),
                      Text(
                        "Confirm Password",
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
                        controller: _confpasswordController,
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
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
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
                    ],
                  ).pSymmetric(h: 20),
                  SizedBox(
                    height: height / 20,
                  ),
                  InkWell(
                    splashColor: Colors.white,
                    onTap: _isSigningUp
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isSigningUp = true;
                              });
                              // call Firebase function to sign up user
                              bool isRegistered = false;
                              isRegistered = await _registerVM.register(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                  _name.text.trim());
                              if (isRegistered) {
                                var userId =
                                    FirebaseAuth.instance.currentUser!.uid;
                                await FirebaseFirestore.instance
                                    .collection("UsersData")
                                    .doc(userId)
                                    .set({
                                  "First Name": _name.text.trim(),
                                  "Email": _emailController.text.trim(),
                                });

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            EmailVerificationScreen()),
                                    (Route<dynamic> route) => false);
                              } else {
                                setState(() {
                                  _isSigningUp = false;
                                  errMsg = _registerVM.message;
                                });
                              }
                            }
                          },
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
                      child: _isSigningUp
                          ? const CircularProgressIndicator().centered()
                          : const Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ).centered(),
                    ),
                  ),
                  SizedBox(
                    height: height / 42,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Already have an Account? ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign in',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
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
                  SizedBox(
                    height: height / 35,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String title;
  final VoidCallback onaction;
  const MyButton({
    super.key,
    required this.title,
    required this.onaction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.white,
      onTap: onaction,
      child: Container(
        height: 40,
        width: 300,
        child: Center(
            child: Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.white),
        )),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(width: 1, color: Colors.white),
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;
  final double fontsize;
  final FontWeight? fontWeight;
  final Color? color;
  const CustomText(
      {super.key,
      required this.fontsize,
      this.fontWeight,
      required this.text,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          TextStyle(fontSize: fontsize, fontWeight: fontWeight, color: color),
    );
  }
}
