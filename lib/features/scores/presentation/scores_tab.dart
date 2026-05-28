import 'package:ewords/core/database/quiz_score_helper.dart';
import 'package:ewords/features/scores/model/quiz_score_model.dart';
import 'package:ewords/features/scores/widgets/quiz_score_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/my_colors.dart';

class ScoresTab extends StatefulWidget {
  const ScoresTab({super.key});

  @override
  State<ScoresTab> createState() => _ScoresTabState();
}

class _ScoresTabState extends State<ScoresTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('unit_quiz scores'.toUpperCase()), // Title of the app bar
        titleTextStyle: TextStyle(
          color: MyColors.themeColors[300],
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),

      body: FutureBuilder<List<QuizScoreModel>>(
        future: QuizScoreHelper.instance.getQuizScores(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 10),
            );
          }
          // Handle error state
          else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Sorry, something went wrong!',
                style: TextStyle(
                  color: MyColors.themeColors[300],
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          // Handle empty favorites
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No scores yet!',
                style: TextStyle(
                  color: MyColors.themeColors[300],
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            List<QuizScoreModel> scores = snapshot.data!.reversed.toList();
            return ListView.builder(
              itemCount: snapshot.data!.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                QuizScoreModel quizScore = scores[index];
                return QuizScoreCard(quizScore: quizScore);
              },
            );
          }
        },
      ),
    );
  }
}
