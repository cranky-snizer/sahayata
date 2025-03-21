import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'widgets/task_calendar.dart';
import 'widgets/task_list.dart';
import 'widgets/add_task_dialog.dart';
import 'helpers/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await DatabaseHelper.instance.database;
    runApp(const MyApp());
  } catch (e) {
    print('Error initializing database: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'SAHAYATA',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load tasks when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SAHAYATA'),
        centerTitle: true,
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return Column(
            children: [
              const TaskCalendar(),
              Expanded(
                child: TaskList(),
              ),
            ],
          );
        },
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
