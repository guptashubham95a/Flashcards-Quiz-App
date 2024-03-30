import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mp3/models/deck_model.dart';
import 'package:mp3/snack_bar.dart';
import '../views/new_deck_screen.dart';

import '../utils/db_helper.dart';
import '../views/card_list.dart';
import '../views/deck_editor.dart';

class DeckList extends StatefulWidget {
  const DeckList({Key? key});

  @override
  _DeckListState createState() => _DeckListState();
}

class _DeckListState extends State<DeckList> {
  late List<Deck> decks = [];

  @override
  void initState() {
    super.initState();
    _getDecks();
  }

  Future<void> _getDecks() async {
    final db = DBHelper();
    final updatedDecks = await db.getDecks();
    setState(() {
      decks = updatedDecks
          .map((row) => Deck(
                id: row['id'] as int,
                flashcards: [],
                title: row['title'] as String,
              ))
          .toList();
    });
  }

  void refreshDecks() {
    _getDecks();
  }

  Future<void> getData(BuildContext context) async {
    try {
      final jsonStr = await rootBundle.loadString('assets/flashcards.json');
      final dataInJson = json.decode(jsonStr) as List?;

      if (dataInJson != null) {
        final db = DBHelper();

        for (var deckInJson in dataInJson) {
          if (deckInJson is Map) {
            final Deck deck = Deck.fromJson(deckInJson);
            final deckId = await db.insertDeck(deck.title);

            for (var flashcard in deck.flashcards) {
              await db.insertFlashcard(
                flashcard.question,
                flashcard.answer,
                deckId,
              );
            }
          }
        }

        _getDecks();

        showCustomSnackBar(
            context: context, content: 'Data Fetched Successfully.');
      } else {
        showCustomSnackBar(
            context: context,
            content:
                'The JSON data does not adhere to the anticipated structure.');
      }
    } catch (error) {
      showCustomSnackBar(
          context: context,
          content: 'Something gone wrong processing data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('All Decks')),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.download_for_offline_outlined),
            onPressed: () async {
              await getData(context);
            },
          ),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        int crossAxisCount = (constraints.maxWidth / 150).floor();
        return GridView.count(
          crossAxisCount: crossAxisCount,
          padding: const EdgeInsets.all(4),
          children: decks.map((deck) {
            return Card(
              color: Colors.green[100],
              child: Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardListScreen(deckId: deck.id),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          deck.title,
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis, // Set overflow property
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: IconButton(
                          icon: const Icon(Icons.edit_document),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeckEditor(
                                    deckId: deck.id, reloadDecks: refreshDecks),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newDeckId = await Navigator.of(context).push<int>(
            MaterialPageRoute(
              builder: (context) => AddDeckScreen(reloadDecks: refreshDecks),
            ),
          );
          if (newDeckId != null) {
            _getDecks();
          }
        },
        backgroundColor: Colors.green[400],
        child: const Icon(Icons.add_card),
      ),
    );
  }
}
