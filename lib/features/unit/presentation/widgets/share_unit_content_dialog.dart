import 'package:ewords/core/utils/helper/share/telegram_share.dart';
import 'package:ewords/core/utils/helper/share/whatsapp_share.dart';
import 'package:ewords/shared/model/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/my_colors.dart';
import '../../../../core/theme/my_theme.dart';
import '../../../../core/utils/helper/msic/combine_unit_words.dart';
import '../../../../core/utils/helper/ui/snackbar_helper.dart';
import '../../../../shared/widgets/my_snackbar.dart';

class ShareUnitContentDialog extends StatelessWidget {
  final UnitModel unit;
  final int tabIndex;

  ShareUnitContentDialog({
    super.key,
    required this.unit,
    required this.tabIndex,
  }) {
    init();
  }

  String? wordsToShare, passageToShare;
  void init() async {
    // Append a footer to the text being shared
    wordsToShare =
        '${await CombineUnitWords.getCombinedWords(unit.words)}\n\nSent by eWords App';
    passageToShare = '${unit.passage}\n\nSent by eWords App';
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {}, // No action on closing
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20.sp), // Padding for the BottomSheet
          child: Column(
            mainAxisSize: MainAxisSize.min, // Minimize the size of the column
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Stretch contents to fill
            children: [
              // Container(
              //   margin: EdgeInsets.symmetric(
              //     horizontal: MediaQuery.of(context).size.width / 3,
              //   ),
              //   height: 5,
              //   decoration: BoxDecoration(
              //     color: Colors.black38,
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              // ),
              // Title of the share dialog
              Text(
                'Share via..',
                style: MyTheme().mainTextStyle.copyWith(fontSize: 18.sp),
              ),
              const SizedBox(height: 15),
              // WhatsApp share button
              TextButton(
                onPressed: () async {
                  if (tabIndex == 0) {
                    WhatsAppShare.share(
                      text: wordsToShare!,
                      onError: (msg) {
                        SnackBarHelper.show(
                          context: context,
                          widget: MySnackBar.create(content: msg),
                        );
                      },
                    );
                  } else if (tabIndex == 1) {
                    WhatsAppShare.share(
                      text: passageToShare!,
                      onError: (msg) {
                        SnackBarHelper.show(
                          context: context,
                          widget: MySnackBar.create(content: msg),
                        );
                      },
                    );
                  }
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      children: const [
                        WidgetSpan(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedWhatsapp,
                            color: Colors.green,
                          ),
                        ),
                        TextSpan(text: '   WhatsApp'),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(color: MyColors.themeColors[50]),
              // Telegram share button
              TextButton(
                onPressed: () async {
                  if (tabIndex == 0) {
                    TelegramShare.share(
                      text: wordsToShare!,
                      onError: (msg) {
                        SnackBarHelper.show(
                          context: context,
                          widget: MySnackBar.create(content: msg),
                        );
                      },
                    );
                  } else if (tabIndex == 1) {
                    TelegramShare.share(
                      text: passageToShare!,
                      onError: (msg) {
                        SnackBarHelper.show(
                          context: context,
                          widget: MySnackBar.create(content: msg),
                        );
                      },
                    );
                  }
                  Navigator.of(context).pop();
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      children: const [
                        WidgetSpan(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedTelegram,
                            color: Colors.blue,
                          ),
                        ),
                        TextSpan(text: '   Telegram'),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(color: MyColors.themeColors[50]),
              // Other app share button
              TextButton(
                onPressed: () async {
                  if (tabIndex == 0) {
                    Share.share(wordsToShare!); // Share words with other apps
                  } else if (tabIndex == 2) {
                    Share.share(
                      passageToShare!,
                    ); // Share the passage with other apps
                  }
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: MyColors.themeColors[300],
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      children: [
                        WidgetSpan(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedShare08,
                            color: MyColors.themeColors[300]!,
                          ),
                        ),
                        const TextSpan(text: '   Other Apps'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
