import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  final picker = ImagePicker();

  Future<void> uploadImageAndEncrypt() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      // User canceled image selection
      return;
    }

    File imageFile = File(pickedFile.path);

    // Create a multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://life-forever.xyz/img/enc.php'),
    );
    request.files.add(http.MultipartFile(
      'filetype',
      imageFile.readAsBytes().asStream(),
      imageFile.lengthSync(),
      filename: imageFile.path.split('/').last,
    ));

    try {
      // Send the request
      var response = await request.send();

      // Check the response status code
      if (response.statusCode == 200) {
        // Success, print the response body
        final String responseString = await response.stream.bytesToString();
        print('Image encrypted successfully');
        print('Response Body: $responseString');
        print(responseString);
        print(response.statusCode);
      } else {
        // Handle errors if any
        print('Failed to encrypt image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other exceptions if any
      print('Error occurred while encrypting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload and Encrypt'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            uploadImageAndEncrypt();
          },
          child: Text('Upload and Encrypt Image'),
        ),
      ),
    );
  }
}
