// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  XFile? pickImage;
  num snabWalletBalance = 0;
  int check = 0;
  final picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Handle the selected image
      File selectedImage = File(pickedImage.path);
      // You can now use the selectedImage file for further operations
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff011826), // Customize the background color

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.5,
            image: AssetImage(
              "assets/images/logo.png",
            ), // Replace with your own image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                    width: 80,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.person_alt_circle,
                      color: Colors.white70,
                      size: 30,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
              ),
              Text(
                "Scramble your secrets,John, Use DIG DEEP ",
                style: TextStyle(color: Colors.white),
              ),
              ElevatedButton(
                onPressed: _pickImageFromGallery,
                child: Text('Pick Image'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
