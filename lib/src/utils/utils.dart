class Utils {
  static String capitalizeWord(String word) {
    if(word.isEmpty) return word;

    if(word.length == 1) return word[0].toUpperCase();

    return word[0].toUpperCase() + word.substring(1);
  }
}