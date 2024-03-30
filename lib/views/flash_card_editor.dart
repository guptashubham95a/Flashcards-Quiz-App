import 'package:flutter/material.dart';
import 'package:mp3/models/flash_card_model.dart';
import 'package:mp3/snack_bar.dart';
import 'package:mp3/utils/db_helper.dart';

class EditFlashcardScreen extends StatefulWidget {
  final Flashcard flashcard;
  final void Function() refreshCards;

  EditFlashcardScreen(
      {required this.flashcard, required this.refreshCards, Key? key});

  @override
  _EditFlashcardScreenState createState() => _EditFlashcardScreenState();
}

class _EditFlashcardScreenState extends State<EditFlashcardScreen> {
  String editedQuestion = '';
  String editedAnswer = '';

  @override
  void initState() {
    super.initState();
    editedQuestion = widget.flashcard.question;
    editedAnswer = widget.flashcard.answer;
  }

  void saveChanges() async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.updateFlashcard(
        widget.flashcard.id, editedQuestion, editedAnswer);
    Navigator.pop(context, widget.flashcard);
  }

  void deleteFlashcard(BuildContext context) async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.deleteFlashcard(widget.flashcard.id);
    widget.refreshCards();

    Navigator.pop(context, widget.flashcard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Edit Flashcard')),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Question',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  TextFormField(
                    initialValue: editedQuestion,
                    cursorColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        editedQuestion = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Answer",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  TextFormField(
                    cursorColor: Colors.green,
                    initialValue: editedAnswer,
                    onChanged: (value) {
                      setState(() {
                        editedAnswer = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (editedQuestion.isEmpty || editedAnswer.isEmpty) {
                        showCustomSnackBar(
                            content:
                                'Please enter a proper data for the flashcard.',
                            context: context,
                            backgroundColor: Colors.red);
                        return;
                      }
                      showCustomSnackBar(
                        content: 'Flashcard Edited Successfully.',
                        context: context,
                      );
                      saveChanges();
                      widget.refreshCards();
                    },
                    child: const Text(
                        style: TextStyle(
                          color: Colors.green,
                        ),
                        'Save'),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      showCustomSnackBar(
                        content: 'Flashcard Deleted Successfully.',
                        context: context,
                      );
                      deleteFlashcard(context);
                      widget.refreshCards();
                    },
                    child: const Text(
                        style: TextStyle(
                          color: Colors.green,
                        ),
                        'Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
