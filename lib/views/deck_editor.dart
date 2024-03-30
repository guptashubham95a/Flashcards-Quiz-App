import 'package:flutter/material.dart';
import 'package:mp3/snack_bar.dart';
import 'package:mp3/utils/db_helper.dart';

class DeckEditor extends StatefulWidget {
  final int deckId;
  final void Function() reloadDecks;

  DeckEditor({required this.deckId, required this.reloadDecks, Key? key});

  @override
  _DeckEditorState createState() => _DeckEditorState();
}

class _DeckEditorState extends State<DeckEditor> {
  final TextEditingController _titleController = TextEditingController();
  String currentTitle = " Title";

  @override
  void initState() {
    super.initState();

    DBHelper db = DBHelper();

    db.fetchDeckTitle(widget.deckId).then((title) {
      setState(() {
        currentTitle = title;
        _titleController.text = currentTitle;
      });
    });
  }

  void saveDeckChanges() async {
    DBHelper db = DBHelper();
    await db.updateDeck(widget.deckId, currentTitle);

    setState(() {
      currentTitle = _titleController.text;
    });

    Navigator.pop(context);
  }

  void deleteDeck() async {
    DBHelper db = DBHelper();
    await db.deleteDeck(widget.deckId);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Edit Deck')),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              child: const Text(
                'Deck Name',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _titleController,
                onChanged: (updatedTitle) {
                  setState(() {
                    currentTitle = updatedTitle;
                  });
                },
                decoration: const InputDecoration(
                  filled: false,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (currentTitle.isEmpty) {
                      showCustomSnackBar(
                          content: 'Please enter a title for the deck',
                          context: context,
                          backgroundColor: Colors.red);
                      return;
                    }
                    saveDeckChanges();
                    showCustomSnackBar(
                        content: 'Deck Edited Added Successfully.',
                        context: context);
                    widget.reloadDecks();
                  },
                  child: const Text(
                    style: TextStyle(color: Colors.green),
                    'Save',
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    deleteDeck();
                    showCustomSnackBar(
                        content: 'Deck Deleted Successfully.',
                        context: context);
                    widget.reloadDecks();
                  },
                  child: const Text(
                    style: TextStyle(color: Colors.green),
                    'Delete',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
