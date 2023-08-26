import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt_package;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(ImageCryptoApp());
}

class ImageCryptoApp extends StatefulWidget {
  @override
  _ImageCryptoAppState createState() => _ImageCryptoAppState();
}

class _ImageCryptoAppState extends State<ImageCryptoApp> {
  final picker = ImagePicker();
  final encrypt_package.Key _key = encrypt_package.Key.fromLength(32);

  XFile? _pickedImage;
  Uint8List? _originalImageData;
  Uint8List? _encryptedImageData;
  Uint8List? _decryptedImageData;

  Future<void> pickImageFromGallery() async {
    _pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (_pickedImage != null) {
      setState(() {
        _originalImageData = null;
        _encryptedImageData = null;
        _decryptedImageData = null;
      });
    }
  }

  Future<void> _encryptImage(Uint8List data) async {
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
    final encrypted = encrypter.encryptBytes(data, iv: iv);

    setState(() {
      _encryptedImageData = encrypted.bytes;
    });
  }

  Future<void> _decryptImage(Uint8List encryptedData) async {
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
    final decrypted = encrypter.decrypt(Encrypted(encryptedData), iv: iv);

    setState(() {
      _decryptedImageData = decrypted as Uint8List?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Image Encryption & Decryption'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: pickImageFromGallery,
                child: Text('Pick Image from Gallery'),
              ),
              SizedBox(height: 20),
              if (_pickedImage != null)
                ElevatedButton(
                  onPressed: () async {
                    final imageData = await _pickedImage!.readAsBytes();
                    setState(() {
                      _originalImageData = imageData;
                    });
                    await _encryptImage(imageData);
                  },
                  child: Text('Encrypt Image'),
                ),
              SizedBox(height: 20),
              if (_encryptedImageData != null)
                Column(
                  children: [
                    Text('Encrypted Image Preview:'),
                    Image.memory(Uint8List.fromList(_encryptedImageData!)),
                  ],
                ),
              SizedBox(height: 20),
              if (_decryptedImageData != null)
                Column(
                  children: [
                    Text('Decrypted Image Preview:'),
                    Image.memory(Uint8List.fromList(_decryptedImageData!)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
