import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mp3/models/flash_card_model.dart';

/// This class provides methods to interact with a SQLite database to perform CRUD operations
/// for managing decks and flashcards.
class DBHelper {
  static const String _databaseName = 'flashcards.db';
  static const int _databaseVersion = 1;

  DBHelper._();

  static final DBHelper _singleton = DBHelper._();

  factory DBHelper() => _singleton;

  Database? _database;

  /// Getter for accessing the database instance asynchronously.

  get db async {
    _database ??= await _initDatabase();
    return _database;
  }

  /// Initializes the database by creating tables if they don't exist.

  Future<Database> _initDatabase() async {
    var dbDir = await getApplicationDocumentsDirectory();
    var dbPath = path.join(dbDir.path, _databaseName);

    var db = await openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        await _createDecksTable(db);
        await _createFlashcardsTable(db);
      },
    );

    return db;
  }

  /// Creates the 'decks' table in the database.

  Future<void> _createDecksTable(Database db) async {
    await db.execute('''
      CREATE TABLE decks(
        id INTEGER PRIMARY KEY,
        title TEXT
      )
    ''');
  }

  /// Creates the 'flashcards' table in the database.

  Future<void> _createFlashcardsTable(Database db) async {
    await db.execute('''
      CREATE TABLE flashcards(
        id INTEGER PRIMARY KEY,
        question TEXT,
        answer TEXT,
        deck_id INTEGER,
        FOREIGN KEY (deck_id) REFERENCES decks(id)
      )
    ''');
  }

  Future<int> insertDeck(String title) async {
    final db = await this.db;
    return db.insert('decks', {'title': title});
  }

  /// Updates an existing deck in the database.

  Future<int> updateDeck(int id, String title) async {
    final db = await this.db;
    return db.update('decks', {'title': title},
        where: 'id = ?', whereArgs: [id]);
  }

  /// Deletes a deck and its associated flashcards from the database.

  Future<void> deleteDeck(int id) async {
    final db = await this.db;
    await db.delete('decks', where: 'id = ?', whereArgs: [id]);
    await db.delete('flashcards', where: 'deck_id = ?', whereArgs: [id]);
  }

  /// Retrieves all decks from the database.

  Future<List<Map<String, dynamic>>> getDecks() async {
    final db = await this.db;
    return db.query('decks');
  }
  // CRUD operations for flashcards
  /// Inserts a new flashcard into the database.

  Future<int> insertFlashcard(
      String question, String answer, int deckId) async {
    final db = await this.db;
    final card = {
      'question': question,
      'answer': answer,
      'deck_id': deckId,
    };

    final cardId = await db.insert('flashcards', card);
    return cardId;
  }

  /// Updates an existing flashcard in the database.

  Future<int> updateFlashcard(int id, String question, String answer) async {
    final db = await this.db;
    return db.update('flashcards', {'question': question, 'answer': answer},
        where: 'id = ?', whereArgs: [id]);
  }

  /// Deletes a flashcard from the database.

  Future<void> deleteFlashcard(int id) async {
    final db = await this.db;
    await db.delete('flashcards', where: 'id = ?', whereArgs: [id]);
  }

  /// Retrieves all flashcards belonging to a specific deck from the database.

  Future<List<Map<String, dynamic>>> getFlashcards(int deckId) async {
    final db = await this.db;
    return db.query('flashcards', where: 'deck_id = ?', whereArgs: [deckId]);
  }

  /// Retrieves all flashcards and their associated deck from the database for a given deck ID.

  Future<List<Map<String, dynamic>>> getDeckWithFlashcards(int deckId) async {
    final db = await this.db;
    return db.rawQuery('''
      SELECT decks.id AS deck_id, decks.title, flashcards.id AS flashcard_id, flashcards.question, flashcards.answer
      FROM decks
      LEFT JOIN flashcards ON decks.id = flashcards.deck_id
      WHERE decks.id = ?
    ''', [deckId]);
  }

  /// Retrieves the title of a deck based on its ID from the database.

  Future<String> fetchDeckTitle(int deckId) async {
    final db = await this.db;
    var res = await db.query('decks', where: 'id = ?', whereArgs: [deckId]);
    if (res.isNotEmpty) {
      return res.first['title'];
    }
    return 'Deck Title';
  }

  /// Fetches all flashcards belonging to a specific deck from the database.

  Future<List<Flashcard>> fetchCardsForDeck(int deckId) async {
    final db = await this.db;
    final cards = await db.query(
      'flashcards',
      where: 'deck_id = ?',
      whereArgs: [deckId],
    );

    return List.generate(cards.length, (index) {
      return Flashcard.fromMap(cards[index]);
    });
  }
}
