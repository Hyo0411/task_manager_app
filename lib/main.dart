import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/config/theme_provider.dart';
import 'package:task_manager_app/core/models/tasks_model.dart';
import 'package:task_manager_app/core/view_models/tasks_view_model.dart';
import 'package:task_manager_app/ui/views/home_view.dart';
import 'package:task_manager_app/ui/views/setting_view.dart';
import 'package:task_manager_app/ui/views/task_add_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => TaskListViewModel()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Task Manager App",
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => HomeView());

          case '/add_task':
            var task = settings.arguments as TaskModel?;
            return MaterialPageRoute(builder: (_) => TaskAddScreen(task: task));

          case '/settings':
            return MaterialPageRoute(builder: (_) => SettingsView());
          default:
            return MaterialPageRoute(
              builder:
                  (_) => Scaffold(
                    body: Center(
                      child: Text(
                        "Không tìm thấy màn hình cần đến vui lòng kiểm tra lại",
                      ),
                    ),
                  ),
            );
        }
      },
    );
  }
}
