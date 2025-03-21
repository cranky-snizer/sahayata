import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../models/user_profile.dart';
import '../widgets/animated_list_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = provider.profile;
        if (profile == null) {
          return const Center(child: Text('Error loading profile'));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Personal'),
                Tab(text: 'Preferences'),
                Tab(text: 'Categories'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildPersonalTab(context, profile, provider),
              _buildPreferencesTab(context, profile, provider),
              _buildCategoriesTab(context, profile, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPersonalTab(BuildContext context, UserProfile profile, ProfileProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'profile_photo',
                child: GestureDetector(
                  onTap: () {
                    // TODO: Implement photo upload
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: profile.photoUrl != null
                        ? NetworkImage(profile.photoUrl!)
                        : null,
                    child: profile.photoUrl == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            AnimatedListItem(
              child: TextFormField(
                initialValue: profile.name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  provider.updateProfileFields({'name': value});
                },
              ),
            ),
            const SizedBox(height: 16),
            AnimatedListItem(
              child: TextFormField(
                initialValue: profile.email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  provider.updateProfileFields({'email': value});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesTab(BuildContext context, UserProfile profile, ProfileProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedListItem(
            child: Card(
              child: ListTile(
                title: const Text('Theme Mode'),
                subtitle: Text(profile.themeMode.toUpperCase()),
                trailing: DropdownButton<String>(
                  value: profile.themeMode,
                  items: ['light', 'dark', 'system'].map((mode) {
                    return DropdownMenuItem(
                      value: mode,
                      child: Text(mode.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      provider.updateThemeMode(value);
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedListItem(
            child: Card(
              child: SwitchListTile(
                title: const Text('Notifications'),
                subtitle: const Text('Enable or disable notifications'),
                value: profile.notificationsEnabled,
                onChanged: (value) {
                  provider.updateProfileFields({
                    'notificationsEnabled': value,
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedListItem(
            child: Card(
              child: ListTile(
                title: const Text('Default Reminder Time'),
                subtitle: Text('${profile.defaultReminderTime} minutes before'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Show reminder time picker
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedListItem(
            child: Card(
              child: ListTile(
                title: const Text('Working Days'),
                subtitle: Text(profile.workingDays.join(', ')),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Show working days picker
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab(BuildContext context, UserProfile profile, ProfileProvider provider) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: profile.categories.length,
            itemBuilder: (context, index) {
              final category = profile.categories[index];
              final color = profile.categoryColors[category] ?? Colors.grey;

              return AnimatedListItem(
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color,
                      child: Text(
                        category[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(category),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.color_lens),
                          onPressed: () {
                            // TODO: Show color picker
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            provider.removeCategory(category);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Category'),
            onPressed: () {
              // TODO: Show add category dialog
            },
          ),
        ),
      ],
    );
  }
} 