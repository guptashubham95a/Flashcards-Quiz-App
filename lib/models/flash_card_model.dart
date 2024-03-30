class Flashcard {
  int id;
  String question;
  int deckId;
  String answer;

  /// Constructor for creating a Flashcard instance.

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.deckId,
  });

  /// Converts a Flashcard object to a Map object.

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'deckId': deckId,
    };
  }

  /// Constructs a Flashcard object from a Map object.

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      question: map['question'],
      answer: map['answer'],
      deckId: map['deckId'] ?? 0,
    );
  }

  /// Constructs a Flashcard object from a JSON object.

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'] as int? ?? -1,
      //**** ID of the flashcard, default to -1 if not provided.
      question: json['question'] as String,
      //**** Question displayed on the flashcard.
      answer: json['answer'] as String,
      //**** Answer to the question on the flashcard.
      deckId: json['deckId'] as int? ?? -1,
      //**** ID of the deck to which the flashcard belongs, default to -1 if not provided
    );
  }
}
