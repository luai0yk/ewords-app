// Abstract class for sharing services
import 'package:url_launcher/url_launcher.dart';

import '../msic/error_handler.dart';

abstract class Share {
  static Future<void> share({
    required String text,
    required Uri url,
    required String platformName,
    required Function(String msg) onError,
  }) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ErrorHandler.errorHandler(
        message: 'Could not launch $platformName',
        onError: onError,
      );
    }
  }
}
