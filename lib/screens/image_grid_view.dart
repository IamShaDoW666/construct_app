import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:digicon/constants/keys.dart';
import 'package:digicon/constants/routes.dart';
import 'package:digicon/data/models.dart';
import 'package:digicon/services/api_service.dart';
import 'package:digicon/services/network.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageGridView extends StatefulWidget {
  const ImageGridView({super.key, required this.batch});
  final Batch batch;

  @override
  State<ImageGridView> createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {
  late List<Media> _existing;
  final List<String> _removedMediaIds = [];
  final List<File> _newFiles = [];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _referenceController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _existing = List.from(widget.batch.media);
    _referenceController.text = widget.batch.reference!.substring(7) ?? '';
    _isLoading = false;
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _newFiles.add(File(picked.path));
      });
    }
  }

  Future<void> handleUpload() async {
    if (_isLoading) return;
    _isLoading = true;
    if (_newFiles.isEmpty &&
        _removedMediaIds.isEmpty &&
        _referenceController.text == widget.batch.reference!.substring(7)) {
      snackBar(title: "No changes to update", context);
      return;
    }

    try {
      // Upload new images
      if (_newFiles.isNotEmpty ||
          _referenceController.text != widget.batch.reference!.substring(7)) {
        final List<Media> uploadedMedia = await ApiService.updateImages(
          _newFiles,
          _referenceController.text,
          widget.batch.id,
        );

        setState(() {
          _existing.insertAll(0, uploadedMedia);
          _newFiles.clear();
        });
      }

      // Delete removed images
      if (_removedMediaIds.isNotEmpty) {
        await ApiService.deleteMedia(_removedMediaIds);
        _removedMediaIds.clear();
        setState(() {});
      }
      _isLoading = false;
      snackBar(title: "Batch updated successfully", context);
      GoRouter.of(context).pop(true);
    } on ApiException catch (e) {
      _isLoading = false;
      snackBar(title: 'Error! ${e.message}', context);
      if (e.statusCode == 401) {
        removeKey(Constants.jwtKey);
        context.push(AppRoutes.login);
      }
    } catch (e) {
      _isLoading = false;
      snackBar(title: "$e", context);
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
    if (index < _existing.length) {
      final media = _existing[index];
      return Stack(
        children: [
          GestureDetector(
            onTap: () => _openFullScreen(index, isExisting: true),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: media.url,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _removedMediaIds.add(media.id);
                  _existing.removeAt(index);
                });
              },
              child: const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      );
    }

    if (index == _existing.length) {
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

    final fileIndex = index - _existing.length - 1;
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _openFullScreen(fileIndex, isExisting: false),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              _newFiles[fileIndex],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _newFiles.removeAt(fileIndex);
              });
            },
            child: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.black54,
              child: Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _openFullScreen(int index, {required bool isExisting}) {
    final images =
        isExisting
            ? _existing
                .map((m) => NetworkImage(m.url) as ImageProvider)
                .toList()
            : _newFiles.map((f) => FileImage(f) as ImageProvider).toList();

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
                itemCount: images.length,
                builder:
                    (ctx, i) => PhotoViewGalleryPageOptions(
                      imageProvider: images[i],
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    ),
                pageController: PageController(initialPage: index),
                scrollPhysics: const BouncingScrollPhysics(),
                backgroundDecoration: const BoxDecoration(color: Colors.black),
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = _existing.length + _newFiles.length + 1;

    return Scaffold(
      appBar: AppBar(title: const Text("Batch Images")),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: itemCount,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemBuilder: (_, idx) => _buildGridItem(idx),
                  ),
                  36.height,
                  Row(
                    children: [
                      Text('${widget.batch.reference?.substring(0, 7)} - '),
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
                      child: const Text('Update Batch'),
                    ).paddingAll(16),
                  ),
                ],
              ),
    );
  }
}
