import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VendorNotificationsScreen extends StatefulWidget {
  final String vendorId;

  const VendorNotificationsScreen({
    super.key,
    required this.vendorId,
  });

  @override
  State<VendorNotificationsScreen> createState() =>
      _VendorNotificationsScreenState();
}

class _VendorNotificationsScreenState
    extends State<VendorNotificationsScreen> {
  bool _loading = true;
  List notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.vegiffyy.com/api/vendor/notification/${widget.vendorId}',
        ),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          notifications = data['data'] ?? [];
        });
      }
    } catch (_) {
      // silent
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(
                  child: Text(
                    'No notifications available',
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final n = notifications[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.notifications),
                        title: Text(
                          n['title'] ?? 'Notification',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(n['message'] ?? ''),
                        trailing: Text(
                          n['createdAt'] ?? '',
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
