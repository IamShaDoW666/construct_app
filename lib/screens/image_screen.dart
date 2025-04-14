import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:digicon/services/api_service.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> handleUpload() async {
    if (_image != null) {
      try {
        await ApiService.uploadImage(_image!.path);        
        snackBar(title: "Image uploaded successfully", context);
      } catch (e) {
        print("Error uploading image: $e");
        snackBar(title: "Error uploading image", context);
      }
      print("Image uploaded: ${_image!.path}");
    } else {
      snackBar(title: "Please select an image to upload", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Picker")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null ? Image.file(_image!) : Text('No image selected.'),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: Text('Take Photo'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: Text('Pick from Gallery'),
                ),
                _image != null
                    ? ElevatedButton(
                      onPressed: handleUpload,
                      child: Text('Upload Image'),
                    )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
