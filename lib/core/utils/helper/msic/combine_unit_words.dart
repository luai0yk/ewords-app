import 'package:ewords/features/unit_words/model/word_model.dart';

class CombineUnitWords {
  static Future<String> getCombinedWords(List<WordModel> words) async {
    /*wordToSpeak is the variable which will hold all unit_words, definitions, and
                        * examples of the unit*/
    String combinedWords = '';
    /*Combine all the unit unit_words in one string in order to speak them*/
    for (var element in words) {
      combinedWords +=
          "${element.word.substring(0, 1).toUpperCase() + element.word.substring(1)}\n${element.definition}\nExample: ${element.example}\n\n";
    }

    return combinedWords;
  }
}
