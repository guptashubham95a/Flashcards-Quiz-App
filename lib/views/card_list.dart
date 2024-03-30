import 'package:flutter/material.dart';
import 'package:mp3/utils/db_helper.dart';
import 'package:mp3/models/flash_card_model.dart';
import '../views/flash_card_editor.dart';
import '../views/new_flashcard.dart';
import '../views/quiz_section_screen.dart';

class CardListScreen extends StatefulWidget {
  final int deckId;

  CardListScreen({required this.deckId});

  @override
  _CardListScreenState createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  late Future<List<Flashcard>> cards;
  List<Flashcard>? cardList;
  String? deckTitle;

  bool sortAlphabetically = false;
  @override
  void initState() {
    super.initState();
    _getCards();
    _getDeckTitle();
    cards = DBHelper().fetchCardsForDeck(widget.deckId);
    cardList = [];
  }

  Future<void> _getDeckTitle() async {
    final decktitle = await DBHelper().fetchDeckTitle(widget.deckId);
    setState(() {
      deckTitle = decktitle;
    });
  }

  Future<void> _getCards() async {
    final db = DBHelper();
    final deckCards = await db.fetchCardsForDeck(widget.deckId);
    setState(() {
      cardList = deckCards;
    });
  }

  void reloadCards() {
    _getCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${deckTitle ?? ''} Deck'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              sortAlphabetically ? Icons.timer : Icons.sort,
            ),
            onPressed: () {
              setState(() {
                sortAlphabetically = !sortAlphabetically;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_circle_right_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(deckId: widget.deckId),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Flashcard>>(
        future: cards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('This Deck is Empty.'));
          } else {
            List<Flashcard> cardListCopy = snapshot.data!;
            if (sortAlphabetically) {
              cardListCopy.sort((a, b) =>
                  a.question.toLowerCase().compareTo(b.question.toLowerCase()));
            } else {
              cardListCopy.sort((a, b) => a.id.compareTo(b.id));
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.0,
                crossAxisCount: 3,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final card = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    color: Colors.green[100],
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditFlashcardScreen(
                                flashcard: card, refreshCards: reloadCards),
                          ),
                        ).then((result) {
                          if (result != null) {
                            setState(() {
                              int index = cardListCopy
                                  .indexWhere((card) => card.id == result.id);
                              if (index != -1) {
                                cardListCopy[index] = result;
                              }
                              cards =
                                  DBHelper().fetchCardsForDeck(widget.deckId);
                            });
                          }
                        });
                      },
                      child: Center(
                        child: Text(
                          card.question,
                          overflow:
                              TextOverflow.ellipsis, // Set overflow property
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[400],
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AddFlashcardScreen(deckId: widget.deckId);
              },
            ),
          );
          setState(() {
            cards = DBHelper().fetchCardsForDeck(widget.deckId);
          });
        },
        child: const Icon(Icons.add_card),
      ),
    );
  }
}
