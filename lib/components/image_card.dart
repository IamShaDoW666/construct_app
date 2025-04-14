import 'package:cached_network_image/cached_network_image.dart';
import 'package:digicon/data/models.dart';
import 'package:flutter/material.dart';

class ImageBox extends StatelessWidget {
  const ImageBox({super.key, required this.image});

  final Media image;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image.url,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      fit: BoxFit.cover,
    );
  }
}
