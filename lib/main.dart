import 'package:flutter/material.dart';
import 'models/task.dart';
import 'presentation/board/board_screen.dart';
import 'package:provider/provider.dart';

import 'router/app_router.dart';

void main() {
  runApp(
    // DevicePreview(
    // enabled: !kReleaseMode,
    // builder: (context) =>
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Tasks()),
      ],
      child: MyApp(
        appRouter: AppRouter(),
      ),
    ),
    // ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({
    Key? key,
    required this.appRouter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do App',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.onGenerateRoute,
      home: const BoardScreen(),
    );
  }
}
