import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _pickedImage;
  File? _image;
  File? _blurredImage;
  bool _isBlurring = false;

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
        _image = _pickedImage; // Store the picked image in _image
        _blurredImage = null; // Clear any previous blurred image
      });
    }
  }

  void _applyBlur() async {
    if (_image != null) {
      setState(() {
        _isBlurring = true;
      });
      final image = img.decodeImage(File(_image!.path).readAsBytesSync())!;
      final blurredImage =
          img.copyResize(image, height: 200); // Resize for better performance
      img.gaussianBlur(blurredImage, radius: 60);

      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/blurred_image.png');
      tempFile.writeAsBytesSync(img.encodePng(blurredImage));

      await Future.delayed(Duration(seconds: 3)); // Wait for 3 seconds

      setState(() {
        _isBlurring = false; // Hide the indicator
        _blurredImage = tempFile;
      });
    }
  }

  void _clearImage() {
    setState(() {
      _image = _pickedImage;
      _blurredImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Manipulation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                if (_blurredImage != null)
                  Image.file(
                    _blurredImage!,
                    height: 200,
                  ),
                if (_image != null && _blurredImage == null)
                  Image.file(
                    _image!,
                    height: 200,
                  ),
                if (_isBlurring) CircularProgressIndicator(),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 50),
            _image != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: _applyBlur,
                        child: Text('Blur Image'),
                      ),
                      ElevatedButton(
                        onPressed: _clearImage,
                        child: Text('Clear Image'),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class EncryptionDecryptionImagePage extends StatefulWidget {
  @override
  State<EncryptionDecryptionImagePage> createState() =>
      _EncryptionDecryptionImagePageState();
}

class _EncryptionDecryptionImagePageState
    extends State<EncryptionDecryptionImagePage> {
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  File? _image;
  File? _blurredImage;
  bool _isBlurring = false;

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
        _image = _pickedImage; // Store the picked image in _image
        _blurredImage = null; // Clear any previous blurred image
      });
    }
  }

  void _applyBlur() async {
    if (_image != null) {
      setState(() {
        _isBlurring = true;
      });
      final image = img.decodeImage(File(_image!.path).readAsBytesSync())!;
      final blurredImage =
          img.copyResize(image, height: 200); // Resize for better performance
      img.gaussianBlur(blurredImage, radius: 60);

      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/blurred_image.png');
      tempFile.writeAsBytesSync(img.encodePng(blurredImage));

      await Future.delayed(Duration(seconds: 3)); // Wait for 3 seconds

      setState(() {
        _isBlurring = false; // Hide the indicator
        _blurredImage = tempFile;
      });
    }
  }

  void _clearImage() {
    setState(() {
      _image = _pickedImage;
      _blurredImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      backgroundColor: Color(0xff011826), // Customize the background color
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    height: height / 10,
                    width: width / 4,
                    image: AssetImage(
                      'assets/images/logo.png',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("Decrypt your secrets. John use Dig Deep",
                    style: TextStyle(color: Colors.white)),
              ),
              Image(
                height: height / 5,
                width: width / 1,
                fit: BoxFit.contain,
                image: AssetImage('assets/images/encr.jpeg'),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff011826), // Customize the background color
                  image: DecorationImage(
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // if (_image == null)
                        //   Padding(
                        //     padding: const EdgeInsets.symmetric(horizontal: 20),
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //           color: Colors.white.withOpacity(0.3),
                        //           borderRadius: BorderRadius.circular(20)),
                        //       height: 200,
                        //       width: 200,
                        //       child: _image == null
                        //           ? Center(
                        //               child: Column(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.center,
                        //                 children: [
                        //                   IconButton(
                        //                       onPressed: _pickImage,
                        //                       icon: Icon(
                        //                         Icons.cloud_upload_rounded,
                        //                         color: Colors.white,
                        //                         size: 30,
                        //                       )),
                        //                   Text(
                        //                     "Upload File ",
                        //                     style: TextStyle(
                        //                         color: Colors.white,
                        //                         fontSize: 20),
                        //                   )
                        //                 ],
                        //               ),
                        //             )
                        //           : Stack(
                        //               alignment: Alignment.center,
                        //               children: [
                        //                 if (_blurredImage != null)
                        //                   Image.file(
                        //                     _blurredImage!,
                        //                     height: 200,
                        //                   ),
                        //                 if (_image != null &&
                        //                     _blurredImage == null)
                        //                   if (_isBlurring)
                        //                     CircularProgressIndicator(),
                        //               ],
                        //             ),
                        //     ),
                        //   ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_blurredImage != null)
                              Image.file(
                                _blurredImage!,
                                height: 200,
                              ),
                            if (_image != null && _blurredImage == null)
                              Image.file(
                                _image!,
                                height: 200,
                              ),
                            if (_isBlurring) CircularProgressIndicator(),
                          ],
                        ),
                        SizedBox(height: 20),
                        if (_image == null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20)),
                              height: 200,
                              width: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: _pickImage,
                                        icon: Icon(
                                          Icons.cloud_upload_rounded,
                                          color: Colors.white,
                                          size: 30,
                                        )),
                                    Text(
                                      "Upload File ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 50),
                        _image != null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _applyBlur();
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
                                            colors: [
                                              Color(0xfffda93e),
                                              Color(0xfff75230)
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: const Text(
                                            'Encrypt',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _clearImage();
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
                                            colors: [
                                              Color(0xfffda93e),
                                              Color(0xfff75230)
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: const Text(
                                            'Decrypt',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Container(),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "CRC 16",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "CRC 16",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "CRC 32",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "MD 2",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "MD 4",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "SHA 128",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "SHA 256",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "SHA 512",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "SHAKE 128",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "SHAKE 256",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_image != null) {
                                    Share.shareFiles([_image!.path]);
                                  }
                                },
                                child: Text('Share Image'),
                              )

                              // InkWell(
                              //   onTap: () {},
                              //   child: Card(
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(15),
                              //     ),
                              //     elevation: 10,
                              //     child: Container(
                              //       height: 50,
                              //       width: 150,
                              //       decoration: BoxDecoration(
                              //         gradient: LinearGradient(
                              //           begin: Alignment.topCenter,
                              //           end: Alignment.bottomCenter,
                              //           colors: [
                              //             Color(0xfffda93e),
                              //             Color(0xfff75230)
                              //           ],
                              //         ),
                              //         borderRadius: BorderRadius.circular(10),
                              //       ),
                              //       child: Center(
                              //         child: const Text(
                              //           'Decrypt',
                              //           style: TextStyle(
                              //               color: Colors.white, fontSize: 18),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
