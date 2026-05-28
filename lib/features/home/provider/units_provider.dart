import 'package:ewords/features/scores/model/quiz_score_model.dart';
import 'package:ewords/features/unit_words/model/word_model.dart';
import 'package:ewords/shared/model/unit_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/database/quiz_score_helper.dart';
import '../../../core/database/unit_helper.dart';

class UnitsProvider extends ChangeNotifier {
  List<UnitModel>? units;
  List<QuizScoreModel>? scores;
  List<WordModel>? words;

  double? score;
  int? answeredQuestionCount;

  Future<void> fetchUnits() async {
    units = await UnitHelper.instance.getUnits();
    notifyListeners();
  }

  Future<void> fetchScores() async {
    scores = await QuizScoreHelper.instance.getQuizScores();
    notifyListeners();
  }

  void scoreById({required int id}) {
    List<QuizScoreModel> myScore = scores!
        .where((element) => element.id == id)
        .toList();

    if (myScore.isNotEmpty) {
      score = myScore.first.totalScore;
      answeredQuestionCount = myScore.first.correctAnswers;
    } else {
      score = 0.0;
      answeredQuestionCount = 0;
    }
  }
}
