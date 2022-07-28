// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../db/tasks_database.dart';

const String tableTasks = 'tasks';

class TaskFields {
  static final List<String> values = [
    /// Add all fields
    id, title, date, startTime, endTime, remind, repeat, color, isDone,
    isFavourite
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String date = 'date';
  static const String startTime = 'startTime';
  static const String endTime = 'endTime';
  static const String remind = 'remind';
  static const String repeat = 'repeat';
  static const String color = 'color';
  static const String isDone = 'isDone';
  static const String isFavourite = 'isFavourite';
}

class TaskItem with ChangeNotifier {
  final int? id;
  final String title;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String remind;
  final String repeat;
  final Color color;
  bool isDone;
  bool isFavourite;

  TaskItem({
    this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.remind,
    required this.repeat,
    required this.color,
    this.isDone = false,
    this.isFavourite = false,
  });

  TaskItem copy({
    int? id,
    String? title,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? remind,
    String? repeat,
    Color? color,
    bool? isDone,
    bool? isFavourite,
  }) =>
      TaskItem(
        id: id ?? this.id,
        title: title ?? this.title,
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        remind: remind ?? this.remind,
        repeat: repeat ?? this.repeat,
        color: color ?? this.color,
        isDone: isDone ?? this.isDone,
        isFavourite: isFavourite ?? this.isFavourite,
      );

  static TaskItem fromJson(Map<String, Object?> json) => TaskItem(
        id: json[TaskFields.id] as int?,
        title: json[TaskFields.title] as String,
        date: DateTime.parse(json[TaskFields.date] as String),
        startTime: TimeOfDay.fromDateTime(
            DateTime.parse(json[TaskFields.startTime] as String)),
        endTime: TimeOfDay.fromDateTime(
            DateTime.parse(json[TaskFields.endTime] as String)),
        remind: json[TaskFields.remind] as String,
        repeat: json[TaskFields.repeat] as String,
        color: Color(
          int.parse(
            (json[TaskFields.color] as String).split('(0x')[1].split(')')[0],
            radix: 16,
          ),
        ),
        isDone: json[TaskFields.isDone] == 1,
        isFavourite: json[TaskFields.isFavourite] == 1,
      );

  Map<String, Object?> toJson() => {
        TaskFields.id: id,
        TaskFields.title: title,
        TaskFields.date: date.toIso8601String(),
        TaskFields.startTime:
            DateTime(1969, 1, 1, startTime.hour, startTime.minute)
                .toIso8601String(),
        TaskFields.endTime: DateTime(1969, 1, 1, endTime.hour, endTime.minute)
            .toIso8601String(),
        TaskFields.remind: remind,
        TaskFields.repeat: repeat,
        TaskFields.color: color.toString(),
        TaskFields.isDone: isDone ? 1 : 0,
        TaskFields.isFavourite: isFavourite ? 1 : 0,
      };


  void toggleDoneStatus() async {
    isDone = !isDone;
    notifyListeners();
  }


  void toggleFavouriteStatus() async {
    isFavourite = !isFavourite;
    notifyListeners();
  }

  @override
  String toString() {
    return 'TaskItem(id: $id, title: $title, date: $date, startTime: $startTime, endTime: $endTime, remind: $remind, repeat: $repeat, color: $color, isDone: $isDone, isFavourite: $isFavourite)';
  }
}

class Tasks with ChangeNotifier {
  List<TaskItem> _tasks = [];

  List<TaskItem> get tasks {
    return [..._tasks];
  }

  Future<List<TaskItem>> getAllTasks() async {
    try {
      List<TaskItem> list = await TasksDatabase.instance.readAllTasks();
      _tasks = list;
      notifyListeners();
      return list;
    } catch (error) {
      rethrow;
    }
  }

  Future<TaskItem?> findTaskbyId(int id) async {
    try {
      final found = await TasksDatabase.instance.readTask(id);
      return found;
    } catch (error) {
      rethrow;
    }
  }

  List<TaskItem> findTaskbyDate(DateTime date) {
    try {
      return _tasks
          .where(
            (taskItem) => ((taskItem.date.year == date.year) &&
                (taskItem.date.month == date.month) &&
                (taskItem.date.day == date.day)),
          )
          .toList();
    } catch (error) {
      rethrow;
    }
  }

  List<TaskItem> findUncompletedTasks() {
    return _tasks.where((taskItem) => taskItem.isDone == false).toList();
  }

  List<TaskItem> findCompletedTasks() {
    return _tasks.where((taskItem) => taskItem.isDone == true).toList();
  }

  List<TaskItem> findFavouriteTasks() {
    return _tasks.where((taskItem) => taskItem.isFavourite == true).toList();
  }

  Future<void> addTask(TaskItem task) async {
    try {
      final newTask = await TasksDatabase.instance.create(task);
      _tasks.add(newTask);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateTask(TaskItem newTask) async {
    try {
      await TasksDatabase.instance.update(newTask);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await TasksDatabase.instance.delete(id);
      _tasks.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
