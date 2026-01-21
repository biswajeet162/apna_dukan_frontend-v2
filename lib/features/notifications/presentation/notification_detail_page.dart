import 'package:flutter/material.dart';

class NotificationDetailPage extends StatelessWidget {
  final String notificationId;

  const NotificationDetailPage({
    super.key,
    required this.notificationId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Center(
        child: Text('Notification Details for ID: $notificationId'),
      ),
    );
  }
}
