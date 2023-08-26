import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class TextEncryptionApp extends StatefulWidget {
  @override
  _TextEncryptionAppState createState() => _TextEncryptionAppState();
}

class _TextEncryptionAppState extends State<TextEncryptionApp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _inputTextController =
      TextEditingController(); // Controller for input text
  TextEditingController _encryptionKeyController =
      TextEditingController(); // Controller for encrypted key
  TextEditingController _encryptedTextController =
      TextEditingController(); // Controller for encrypted text
  TextEditingController _decryptedTextController =
      TextEditingController(); // Controller for decrypted text
  late String _encryptionKey;
  late String _encryptedText;
  late String _decryptedText;

  @override
  void initState() {
    super.initState();
    _encryptionKey = generateRandomKey();
    _encryptionKeyController.text = _encryptionKey;
  }

  @override
  void dispose() {
    _inputTextController.dispose();
    _encryptionKeyController.dispose();
    _encryptedTextController.dispose();
    _decryptedTextController.dispose();
    super.dispose();
  }

  String generateRandomKey() {
    final key = encrypt.Key.fromLength(32);
    return key.base64;
  }

  String generateRandomIV() {
    final iv = IV.fromLength(16);
    return iv.base64;
  }

  String encryptText(String text) {
    final key = encrypt.Key.fromBase64(_encryptionKey);
    final iv = IV.fromBase64(generateRandomIV());
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  String decryptText(String encryptedText, String keyBase64, String ivBase64) {
    final key = encrypt.Key.fromBase64(keyBase64);
    final iv = IV.fromBase64(ivBase64);
    final encrypter = Encrypter(AES(key));
    final encrypted = Encrypted.fromBase64(encryptedText);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }

  void _encryptText() {
    if (_formKey.currentState!.validate()) {
      final inputText = _inputTextController.text;
      final iv = generateRandomIV();
      setState(() {
        _encryptionKey = _encryptionKeyController.text;
        _encryptedText = encryptText(inputText);
        _encryptedTextController.text =
            _encryptedText; // Display encrypted text in the field
        _decryptedTextController.text = ''; // Clear the decrypted text field
      });
    }
  }

  void _decryptText() {
    final encryptedText = _encryptedTextController.text;
    final iv = generateRandomIV();
    final decryptedText = decryptText(encryptedText, _encryptionKey, iv);
    setState(() {
      _decryptedText = decryptedText;
      _decryptedTextController.text =
          _decryptedText; // Display decrypted text in the field
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text Encryption')),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _inputTextController,
                decoration: InputDecoration(labelText: 'Enter text to encrypt'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: _encryptText,
              child: Text('Encrypt'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _encryptedTextController,
                decoration: InputDecoration(labelText: 'Encrypted Text'),
                enabled: false,
              ),
            ),
            ElevatedButton(
              onPressed: _decryptText,
              child: Text('Decrypt'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _decryptedTextController,
                decoration: InputDecoration(labelText: 'Decrypted Text'),
                enabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
