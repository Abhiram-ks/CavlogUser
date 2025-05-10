import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

abstract class ShareService {
  Future<void> sharePost({required String text, required String ventureName, required String location, String? imageUrl});
}

class ShareServicesImpl implements ShareService {
  @override
  Future<void> sharePost({
    required String text,
    required String ventureName,
    required String location,
    String? imageUrl,
  }) async {
    final shareText = 'Check out $ventureName at $location.';
    final shareTextContent = "Here’s a style you don’t want to miss 💈 $text";

    try {
      final shareParams = await _prepareShareParams(
        text: shareTextContent,
        title: shareText,
        imageUrl: imageUrl,
      );



      final result = await SharePlus.instance.share(shareParams);
      if (result.status == ShareResultStatus.success) {
        log('Shared successfully!');
      } else if (result.status == ShareResultStatus.dismissed) {
        log('Share dismissed.');
      }
    } catch (e) {
      log('Error sharing post: $e');
    }
  }

  Future<ShareParams> _prepareShareParams({
    required String text,
    required String title,
    String? imageUrl,
  }) async {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      final response = await http.get(Uri.parse(imageUrl));
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/shared_image.jpg');
      await file.writeAsBytes(bytes);

      return ShareParams(
        text: text,
        title: title,
        files: [XFile(file.path)],
      );
    } else {
      return ShareParams(text: text, title: title);
    }
  }
}
