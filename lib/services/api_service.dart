import 'dart:io';

import 'package:dio/dio.dart';
import 'package:digicon/constants/endpoints.dart';
import 'package:digicon/data/models.dart';
import 'package:digicon/services/network.dart';

class ApiService {
  static Future<void> uploadImage(String filePath) async {
    final formData = FormData();
    formData.files.add(
      MapEntry(
        'image',
        await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      ),
    );
    final res = await BaseApi().post(ApiEndpoints.uploadImage, data: formData);
    print(res);
  }

  static Future<void> uploadImages(List<File> images, String reference) async {
    final formData = FormData();
    for (var image in images) {
      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        ),
      );
    }
    formData.fields.add(MapEntry('reference', reference));
    final res = await BaseApi().post(ApiEndpoints.uploadImages, data: formData);
    print(res);
  }

  static Future<List<Media>> updateImages(
    List<File> images,
    String reference,
    String batchId,
  ) async {
    final formData = FormData();
    for (var image in images) {
      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        ),
      );
    }
    formData.fields.add(MapEntry('reference', reference));
    formData.fields.add(MapEntry('batchId', batchId));
    final res = await BaseApi().post(ApiEndpoints.updateImages, data: formData);
    print(res);
    return (res.data['data'])
        .map<Media>((e) => Media.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Media>> getImages() async {
    final response = await BaseApi().get(ApiEndpoints.getImages);
    if (response.statusCode == 200) {
      print(response.data['data']);
      List<Media> images = [];
      for (var image in response.data['data']) {
        images.add(Media.fromJson(image));
      }
      return images;
    } else {
      throw Exception('Failed to load images');
    }
  }

  static Future<List<Batch>> getBatches() async {
    final response = await BaseApi().get(ApiEndpoints.getBatches);
    if (response.statusCode == 200) {
      print(response.data['data']);
      final data = response.data['data'];
      if (data == null || data is! List) {
        throw Exception('Unexpected response format: "data" is not a List');
      }
      return (data)
          .map((e) => Batch.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load batches');
    }
  }

  static Future<void> deleteMedia(List<String> mediaIds) async {
    await BaseApi().delete(
      ApiEndpoints.deleteBulkMedia,
      data: {'mediaIds': mediaIds},
    );
  }

  static Future<void> deleteBatch(String batchId) async {
    await BaseApi().delete(
      '${ApiEndpoints.deleteBatch}/$batchId',
      data: {'batchId': batchId},
    );
  }
}
