import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // create a method to show notification
  void _notification() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 1,
      channelKey: 'basic_channel',
      title: 'Test Notification',
      body: 'This is a test notification',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _notification,
          child: Text('Test Notification'),
        ),
      ),
    );
  }
}
