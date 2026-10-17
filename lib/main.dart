import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'taskflow_page.dart';

void main() => runApp(const TaskFlowApp());

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const TaskflowPage(),
    );
  }
}
