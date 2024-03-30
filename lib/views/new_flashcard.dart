import 'package:flutter/material.dart';

import 'package:mp3/utils/db_helper.dart';
import 'package:mp3/snack_bar.dart';

class AddFlashcardScreen extends StatefulWidget {
  final int deckId;

  AddFlashcardScreen({required this.deckId});

  @override
  _AddFlashcardScreenState createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  final TextEditingController qController = TextEditingController();
  final TextEditingController ansController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add New Flashcard')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Question'),
              controller: qController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Answer'),
              controller: ansController,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final questionValue = qController.text;
                final answerValue = ansController.text;

                if (questionValue.isNotEmpty && answerValue.isNotEmpty) {
                  DBHelper().insertFlashcard(
                      questionValue, answerValue, widget.deckId);
                  showCustomSnackBar(
                    content: 'New flashcard Added.',
                    context: context,
                    backgroundColor: Colors.green,
                  );
                  Navigator.of(context).pop();
                } else {
                  if (questionValue.isEmpty || answerValue.isEmpty) {
                    showCustomSnackBar(
                      content:
                          'Please enter a proper data for adding flashcard.',
                      context: context,
                      backgroundColor: Colors.red,
                    );
                    return;
                  }
                }
              },
              child: const Text(
                  style: TextStyle(
                    color: Colors.green,
                  ),
                  'Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    qController.dispose();
    ansController.dispose();
    super.dispose();
  }
}
