import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';

class SystemLogsScreen extends StatelessWidget {
  const SystemLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('System Event Logs', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.download_rounded, color: Colors.grey), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildTerminalHeader(),
          Expanded(child: _buildLogList()),
        ],
      ),
    );
  }

  Widget _buildTerminalHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.grey.shade50,
      child: Row(
        children: [
          const Icon(Icons.code_rounded, color: Colors.grey, size: 16),
          const SizedBox(width: 8),
          const Text('STREAMING LIVE CONSOLE', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
            child: const Row(
              children: [
                Icon(Icons.circle, color: Color(0xFF10B981), size: 6),
                SizedBox(width: 6),
                Text('CONNECTED', style: TextStyle(color: Color(0xFF10B981), fontSize: 8, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildDetailedLog('Just now', 'AUTH', 'Login success for UID: #88921 (Alex Sterling)', Icons.login_rounded, Colors.blue),
        _buildDetailedLog('2 mins ago', 'BILLING', 'Subscription renewal successful: Order #IV-1022', Icons.payments_rounded, const Color(0xFF10B981)),
        _buildDetailedLog('5 mins ago', 'SYSTEM', 'Cache cleared for region: US-East-1', Icons.layers_clear_rounded, Colors.grey),
        _buildDetailedLog('12 mins ago', 'API', 'AI Generation request processed: 2.1s latency', Icons.auto_awesome_rounded, Colors.purple),
        _buildDetailedLog('18 mins ago', 'WARNING', 'Rate limit approached for User #7712', Icons.warning_amber_rounded, Colors.orange),
        _buildDetailedLog('25 mins ago', 'ERROR', 'Failed to upload asset: ERR_CONN_TIMEOUT', Icons.error_outline_rounded, Colors.red),
        _buildDetailedLog('40 mins ago', 'AUTH', 'New user registered from IP: 192.168.1.1', Icons.person_add_rounded, Colors.blue),
        _buildDetailedLog('1 hour ago', 'SYSTEM', 'Daily automated database backup completed', Icons.storage_rounded, Colors.grey),
      ],
    );
  }

  Widget _buildDetailedLog(String time, String tag, String message, IconData icon, Color tagColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: tagColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: tagColor, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tag, style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                    Text(time, style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(message, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
