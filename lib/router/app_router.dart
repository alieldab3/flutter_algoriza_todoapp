import 'package:flutter/material.dart';

import '/presentation/add_task/add_task_screen.dart';
import '/presentation/board/board_screen.dart';
import '/presentation/schedule/schedule_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const BoardScreen(),
        );
      case '/add-task':
        return MaterialPageRoute(
          builder: (_) => const AddTaskScreen(),
        );
      case '/schedule':
        return MaterialPageRoute(
          builder: (_) => const ScheduleScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const BoardScreen(),
        );
    }
  }
}
