import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskList extends StatelessWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        if (taskProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (taskProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  taskProvider.error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    taskProvider.clearError();
                    taskProvider.loadTasks();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final tasks = taskProvider.tasks;

        if (tasks.isEmpty) {
          return const Center(
            child: Text('No tasks for this date'),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Dismissible(
              key: Key(task.id.toString()),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                taskProvider.deleteTask(task.id!);
              },
              child: ListTile(
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (bool? value) {
                    taskProvider.toggleTaskCompletion(task);
                  },
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.isCompleted ? Colors.grey : null,
                  ),
                ),
                subtitle: task.description != null
                    ? Text(
                        task.description!,
                        style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: task.isCompleted ? Colors.grey : null,
                        ),
                      )
                    : null,
                trailing: task.dueDate != null
                    ? Text(
                        '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                        style: TextStyle(
                          color: task.isCompleted ? Colors.grey : null,
                        ),
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }
} 