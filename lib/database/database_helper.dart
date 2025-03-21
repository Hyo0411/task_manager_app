import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_manager_app/core/models/tasks_model.dart';

class DatabaseHelper {
  static Database? _database;
  static const String DB_NAME = 'tasks.db';

  // Đảm bảo rằng chỉ có một instance của database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  // Khởi tạo database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), DB_NAME);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Tạo bảng tasks
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        status INTEGER,
        due_date TEXT,
        created_at TEXT,
        updated_at TEXT
      );
    ''');
  }

  // Thêm công việc mới
  Future<int> insertTask(TaskModel task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  // Lấy tất cả công việc
  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    var res = await db.query('tasks');
    List<TaskModel> tasks = res.isNotEmpty ? res.map((e) => TaskModel.fromMap(e)).toList() : [];
    return tasks;
  }

  // Cập nhật công việc
  Future<int> updateTask(TaskModel task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Xóa công việc
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Đánh dấu công việc là hoàn thành
  Future<int> markAsCompleted(int id) async {
    final db = await database;
    return await db.update(
      'tasks',
      {'status': 1, 'updated_at': DateTime.now().toString()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Đánh dấu công việc là chưa hoàn thành
  Future<int> markAsPending(int id) async {
    final db = await database;
    return await db.update(
      'tasks',
      {'status': 0, 'updated_at': DateTime.now().toString()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
