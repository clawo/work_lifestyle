import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();
  static Database? _database;

  UserDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = join(await getDatabasesPath(), filePath);
    return await openDatabase(
      dbPath,
      version: 2, // Version auf 2 erhöht, um die neuen Felder zu unterstützen
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_info(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            token TEXT,
            employmentType TEXT,   -- Spalte für den Beschäftigungs-Typ hinzugefügt
            given_name TEXT,       -- Neues Feld für den Namen
            age INTEGER,           -- Alter als INTEGER
            weight TEXT            -- Neues Feld für das Gewicht
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE user_info ADD COLUMN employmentType TEXT'); // Hinzufügen der Spalte in der Upgrade-Methode
          await db.execute('ALTER TABLE user_info ADD COLUMN given_name TEXT');
          await db.execute('ALTER TABLE user_info ADD COLUMN age INTEGER');
          await db.execute('ALTER TABLE user_info ADD COLUMN weight TEXT');
        }
      },
    );
  }

  /// Methode, um die Login-Informationen zu speichern.
  Future<void> saveLogin(String username, String token) async {
    final db = await database;

    // Überprüfe, ob der Benutzer bereits existiert
    final result = await db.query(
      'user_info',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      await db.update(
        'user_info',
        {'token': token},
        where: 'username = ?',
        whereArgs: [username],
      );
    } else {
      await db.insert(
        'user_info',
        {'username': username, 'token': token},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Methode, um den Employment-Type zu speichern.
  Future<void> saveEmploymentType(String username, String employmentType) async {
    final db = await database;
    await db.update(
      'user_info',
      {'employmentType': employmentType},
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  /// Methode, um den Employment-Type zu erhalten.
  Future<String?> getEmploymentType(String username) async {
    final db = await database;
    final result = await db.query(
      'user_info',
      columns: ['employmentType'],
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      return result.first['employmentType'] as String?;
    }
    return null;
  }

  /// Methode, um die Benutzerdaten zu speichern.
  Future<void> saveUserDetails(String username, String givenName, int age, String weight) async {
    final db = await database;

    // Überprüfe, ob der Benutzer bereits existiert
    final result = await db.query(
      'user_info',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      // Wenn der Benutzer existiert, update die Werte
      await db.update(
        'user_info',
        {
          'given_name': givenName,
          'age': age,
          'weight': weight,
        },
        where: 'username = ?',
        whereArgs: [username],
      );
    } else {
      // Wenn der Benutzer nicht existiert, füge ihn hinzu
      await db.insert(
        'user_info',
        {
          'username': username,
          'given_name': givenName,
          'age': age,
          'weight': weight,
        },
      );
    }
  }

  /// Methode, um die Benutzerdetails zu laden.
  Future<Map<String, dynamic>?> getUserDetails(String username) async {
    final db = await database;
    final result = await db.query(
      'user_info',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  /// Methode, um Benutzerinformationen zu laden.
  Future<Map<String, dynamic>?> loadUser(String username) async {
    final db = await database;
    final result = await db.query(
      'user_info',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
