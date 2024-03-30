import 'package:flutter/material.dart';
import 'package:mp3/models/flash_card_model.dart';
import 'package:mp3/utils/db_helper.dart';

class QuizScreen extends StatefulWidget {
  final int deckId;

  QuizScreen({required this.deckId});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Flashcard> flashcards = [];
  String? deckTitle;
  bool isAnswerShowing = false;
  int totalCardsViewed = 0;
  int currentIndex = 0;
  int totalAnswersViewed = 0;
  Set<int> viewedAnswerSet = {};
  Set<int> viewedCardsSet = {};

  @override
  void initState() {
    super.initState();
    _getDeckTitle();
    getShuffledFlashcards();
  }

  Future<void> _getDeckTitle() async {
    final title = await DBHelper().fetchDeckTitle(widget.deckId);
    setState(() {
      deckTitle = title;
    });
  }

  void getShuffledFlashcards() async {
    final fetchedFlashcards = await DBHelper().fetchCardsForDeck(widget.deckId);
    if (fetchedFlashcards.isNotEmpty) {
      setState(() {
        flashcards = List.from(fetchedFlashcards)..shuffle();
      });
    }
  }

  void viewNextCard() {
    if (currentIndex < flashcards.length - 1) {
      setState(() {
        currentIndex++;
        isAnswerShowing = false;
        if (!viewedCardsSet.contains(currentIndex)) {
          totalCardsViewed++;
          viewedCardsSet.add(currentIndex);
        }
      });
    } else {
      setState(() {
        currentIndex = 0;
        isAnswerShowing = false;
      });
    }
  }

  void viewPreviousCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        isAnswerShowing = false;
        if (!viewedCardsSet.contains(currentIndex)) {
          totalCardsViewed++;
          viewedCardsSet.add(currentIndex);
        }
      });
    } else {
      setState(() {
        currentIndex = flashcards.length - 1;
        isAnswerShowing = false;
        if (!viewedCardsSet.contains(currentIndex)) {
          totalCardsViewed++;
          viewedCardsSet.add(currentIndex);
        }
      });
    }
  }

  Set<int> viewedAnswers = Set();

  void changeAnswerVisibility() {
    setState(() {
      if (!isAnswerShowing) {
        if (!viewedAnswers.contains(currentIndex)) {
          totalAnswersViewed++;
          viewedAnswers.add(currentIndex);
        }
      }
      isAnswerShowing = !isAnswerShowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(deckTitle != null ? '$deckTitle Quiz' : 'Quiz'),
        ),
      ),
      body: flashcards.isEmpty
          ? const Center(child: Text('No cards present in this deck.'))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Card ${currentIndex + 1} of Total ${flashcards.length} Cards.',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                FlashcardCard(
                  flashcard: flashcards[currentIndex],
                  isAnswerShowing: isAnswerShowing,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: viewPreviousCard,
                      child: const MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Icon(Icons.swipe_left_rounded),
                      ),
                    ),
                    GestureDetector(
                      onTap: changeAnswerVisibility,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Icon(
                          isAnswerShowing
                              ? Icons.flip_to_front
                              : Icons.remove_red_eye,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: viewNextCard,
                      child: const MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Icon(Icons.swipe_right_rounded),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                    'Seen ${totalCardsViewed + 1} of ${flashcards.length} cards'),
                const SizedBox(
                  height: 10,
                ),
                Text(
                    'Peeked at ${totalAnswersViewed} of ${totalCardsViewed + 1} answers'),
              ],
            ),
    );
  }
}

class FlashcardCard extends StatelessWidget {
  final Flashcard flashcard;
  final bool isAnswerShowing;

  FlashcardCard({
    required this.flashcard,
    required this.isAnswerShowing,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: isAnswerShowing ? Colors.green[300] : Colors.blue[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 300,
            maxHeight: 300,
          ),
          child: InkWell(
            child: Center(
              child: Text(
                isAnswerShowing ? flashcard.answer : flashcard.question,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
