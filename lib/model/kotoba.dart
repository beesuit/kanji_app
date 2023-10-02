class Kotoba {
  final String kanji;
  final String hiragana;
  final String english;
  final String example;

  Kotoba(
      {required this.kanji,
      required this.hiragana,
      required this.english,
      required this.example});

  static List<Kotoba> placeholderList() {
    return [Kotoba(kanji: '', hiragana: '', english: '', example: '')];
  }
}
