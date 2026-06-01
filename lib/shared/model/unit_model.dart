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
    final String passageRaw = (map['unit_passage'] as String?) ?? '';
    final List<String> lines = passageRaw.isEmpty
        ? const <String>[]
        : passageRaw.split('\n');
    final String title = lines.isNotEmpty ? lines.first : '';
    final String passage = lines.length > 1 ? lines.skip(1).join('\n') : '';

    // Create a new PassageModel instance from a Map
    return UnitModel(
      id: map['id'],
      unitId: map['unit_id'],
      bookId: map['book_id'],
      passageTitle: title,
      passage: passage,
      words: words ?? const <WordModel>[],
    );
  }
}
