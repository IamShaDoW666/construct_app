import 'dart:io';

import 'package:digicon/constants/keys.dart';
import 'package:digicon/constants/routes.dart';
import 'package:digicon/services/api_service.dart';
import 'package:digicon/services/network.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageGridPickerScreen extends StatefulWidget {
  const ImageGridPickerScreen({super.key});
  
  @override
  State<ImageGridPickerScreen> createState() => _ImageGridPickerScreenState();
}

class _ImageGridPickerScreenState extends State<ImageGridPickerScreen> {
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _referenceController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _images.add(File(picked.path));
      });
    }
  }

  Future<void> handleUpload() async {
    if (mounted) {
      if (_images.isNotEmpty) {
        try {
          await ApiService.uploadImages(_images, _referenceController.text);
          snackBar(title: "Image uploaded successfully", context);
          _images.clear();
          setState(() {});
          GoRouterHelper(context).pop(true);          
        } on ApiException catch (e) {
          print("Error uploading image: $e");
          snackBar(title: e.message, context);
          if (e.statusCode == 401) {
            removeKey(Constants.jwtKey);
            context.push(AppRoutes.login);
          }
        } catch (e) {
          print("Error uploading image: $e");
          snackBar(title: "Error uploading image", context);
        }                
      } else {
        snackBar(title: "Please select an image to upload", context);
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildGridItem(int index) {
    if (index < _images.length) {
      return GestureDetector(
        onTap: () => _openFullScreenImage(index),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(_images[index], fit: BoxFit.cover),
        ),
      );
    } else {
      return GestureDetector(
        onTap: _showImageSourceDialog,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.add, size: 40, color: Colors.grey),
            ),
          ),
        ),
      );
    }
  }

  void _openFullScreenImage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => Scaffold(
              appBar: AppBar(
                title: const Text('Image Viewer'),
                backgroundColor: Colors.black,
              ),
              body: PhotoViewGallery.builder(
                itemCount: _images.length,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: FileImage(_images[index]),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                scrollPhysics: const BouncingScrollPhysics(),
                backgroundDecoration: const BoxDecoration(color: Colors.black),
                pageController: PageController(initialPage: index),
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int itemCount = _images.length + 1;

    return Scaffold(
      appBar: AppBar(title: const Text('Image Grid Picker')),
      body: Column(
        children: [
          // Wrap GridView inside Expanded to prevent overflow
          GridView.builder(
            shrinkWrap: true,
            itemCount: itemCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) => _buildGridItem(index),
          ),
          Row(
            children: [
              Text("REF0982 - "),
              Expanded(
                child: TextField(
                  controller: _referenceController,
                  decoration: const InputDecoration(
                    labelText: 'Enter reference',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: handleUpload,
              child: const Text('Upload'),
            ).paddingAll(16),
          ),
        ],
      ).paddingAll(8),
    );
  }
}
