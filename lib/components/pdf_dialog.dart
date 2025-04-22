import 'dart:io';
import 'dart:typed_data';
import 'package:digicon/utils/pdf.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

class PdfDialog extends StatelessWidget {
  final Uint8List pdf;
  final String pdfName;
  const PdfDialog({super.key, required this.pdf, required this.pdfName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: context.height() / 4,
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'PDF Generated',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '$pdfName.pdf',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final res = await savePdf(pdf, pdfName);
                      if (res != null) {
                        snackBar(context, title: 'PDF saved to device');
                        GoRouterHelper(context).pop();
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save to Device'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final res = await sharePdfFromBytes(
                        pdf,
                        fileName: pdfName,
                      );
                      if (res.validate()) {                       
                        GoRouterHelper(context).pop();
                      }
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 24),
        ),
      ),
    );
  }
}
