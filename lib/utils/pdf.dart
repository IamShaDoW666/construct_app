import 'dart:io';
import 'dart:typed_data';
import 'package:digicon/data/models.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

Future<Uint8List> _downloadImage(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load image');
  }
}

Future<Uint8List> _generatePdf(List<Uint8List> images) async {
  final pdf = pw.Document();
  for (var image in images) {
    final pdfImage = pw.MemoryImage(image);
    pdf.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(0),
        ),
        build: (pw.Context context) {
          return pw.Center(child: pw.Image(pdfImage));
        },
      ),
    );
  }

  return pdf.save();
}

Future<String?> savePdf(Uint8List pdfBytes, String defaultFileName) async {
  // Open the native save dialog
  String? selectedPath = await FilePicker.platform.saveFile(
    dialogTitle: 'Save PDF',
    fileName: defaultFileName,
    type: FileType.custom,
    allowedExtensions: ['pdf'],
    bytes: pdfBytes,
  );

  // final file = File(selectedPath!);
  // await file.writeAsBytes(pdfBytes);
  return selectedPath;
}

Future<void> sharePdf(XFile file) async {
  await Share.shareXFiles([file], text: 'Here is your PDF document.');
}

Future<bool> sharePdfFromBytes(Uint8List pdfBytes, {String? fileName}) async {
  try {
    // Get the temporary directory
    final tempDir = await getTemporaryDirectory();

    // Generate a unique file name if none is provided
    final uniqueFileName =
        '$fileName.pdf' ?? 'PDF${DateTime.now().toString()}.pdf';

    // Create the temporary file
    final file = File('${tempDir.path}/$uniqueFileName');

    // Write the PDF bytes to the file
    await file.writeAsBytes(pdfBytes);

    // Share the file
    final shareResult = await Share.shareXFiles([
      XFile(file.path, name: '$fileName.pdf'),
    ], text: '$fileName.pdf' ?? 'Here is your PDF document.');
    if (shareResult.status == ShareResultStatus.success) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    // Handle any errors
    print('Error sharing PDF: $e');
    return false;
  }
}

Future<Uint8List?> convertImagesToPdf(List<Media> mediaList) async {
  try {
    // Step 1: Download images
    List<Uint8List> imageBytesList = [];
    for (var media in mediaList) {
      if (media.url.isNotEmpty) {
        final bytes = await _downloadImage(media.url);
        imageBytesList.add(bytes);
      }
    }

    // Step 2: Generate PDF
    final pdfBytes = await _generatePdf(imageBytesList);

    return pdfBytes;
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
  }
  return null;
}
