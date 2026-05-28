import 'package:ewords/features/unit_words/model/word_model.dart';

class UnitArgs {
  int? unitId, bookId;
  String? passage;
  List<WordModel>? words;

  UnitArgs({this.unitId, this.bookId, this.passage, this.words});
}
