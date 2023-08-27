import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';

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
