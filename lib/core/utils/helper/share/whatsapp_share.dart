// WhatsApp Sharing Service
import 'package:ewords/core/utils/helper/share/share.dart';

// WhatsApp Sharing
class WhatsAppShare {
  static Future<void> share({
    required String text,
    required Function(String msg) onError,
  }) async {
    final Uri url = Uri.parse(
      'whatsapp://send?text=${Uri.encodeComponent(text)}',
    );
    Share.share(
      text: text,
      url: url,
      platformName: 'WhatsApp',
      onError: onError,
    );
  }
}
