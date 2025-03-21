import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/routine_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/animated_list_item.dart';
import '../widgets/time_slot_card.dart';
import '../models/daily_routine.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedTimeSlot = 'Morning';

  @override
  Widget build(BuildContext context) {
    return Consumer3<TaskProvider, RoutineProvider, ProfileProvider>(
      builder: (context, taskProvider, routineProvider, profileProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('SAHAYATA'),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () {
                  // TODO: Implement profile
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                taskProvider.loadTasks(),
                routineProvider.loadRoutines(),
                profileProvider.loadProfile(),
              ]);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeSection(profileProvider),
                    const SizedBox(height: 24),
                    _buildDailyOverview(context, taskProvider),
                    const SizedBox(height: 24),
                    _buildTimeSlots(context, routineProvider),
                    const SizedBox(height: 24),
                    _buildQuickStats(context, taskProvider, routineProvider),
                    const SizedBox(height: 24),
                    _buildTodaysSchedule(context, routineProvider),
                    const SizedBox(height: 24),
                    _buildQuickActions(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection(ProfileProvider provider) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return AnimatedListItem(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, ${provider.profile?.name ?? 'User'}',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Here\'s your daily overview',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlots(BuildContext context, RoutineProvider provider) {
    final timeSlots = [
      {
        'title': 'Morning',
        'timeRange': '6:00 AM - 12:00 PM',
        'color': Colors.orange,
      },
      {
        'title': 'Afternoon',
        'timeRange': '12:00 PM - 5:00 PM',
        'color': Colors.blue,
      },
      {
        'title': 'Evening',
        'timeRange': '5:00 PM - 10:00 PM',
        'color': Colors.purple,
      },
      {
        'title': 'Night',
        'timeRange': '10:00 PM - 6:00 AM',
        'color': Colors.indigo,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Slots',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: timeSlots.length,
            itemBuilder: (context, index) {
              final slot = timeSlots[index];
              final routines = provider.getRoutinesForTimeSlot(
                provider.timeSlots[index],
              );

              return TimeSlotCard(
                title: slot['title'] as String,
                timeRange: slot['timeRange'] as String,
                routines: routines,
                color: slot['color'] as Color,
                isSelected: _selectedTimeSlot == slot['title'],
                onTap: () {
                  setState(() {
                    _selectedTimeSlot = slot['title'] as String;
                  });
                  // TODO: Show time slot details
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDailyOverview(BuildContext context, TaskProvider provider) {
    final completedTasks = provider.tasks.where((task) => task.isCompleted).length;
    final totalTasks = provider.tasks.length;
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return AnimatedListItem(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    DateTime.now().toString().split(' ')[0],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$completedTasks/$totalTasks Tasks Completed',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    TaskProvider taskProvider,
    RoutineProvider routineProvider,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildStatCard(
          context,
          'Tasks',
          '${taskProvider.tasks.length}',
          Icons.task,
          Theme.of(context).colorScheme.primary,
        ),
        _buildStatCard(
          context,
          'Routines',
          '${routineProvider.routines.length}',
          Icons.repeat,
          Theme.of(context).colorScheme.secondary,
        ),
        _buildStatCard(
          context,
          'Follow-ups',
          '2',
          Icons.follow_the_signs,
          Colors.green,
        ),
        _buildStatCard(
          context,
          'Meetings',
          '1',
          Icons.meeting_room,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return AnimatedListItem(
      child: Card(
        child: InkWell(
          onTap: () {
            // TODO: Navigate to respective section
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
                const SizedBox(height: 8),
                Text(
                  count,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodaysSchedule(BuildContext context, RoutineProvider provider) {
    final routines = provider.getRoutinesForDay(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Schedule",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                // TODO: View all schedule
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: routines.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final routine = routines[index];
              return AnimatedListItem(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(routine.title),
                  subtitle: Text(
                    '${routine.startTime.hour}:${routine.startTime.minute.toString().padLeft(2, '0')} - ${routine.endTime.hour}:${routine.endTime.minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Show routine details
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              context,
              'Add Task',
              Icons.add_task,
              Theme.of(context).colorScheme.primary,
              () {
                // TODO: Add task
              },
            ),
            _buildActionButton(
              context,
              'Set Routine',
              Icons.repeat,
              Theme.of(context).colorScheme.secondary,
              () {
                // TODO: Set routine
              },
            ),
            _buildActionButton(
              context,
              'Schedule Meeting',
              Icons.group_add,
              Colors.purple,
              () {
                // TODO: Schedule meeting
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return AnimatedListItem(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(icon, color: color),
              onPressed: onPressed,
              padding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
} 