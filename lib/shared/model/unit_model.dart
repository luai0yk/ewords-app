import 'package:ewords/features/unit_words/model/word_model.dart';

class UnitModel {
  int id, unitId, bookId;
  String passage, passageTitle;
  List<WordModel> words;

  UnitModel({
    required this.id,
    required this.bookId,
    required this.unitId,
    required this.passageTitle,
    required this.passage,
    required this.words,
  });

  factory UnitModel.fromMap(
    Map<String, dynamic> map, {
    List<WordModel>? words,
  }) {
    /*Split the unit_passage field by its lines into a list then get
    * the first item of it which holds the unit_passage title*/
    String title = map['unit_passage'].split('\n').first;

    /*Split the unit_passage field by its line into a list using split('\n') function*/
    List<String> lines = map['unit_passage'].split('\n');

    /*Skip or delete the first line which holds the unit_passage title
    * then convert the list into one String value again using join('') function*/
    String passage = lines.skip(1).join('\n');

    // Create a new PassageModel instance from a Map
    return UnitModel(
      id: map['id'],
      unitId: map['unit_id'],
      bookId: map['book_id'],
      passageTitle: title,
      passage: passage,
      words: words!,
    );
  }
}
