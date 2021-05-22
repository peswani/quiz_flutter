import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:quiz_app/model/notes.dart';
import 'package:quiz_app/model/score.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    _db ??= await initDb();
    return _db;
  }

  static const String NOTE_TABLE = "notes";
  static const String SCORE_TABLE = "scores";

  DatabaseHelper.internal();

  initDb() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentDirectory.path, "main.db");
    var ourDb = await openDatabase(path,
        version: 1, onCreate: _onCreate, onConfigure: onConfigure);
    return ourDb;
  }

  /// Let's use FOREIGN KEY constraints
  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  void _onCreate(Database db, int version) async {
    final queryNote =
        "CREATE TABLE $NOTE_TABLE (id INTEGER, category TEXT, note TEXT,duration INTEGER DEFAULT 0, PRIMARY KEY(id))";
    final scoreTable =
        "CREATE TABLE $SCORE_TABLE (id INTEGER,questionId INTEGER, timeTaken INTEGER DEFAULT 0, isCorrect INTEGER DEFAULT 0, PRIMARY KEY(id))";

    await db.execute(queryNote);
    await db.execute(scoreTable);
  }

  Future<int> saveNote(Notes notes) async {
    var dbClient = await db;
    try {
      int res = await dbClient!.insert(NOTE_TABLE, notes.toMap());
      return res;
    } on DatabaseException catch (e) {
      print(e);
      return -1;
    }
  }

  Future<int> updateNote(Notes note) async {
    var dbClient = await db;
    int res = await dbClient!.update(NOTE_TABLE, note.toMap(),
        where: "id = ?", whereArgs: [note.id]);
    return res;
  }

  Future<List<Notes>> getAllNotes() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps =
        await dbClient!.query(NOTE_TABLE, orderBy: 'duration asc');
    return List.generate(maps.length, (i) {
      return Notes.fromMap(maps[i]);
    });
  }

  Future<void> saveScore(int questionId, int timeTaken, int correct) async {
    var dbClient = await db;

    final result = await dbClient!
        .query(SCORE_TABLE, where: "questionId = ?", whereArgs: [questionId]);

    if (result.length == 0) {
      Score score = Score(questionId, timeTaken, correct);
      int res = await dbClient.insert(SCORE_TABLE, score.toMap());
    }
  }

  Future<int> getTotalTime() async {
    const String query = "select COALESCE(sum(timeTaken), 0) from $SCORE_TABLE";
    return await getSumValue(query);
  }

  Future getSumValue(String query) async {
    final client = await db;

    final value = await client!.rawQuery(query);

    return value.elementAt(0).values.elementAt(0);
  }

  Future<int> getScore() async {
    const String query =
        "select count(isCorrect) from $SCORE_TABLE where isCorrect = 1";
    return await getSumValue(query);
  }

  deleteAll() async {
    final helper = DatabaseHelper();
    final client = await helper.db;
    if (client != null) {
      client.execute("DELETE FROM $SCORE_TABLE");
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
