import 'package:ewords/features/unit/presentation/unit_content_page.dart';
import 'package:ewords/shared/widgets/app_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/my_colors.dart';
import '../../../core/theme/my_theme.dart';
import '../../../core/utils/helper/msic/recent_unit.dart';
import '../../../core/utils/helper/ui/dialog_helper.dart';
import '../../../core/utils/helper/ui/snackbar_helper.dart';
import '../../../shared/provider/diamonds_provider.dart';
import '../../../shared/widgets/app_dialog.dart';
import '../../../shared/widgets/my_card.dart';
import '../../../shared/widgets/my_snackbar.dart';
import '../../dictionary/presentation/dictionary_page.dart';
import '../provider/units_provider.dart';

class FloatingAppBar extends StatelessWidget {
  final Function showRewardedAd;

  const FloatingAppBar({super.key, required this.showRewardedAd});

  @override
  Widget build(BuildContext context) {
    return MyCard(
      height: kToolbarHeight,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 5,
        left: MediaQuery.of(context).padding.top / 2,
        right: MediaQuery.of(context).padding.top / 2,
      ),
      padding: EdgeInsets.all(4.sp),
      width: double.infinity,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                DialogHelper.show(
                  context: context,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return AppDialog(
                      title: 'Rewarded Ad',
                      content: 'Watch an ad and get 6 diamonds.',
                      okayText: 'Watch Ad',
                      onOkay: () {
                        showRewardedAd();
                      },
                      onCancel: () => null,
                    );
                  },
                );
              },
              tooltip: 'Diamonds',
              icon: Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedDiamond02,
                    color: MyColors.themeColors[300]!,
                  ),
                  const SizedBox(width: 2),
                  Selector<DiamondsProvider, int>(
                    builder: (context, diamonds, child) {
                      return Text(
                        '$diamonds',
                        style: MyTheme().mainTextStyle.copyWith(
                          color: MyColors.themeColors[300],
                        ),
                      );
                    },
                    selector: (ctx, provider) => provider.diamonds,
                  ),
                ],
              ),
            ),
            const Spacer(),
            RichText(
              text: TextSpan(
                style: MyTheme().secondaryTextStyle.copyWith(
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  //backgroundColor: Colors.red,
                ),
                children: [
                  WidgetSpan(
                    child: AppBadge(
                      text: 'E',
                      fontSize: 12,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      backgroundColor: MyColors.themeColors[300]!,
                      textColor: Colors.white,
                    ),
                  ),
                  const TextSpan(text: 'words'),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DictionaryPage(),
                  ),
                );
              },
              tooltip: 'Dictionary',
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedSearch01,
                color: MyColors.themeColors[300]!,
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                MyTheme.initialize(context);
                RecentUnit.loadRecentTap(
                  context: context,
                  onError: (msg) {
                    SnackBarHelper.show(
                      context: context,
                      widget: MySnackBar.create(content: msg),
                    );
                  },
                  onSuccess: (index) {
                    MyTheme.initialize(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UnitContentPage(),
                        settings: RouteSettings(
                          arguments: context
                              .read<UnitsProvider>()
                              .units![index],
                        ),
                      ),
                    );
                  },
                );
              },
              tooltip: 'Learning',
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedOnlineLearning01,
                color: MyColors.themeColors[300]!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
