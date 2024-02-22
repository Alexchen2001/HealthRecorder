// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  EmotionRecorderDao? _emotionRecorderDaoInstance;

  DietRecorderDao? _dietRecorderDaoInstance;

  WorkoutRecorderDao? _workoutRecorderDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `EmotionEntry` (`recordID` INTEGER PRIMARY KEY AUTOINCREMENT, `appType` TEXT NOT NULL, `recordedEmoji` TEXT NOT NULL, `recordedTime` TEXT NOT NULL, `recordedPts` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `DietEntry` (`recordID` INTEGER PRIMARY KEY AUTOINCREMENT, `appType` TEXT NOT NULL, `recordedDiet` TEXT NOT NULL, `recordedCalorie` TEXT NOT NULL, `recordedTime` TEXT NOT NULL, `recordedPts` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `WorkoutEntry` (`recordID` INTEGER PRIMARY KEY AUTOINCREMENT, `appType` TEXT NOT NULL, `recordedWorkout` TEXT NOT NULL, `recordedAmt` TEXT NOT NULL, `recordedTime` TEXT NOT NULL, `recordedPts` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  EmotionRecorderDao get emotionRecorderDao {
    return _emotionRecorderDaoInstance ??=
        _$EmotionRecorderDao(database, changeListener);
  }

  @override
  DietRecorderDao get dietRecorderDao {
    return _dietRecorderDaoInstance ??=
        _$DietRecorderDao(database, changeListener);
  }

  @override
  WorkoutRecorderDao get workoutRecorderDao {
    return _workoutRecorderDaoInstance ??=
        _$WorkoutRecorderDao(database, changeListener);
  }
}

class _$EmotionRecorderDao extends EmotionRecorderDao {
  _$EmotionRecorderDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _emotionEntryInsertionAdapter = InsertionAdapter(
            database,
            'EmotionEntry',
            (EmotionEntry item) => <String, Object?>{
                  'recordID': item.recordID,
                  'appType': item.appType,
                  'recordedEmoji': item.recordedEmoji,
                  'recordedTime': item.recordedTime,
                  'recordedPts': item.recordedPts
                }),
        _emotionEntryDeletionAdapter = DeletionAdapter(
            database,
            'EmotionEntry',
            ['recordID'],
            (EmotionEntry item) => <String, Object?>{
                  'recordID': item.recordID,
                  'appType': item.appType,
                  'recordedEmoji': item.recordedEmoji,
                  'recordedTime': item.recordedTime,
                  'recordedPts': item.recordedPts
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<EmotionEntry> _emotionEntryInsertionAdapter;

  final DeletionAdapter<EmotionEntry> _emotionEntryDeletionAdapter;

  @override
  Future<List<EmotionEntry>> listAllRecords() async {
    return _queryAdapter.queryList('SELECT * FROM EmotionEntry',
        mapper: (Map<String, Object?> row) => EmotionEntry(
            recordID: row['recordID'] as int?,
            appType: row['appType'] as String,
            recordedEmoji: row['recordedEmoji'] as String,
            recordedTime: row['recordedTime'] as String,
            recordedPts: row['recordedPts'] as int));
  }

  @override
  Future<int?> getCountOfAllEntry() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM EmotionEntry',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getSumOfPoints() async {
    return _queryAdapter.query(
        'SELECT COALESCE(SUM(recordedPts), 0) FROM EmotionEntry',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<EmotionEntry?> getLastRecord() async {
    return _queryAdapter.query(
        'SELECT * FROM EmotionEntry ORDER BY recordID DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => EmotionEntry(
            recordID: row['recordID'] as int?,
            appType: row['appType'] as String,
            recordedEmoji: row['recordedEmoji'] as String,
            recordedTime: row['recordedTime'] as String,
            recordedPts: row['recordedPts'] as int));
  }

  @override
  Future<void> addEmotionEntry(EmotionEntry entry) async {
    await _emotionEntryInsertionAdapter.insert(entry, OnConflictStrategy.abort);
  }

  @override
  Future<int> removeEmotionRec(EmotionEntry entry) {
    return _emotionEntryDeletionAdapter.deleteAndReturnChangedRows(entry);
  }
}

class _$DietRecorderDao extends DietRecorderDao {
  _$DietRecorderDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _dietEntryInsertionAdapter = InsertionAdapter(
            database,
            'DietEntry',
            (DietEntry item) => <String, Object?>{
                  'recordID': item.recordID,
                  'appType': item.appType,
                  'recordedDiet': item.recordedDiet,
                  'recordedCalorie': item.recordedCalorie,
                  'recordedTime': item.recordedTime,
                  'recordedPts': item.recordedPts
                }),
        _dietEntryDeletionAdapter = DeletionAdapter(
            database,
            'DietEntry',
            ['recordID'],
            (DietEntry item) => <String, Object?>{
                  'recordID': item.recordID,
                  'appType': item.appType,
                  'recordedDiet': item.recordedDiet,
                  'recordedCalorie': item.recordedCalorie,
                  'recordedTime': item.recordedTime,
                  'recordedPts': item.recordedPts
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DietEntry> _dietEntryInsertionAdapter;

  final DeletionAdapter<DietEntry> _dietEntryDeletionAdapter;

  @override
  Future<List<DietEntry>> listAllRecords() async {
    return _queryAdapter.queryList('SELECT * FROM DietEntry',
        mapper: (Map<String, Object?> row) => DietEntry(
            recordID: row['recordID'] as int?,
            appType: row['appType'] as String,
            recordedDiet: row['recordedDiet'] as String,
            recordedCalorie: row['recordedCalorie'] as String,
            recordedTime: row['recordedTime'] as String,
            recordedPts: row['recordedPts'] as int));
  }

  @override
  Future<int?> getCountOfAllEntry() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM DietEntry',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> changeDietAmt(
    int idVal,
    String cRecord,
  ) async {
    return _queryAdapter.query(
        'UPDATE DietEntry SET recordedCalorie = ?2 WHERE recordID = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [idVal, cRecord]);
  }

  @override
  Future<int?> getSumOfPoints() async {
    return _queryAdapter.query(
        'SELECT COALESCE(SUM(recordedPts), 0) FROM DietEntry',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<DietEntry?> getLastRecord() async {
    return _queryAdapter.query(
        'SELECT * FROM DietEntry ORDER BY recordID DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => DietEntry(
            recordID: row['recordID'] as int?,
            appType: row['appType'] as String,
            recordedDiet: row['recordedDiet'] as String,
            recordedCalorie: row['recordedCalorie'] as String,
            recordedTime: row['recordedTime'] as String,
            recordedPts: row['recordedPts'] as int));
  }

  @override
  Future<void> addDietEntry(DietEntry entry) async {
    await _dietEntryInsertionAdapter.insert(entry, OnConflictStrategy.abort);
  }

  @override
  Future<int> removeDietRec(DietEntry entry) {
    return _dietEntryDeletionAdapter.deleteAndReturnChangedRows(entry);
  }
}

class _$WorkoutRecorderDao extends WorkoutRecorderDao {
  _$WorkoutRecorderDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _workoutEntryInsertionAdapter = InsertionAdapter(
            database,
            'WorkoutEntry',
            (WorkoutEntry item) => <String, Object?>{
                  'recordID': item.recordID,
                  'appType': item.appType,
                  'recordedWorkout': item.recordedWorkout,
                  'recordedAmt': item.recordedAmt,
                  'recordedTime': item.recordedTime,
                  'recordedPts': item.recordedPts
                }),
        _workoutEntryDeletionAdapter = DeletionAdapter(
            database,
            'WorkoutEntry',
            ['recordID'],
            (WorkoutEntry item) => <String, Object?>{
                  'recordID': item.recordID,
                  'appType': item.appType,
                  'recordedWorkout': item.recordedWorkout,
                  'recordedAmt': item.recordedAmt,
                  'recordedTime': item.recordedTime,
                  'recordedPts': item.recordedPts
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WorkoutEntry> _workoutEntryInsertionAdapter;

  final DeletionAdapter<WorkoutEntry> _workoutEntryDeletionAdapter;

  @override
  Future<List<WorkoutEntry>> listAllRecords() async {
    return _queryAdapter.queryList('SELECT * FROM WorkoutEntry',
        mapper: (Map<String, Object?> row) => WorkoutEntry(
            recordID: row['recordID'] as int?,
            appType: row['appType'] as String,
            recordedWorkout: row['recordedWorkout'] as String,
            recordedAmt: row['recordedAmt'] as String,
            recordedTime: row['recordedTime'] as String,
            recordedPts: row['recordedPts'] as int));
  }

  @override
  Future<int?> getCountOfAllEntry() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM WorkoutEntry',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> changeWorkoutAmt(
    int newVal,
    int cRecord,
  ) async {
    return _queryAdapter.query(
        'UPDATE WorkoutEntry SET recordedAmt = ?1 WHERE recordID = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [newVal, cRecord]);
  }

  @override
  Future<int?> getSumOfPoints() async {
    return _queryAdapter.query(
        'SELECT COALESCE(SUM(recordedPts), 0) FROM WorkoutEntry',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<WorkoutEntry?> getLastRecord() async {
    return _queryAdapter.query(
        'SELECT * FROM WorkoutEntry ORDER BY recordID DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => WorkoutEntry(
            recordID: row['recordID'] as int?,
            appType: row['appType'] as String,
            recordedWorkout: row['recordedWorkout'] as String,
            recordedAmt: row['recordedAmt'] as String,
            recordedTime: row['recordedTime'] as String,
            recordedPts: row['recordedPts'] as int));
  }

  @override
  Future<void> addWorkoutEntry(WorkoutEntry entry) async {
    await _workoutEntryInsertionAdapter.insert(entry, OnConflictStrategy.abort);
  }

  @override
  Future<int> removeWorkoutRec(WorkoutEntry entry) {
    return _workoutEntryDeletionAdapter.deleteAndReturnChangedRows(entry);
  }
}
