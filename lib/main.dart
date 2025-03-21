import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'providers/routine_provider.dart';
import 'providers/profile_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/reminders_screen.dart';
import 'screens/followups_screen.dart';
import 'screens/meetings_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/task_calendar.dart';
import 'widgets/task_list.dart';
import 'widgets/add_task_dialog.dart';
import 'helpers/database_helper.dart';
import 'theme/app_theme.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => RoutineProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ],
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          return MaterialApp(
            title: 'SAHAYATA',
            theme: AppTheme.theme,
            home: const HomeScreen(),
            routes: {
              '/profile': (context) => const ProfileScreen(),
            },
          );
        },
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
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const DashboardScreen(),
    const TasksScreen(),
    const RemindersScreen(),
    const FollowupsScreen(),
    const MeetingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load tasks, routines, and profile when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
      context.read<RoutineProvider>().loadRoutines();
      context.read<RoutineProvider>().initializeTimeSlots();
      context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SAHAYATA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Reminders',
          ),
          NavigationDestination(
            icon: Icon(Icons.follow_the_signs_outlined),
            selectedIcon: Icon(Icons.follow_the_signs),
            label: 'Follow-ups',
          ),
          NavigationDestination(
            icon: Icon(Icons.meeting_room_outlined),
            selectedIcon: Icon(Icons.meeting_room),
            label: 'Meetings',
          ),
        ],
      ),
    );
  }
}
