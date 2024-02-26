import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatelessWidget {
  final Function(Uint8List) onImageSelected;
  final Uint8List? initialImage;

  const PickImage({
    required this.onImageSelected,
    this.initialImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (initialImage != null)
            Image.memory(
              initialImage!,
              height: 200,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _pickImageFromGallery(context),
                child: Text('From Gallery'),
              ),
              ElevatedButton(
                onPressed: () => _pickImageFromCamera(context),
                child: Text('From Camera'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to pick an image from the camera
  void _pickImageFromCamera(BuildContext context) async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      Uint8List bytes = await imageFile.readAsBytes();
      onImageSelected(bytes);
      Navigator.pop(context);
    }
  }

  // Function to pick an image from the gallery
  void _pickImageFromGallery(BuildContext context) async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      Uint8List bytes = await imageFile.readAsBytes();
      onImageSelected(bytes);
      Navigator.pop(context);
    }
  }
}


// // Function to pick an image from the camera
// Future<void> _pickImageFromCamera() async {
//   final pickedImage = await ImagePicker().pickImage(
//     source: ImageSource.camera,
//   );
//   if (pickedImage != null) {
//     setState(() {
//       _image = File(pickedImage.path).readAsBytesSync();
//     });
//   }
// }

// // Function to pick an image from the gallery
// Future<void> _pickImageFromGallery() async {
//   final pickedImage = await ImagePicker().pickImage(
//     source: ImageSource.gallery,
//   );
//   if (pickedImage != null) {
//     setState(() {
//       _image = File(pickedImage.path).readAsBytesSync();
//     });
//   }
// }
