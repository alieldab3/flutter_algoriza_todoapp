import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '/models/task.dart';

class TasksDatabase {
  static final TasksDatabase instance = TasksDatabase._init();
  static Database? _database;
  TasksDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todoapp.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    // final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableTasks ( 
  ${TaskFields.id} $idType, 
  ${TaskFields.title} $textType,
  ${TaskFields.date} $textType,
  ${TaskFields.startTime} $textType,
  ${TaskFields.endTime} $textType,
  ${TaskFields.remind} $textType,
  ${TaskFields.repeat} $textType, 
  ${TaskFields.color} $textType,
  ${TaskFields.isDone} $boolType,
  ${TaskFields.isFavourite} $boolType
  )
''');
  }

  Future<TaskItem> create(TaskItem task) async {
    final db = await instance.database;

    // final json = task.toJson();
    // final columns =
    //     '${TaskFields.title}, ${TaskFields.description}, ${TaskFields.time}';
    // final values =
    //     '${json[TaskFields.title]}, ${json[TaskFields.description]}, ${json[TaskFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableTasks, task.toJson());
    return task.copy(id: id);
  }

  Future<TaskItem?> readTask(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTasks,
      columns: TaskFields.values,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TaskItem.fromJson(maps.first);
    } else {
      return null;
      // throw Exception('ID $id not found');
    }
  }

  Future<void> deleteTasksTable() async {
    final db = await instance.database;
    final rowAffected = await db.delete(tableTasks);
    print('The number of rows affected: $rowAffected');
  }

  Future<List<TaskItem>> readAllTasks() async {
    final db = await instance.database;

    final orderBy = '${TaskFields.date} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableTasks ORDER BY $orderBy');

    final result = await db.query(tableTasks, orderBy: orderBy);

    return result.map((json) => TaskItem.fromJson(json)).toList();
  }

  Future<int> update(TaskItem task) async {
    final db = await instance.database;

    return db.update(
      tableTasks,
      task.toJson(),
      where: '${TaskFields.id} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTasks,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
