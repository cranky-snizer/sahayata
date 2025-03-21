import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_calendar.dart';
import '../widgets/task_list.dart';
import '../widgets/add_task_dialog.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const TaskCalendar(),
          Expanded(
            child: TaskList(),
          ),
        ],
      ),
      floatingActionButton: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddTaskDialog(
                  selectedDate: taskProvider.selectedDate,
                ),
              );
            },
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
} 