import 'package:mp3/models/flash_card.dart';

/// Represents a quiz session consisting of a list of flashcards.

class Quiz {
  List<Flashcard> flashcards;
  bool answerVisible;
  int currentCardIndex;

  /// Constructor for creating a Quiz instance.

  Quiz({
    required this.flashcards,
    //**** List of flashcards for the quiz.
    this.answerVisible = false,
    this.currentCardIndex = 0,
  });

  /// Retrieves the current flashcard from the list.

  Flashcard getCurrentCard() {
    return flashcards[currentCardIndex];
  }

  /// Shuffles the order of flashcards in the quiz.

  void shuffleCards() {
    flashcards.shuffle();
  }

  /// Toggles the visibility of the answer to the current flashcard.

  void toggleAnswerVisibility() {
    //**** Toggles the visibility flag.
    answerVisible = !answerVisible;
  }

  /// Moves to the next flashcard in the quiz.

  void nextCard() {
    if (currentCardIndex < flashcards.length - 1) {
      //**** Checks if there are more flashcards available.
      answerVisible = false;
      currentCardIndex++;
    }
  }

  /// Moves to the previous flashcard in the quiz.

  void previousCard() {
    if (currentCardIndex > 0) {
      //**** Checks if there are previous flashcards available.

      currentCardIndex--;
      //**** Moves to the previous flashcard.
      answerVisible = false;
      //**** Hides the answer.
    }
  }
}
