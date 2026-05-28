// Telegram Sharing Service
import 'package:ewords/core/utils/helper/share/share.dart';

// Telegram Sharing
class TelegramShare {
  static Future<void> share({
    required String text,
    required Function(String msg) onError,
  }) async {
    final Uri url = Uri.parse(
      'https://t.me/share/url?url=${Uri.encodeComponent(text)}',
    );
    Share.share(
      text: text,
      url: url,
      platformName: 'Telegram',
      onError: onError,
    );
  }
}
