import 'package:flutter/material.dart';
import 'package:mp3/utils/db_helper.dart';

import 'package:mp3/snack_bar.dart';

class AddDeckScreen extends StatefulWidget {
  final void Function() reloadDecks;

  AddDeckScreen({required this.reloadDecks, Key? key}) : super(key: key);
  @override
  _AddDeckScreenState createState() => _AddDeckScreenState();
}

class _AddDeckScreenState extends State<AddDeckScreen> {
  final TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add a New Deck')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title of New Deck'),
              controller: titleController,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                final titleValue = titleController.text;

                if (titleValue.isNotEmpty) {
                  DBHelper().insertDeck(titleValue);
                  showCustomSnackBar(
                      content: 'New Deck Added Successfully.',
                      context: context);
                  Navigator.of(context).pop();
                  widget.reloadDecks();
                } else {
                  showCustomSnackBar(
                      content: 'Please enter a title for the deck',
                      context: context,
                      backgroundColor: Colors.red);
                  return;
                }
              },
              child: const Text('Save New Deck'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}
