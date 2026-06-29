import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';

class AdminNotificationsScreen extends StatelessWidget {
  const AdminNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('System Alerts', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildAlertSection('Critical Alerts', Colors.redAccent),
          _buildAlertItem(
            title: 'Database Spike',
            message: 'Write operations at 98% of maximum throughput in Region US-East.',
            time: 'Just now',
            color: Colors.redAccent,
            icon: Icons.speed_rounded,
          ),
          _buildAlertItem(
            title: 'Suspicious Activities',
            message: 'Multiple login failures detected from IP 192.168.1.100.',
            time: '12m ago',
            color: Colors.redAccent,
            icon: Icons.security_rounded,
          ),
          const SizedBox(height: 24),
          _buildAlertSection('Platform Updates', AppColors.primary),
          _buildAlertItem(
            title: 'New Merchant Onboarded',
            message: 'Global Mart v2 successfully completed verification.',
            time: '4h ago',
            color: AppColors.primary,
            icon: Icons.storefront_rounded,
          ),
          _buildAlertItem(
            title: 'Weekly Report Ready',
            message: 'The system has generated the weekly usage and revenue report.',
            time: '1d ago',
            color: AppColors.primary,
            icon: Icons.analytics_rounded,
          ),
          const SizedBox(height: 24),
          _buildAlertSection('General Notifications', Colors.grey),
          _buildAlertItem(
            title: 'System Maintenance',
            message: 'Scheduled maintenance complete for Revision v2.4.12.',
            time: '2d ago',
            color: Colors.grey,
            icon: Icons.settings_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertSection(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Text(title.toUpperCase(), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
          const SizedBox(width: 12),
          Expanded(child: Divider(color: color.withOpacity(0.1))),
        ],
      ),
    );
  }

  Widget _buildAlertItem({
    required String title,
    required String message,
    required String time,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(message, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
