import 'package:ewords/models/quiz_score_model.dart';
import 'package:ewords/models/unit_model.dart';
import 'package:ewords/provider/quiz_provider.dart';
import 'package:ewords/provider/units_provider.dart';
import 'package:ewords/theme/my_colors.dart';
import 'package:ewords/theme/my_theme.dart';
import 'package:ewords/ui/my_widgets/app_badge.dart';
import 'package:ewords/ui/my_widgets/stars_rate.dart';
import 'package:ewords/ui/pages/unit_content_page.dart';
import 'package:ewords/utils/ads/reward_ad_manager.dart';
import 'package:ewords/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hidable/hidable.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../provider/diamonds_provider.dart';
import '../../utils/helpers/snackbar_helper.dart';
import '../my_widgets/floating_appbar.dart';
import '../my_widgets/my_card.dart';
import '../my_widgets/my_snackbar.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  DiamondsProvider? _diamondsProvider;
  QuizProvider? _quizProvider;

  late final ItemScrollController _itemScrollController;
  final ScrollController _scrollController = ScrollController();

  int _lastAutoScrolledUnitId = -1;
  int _lastUnitsSignature = 0;
  int _lastScoresSignature = 0;
  bool _didInitDependencies = false;

  @override
  void initState() {
    super.initState();
    _itemScrollController = ItemScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitDependencies) return;
    _didInitDependencies = true;
    _diamondsProvider = context.read<DiamondsProvider>();
    _quizProvider = context.read<QuizProvider>();
    _quizProvider!.init();
    _diamondsProvider!.loadDiamonds();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void init() async {
    await Provider.of<UnitsProvider>(context, listen: false).fetchScores();
  }

  int _listItemCount(int unitCount) {
    return unitCount + (unitCount ~/ 30);
  }

  bool _isLevelCardIndex(int listIndex) {
    return listIndex == 0 || listIndex % 31 == 0;
  }

  int _unitIndexFromListIndex(int listIndex) {
    return listIndex - ((listIndex ~/ 31) + 1);
  }

  int _listIndexFromUnitIndex(int unitIndex) {
    return unitIndex + (unitIndex ~/ 30) + 1;
  }

  void _syncPassedUnits(List<QuizScoreModel>? scores) {
    if (scores == null || scores.isEmpty) return;
    final int signature = Object.hashAll(
      scores.map((score) => Object.hash(score.id, score.correctAnswers)),
    );
    if (signature == _lastScoresSignature) return;
    _lastScoresSignature = signature;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<QuizProvider>().setPassedUnitsFromScores(scores);
    });
  }

  void _scheduleScrollToActiveUnit({
    required int activeUnitId,
    required List<UnitModel> units,
  }) {
    if (activeUnitId <= 0 || units.isEmpty) return;

    final int unitsSignature = Object.hashAll(units.map((u) => u.id));
    if (activeUnitId == _lastAutoScrolledUnitId &&
        unitsSignature == _lastUnitsSignature) {
      return;
    }

    _lastAutoScrolledUnitId = activeUnitId;
    _lastUnitsSignature = unitsSignature;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_itemScrollController.isAttached) return;
      final int unitIndex = units.indexWhere((unit) => unit.id == activeUnitId);
      if (unitIndex == -1) return;
      final int listIndex = _listIndexFromUnitIndex(unitIndex);
      _itemScrollController.scrollTo(
        index: listIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _scrollToVisualTop(int itemCount) {
    if (!_itemScrollController.isAttached || itemCount <= 0) return;
    _itemScrollController.scrollTo(
      index: itemCount - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final int activeUnitId = context.select<QuizProvider, int>(
      (provider) => provider.currentActiveUnit,
    );

    return Scaffold(
      floatingActionButton: SizedBox(
        width: 40.r,
        height: 40.r,
        child: FloatingActionButton(
          backgroundColor: MyColors.themeColors[300],
          elevation: 1,
          onPressed: () {
            final units = context.read<UnitsProvider>().units;
            if (units == null) return;
            _scrollToVisualTop(_listItemCount(units.length));
          },
          tooltip: 'Scroll up',
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowUp01,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Consumer<UnitsProvider>(
            builder: (context, provider, child) {
              if (provider.units == null) {
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 10),
                );
              }

              final units = provider.units!;
              _syncPassedUnits(provider.scores);
              _scheduleScrollToActiveUnit(
                activeUnitId: activeUnitId,
                units: units,
              );

              return ScrollablePositionedList.builder(
                key: const PageStorageKey<String>('units'),
                itemScrollController: _itemScrollController,
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.22,
                  left: MediaQuery.of(context).size.width * 0.22,
                  top: MediaQuery.of(context).size.width * 0.30,
                  bottom: MediaQuery.of(context).size.width * 0.10,
                ),
                reverse: true,
                itemCount: _listItemCount(units.length),
                itemBuilder: (context, index) {
                  MyTheme.initialize(context);

                  if (_isLevelCardIndex(index)) {
                    return MyCard(
                      child: RichText(
                        text: TextSpan(
                          style: MyTheme().secondaryTextStyle.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            WidgetSpan(
                              child: AppBadge(
                                text: MyConstants
                                    .levelCodes[units[index].bookId - 1],
                              ),
                            ),
                            TextSpan(
                              text:
                                  '  ${MyConstants.levelDescription[units[index].bookId - 1]}',
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final itemIndex = _unitIndexFromListIndex(index);

                  return _buildListItem(
                    itemIndex,
                    units,
                    provider.scores ?? [],
                  );
                },
              );
            },
          ),
          Hidable(
            controller: _scrollController,
            preferredWidgetSize: Size.fromHeight(75.h),
            deltaFactor: 0.06,
            child: FloatingAppBar(
              showRewardedAd: () async {
                await context.read<RewardAdManager>().showRewardedAd();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
    int index,
    List<UnitModel> units,
    List<QuizScoreModel> scores,
  ) {
    Color? unPassedUnitColor = Theme.of(context).brightness == Brightness.light
        ? MyColors.themeColors[50]
        : MyColors.themeColors[50]!.withValues(alpha: 0.1);

    final UnitModel unit = units[index];
    Alignment alignment = _getAlignment(index);

    return Selector<QuizProvider, Map<String, dynamic>>(
      builder: (context, passedUnits, child) {
        bool isPassed = passedUnits['is_passed'];
        final int activeUnitId = passedUnits['current_active_unit'];
        QuizScoreModel? score;

        if (isPassed && index < scores.length) {
          score = scores[index];
        }

        return Container(
          alignment: alignment,
          child: Container(
            width: 100.w,
            margin: EdgeInsets.symmetric(vertical: 30.h),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isPassed || activeUnitId == unit.id) {
                      MyTheme.initialize(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UnitContentPage(),
                          settings: RouteSettings(arguments: unit),
                        ),
                      ).then((value) {
                        init();
                        _quizProvider!.init();
                      });
                    } else {
                      SnackBarHelper.show(
                        context: context,
                        widget: MySnackBar.create(
                          content: 'This unit is locked $index',
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: activeUnitId == unit.id ? 85.r : 72.r,
                    width: activeUnitId == unit.id ? 85.r : 72.r,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: isPassed || activeUnitId == unit.id
                          ? MyColors.themeColors[300]
                          : unPassedUnitColor,
                      borderRadius: BorderRadius.circular(90),
                      border: activeUnitId == unit.id
                          ? Border.all(
                              color: MyColors.themeColors[50]!.withValues(
                                alpha: .7,
                              ),
                              width: 5,
                            )
                          : const Border(),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isPassed || activeUnitId == unit.id
                            ? Colors.white
                            : MyColors.themeColors[300],
                        fontSize: 35.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (isPassed && score != null)
                  StarsRate(score: score.totalScore),
              ],
            ),
          ),
        );
      },
      selector: (context, selector) {
        return selector.getUnitStatus(unit.id);
      },
    );
  }

  Alignment _getAlignment(int index) {
    switch (index % 4) {
      case 0:
        return Alignment.topLeft;
      case 1:
        return Alignment.center;
      case 2:
        return Alignment.topRight;
      case 3:
        return Alignment.center;
      default:
        return Alignment.topLeft;
    }
  }
}
