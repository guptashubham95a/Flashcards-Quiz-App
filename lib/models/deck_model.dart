import 'flash_card_model.dart';

class Deck {
  int id;
  List<Flashcard> flashcards;
  String title;

  /// Constructor for creating a Deck instance.

  Deck({
    required this.id,
    required this.flashcards,
    required this.title,
  });

  /// Converts a Deck object to a Map object.

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  /// Constructs a Deck object from a Map object.

  factory Deck.fromMap(Map<String, dynamic> map) {
    return Deck(
      id: map['id'],
      flashcards: [],
      title: map['title'],
    );
  }

  /// Constructs a Deck object from a JSON object.

  factory Deck.fromJson(dynamic json) {
    final title = json['title'] as String;
    final flashcardsList = json['flashcards'] as List;
    //**** Convert each JSON flashcard object to a Flashcard instance and create a list.

    final flashcards = flashcardsList
        .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
        .toList();

    return Deck(
      title: title,
      flashcards: flashcards,
      id: 0,
    );
  }
}
