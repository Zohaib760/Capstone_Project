import 'package:flutter/material.dart';
import '../Models/setting_model.dart';
import '../Services/notification_service.dart';
import '../services/storage_service.dart';



class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storageService = StorageService();
  // final NotificationService _notificationService = NotificationService();

  AppSettings _settings = AppSettings.defaultSettings();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _storageService.initialize();
    // await _notificationService.initialize();

    final notificationsEnabled = _storageService.getBool('notificationsEnabled') ?? true;
    final darkMode = _storageService.getBool('darkMode') ?? false;
    final language = _storageService.getString('language') ?? 'English';

    setState(() {
      _settings = AppSettings(
        notificationsEnabled: notificationsEnabled,
        darkMode: darkMode,
        language: language,
      );
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    await _storageService.setBool('notificationsEnabled', _settings.notificationsEnabled);
    await _storageService.setBool('darkMode', _settings.darkMode);
    await _storageService.setString('language', _settings.language);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Settings saved')),
    );
  }

  // Future<void> _testNotification() async {
  //   await _notificationService.showNotification(
  //     id: 0,
  //     title: 'Test Notification',
  //     body: 'This is a test notification from your app',
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: _settings.notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _settings = _settings.copyWith(notificationsEnabled: value);
                });
              },
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: _settings.darkMode,
              onChanged: (value) {
                setState(() {
                  _settings = _settings.copyWith(darkMode: value);
                });
              },
            ),
            ListTile(
              title: Text('Language'),
              subtitle: Text(_settings.language),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Select Language'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('English'),
                          onTap: () {
                            setState(() {
                              _settings = _settings.copyWith(language: 'English');
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Spanish'),
                          onTap: () {
                            setState(() {
                              _settings = _settings.copyWith(language: 'Spanish');
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('French'),
                          onTap: () {
                            setState(() {
                              _settings = _settings.copyWith(language: 'French');
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 24),
            Text(
              'Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: _testNotification,
            //   child: Text('Test Notification'),
            // ),
            SizedBox(height: 24),
            Text(
              'Account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Change Password'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Implement change password functionality
              },
            ),
            ListTile(
              title: Text('Privacy Policy'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Show privacy policy
              },
            ),
            ListTile(
              title: Text('Terms of Service'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Show terms of service
              },
            ),
          ],
        ),
      ),
    );
  }
}