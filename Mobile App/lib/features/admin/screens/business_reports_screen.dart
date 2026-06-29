import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';

class BusinessReportsScreen extends StatefulWidget {
  const BusinessReportsScreen({super.key});

  @override
  State<BusinessReportsScreen> createState() => _BusinessReportsScreenState();
}

class _BusinessReportsScreenState extends State<BusinessReportsScreen> {
  String _selectedReportType = 'Revenue & Payouts';
  final List<String> _reportTypes = ['Revenue & Payouts', 'User Growth', 'QR Performance', 'Subscription Retention', 'Platform Security'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Business Reports', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Automated Intelligence', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  const Text('Generate detailed PDF or CSV reports for any platform metric.', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 32),
                  
                  _buildReportTypeSelector(),
                  const SizedBox(height: 24),
                  
                  _buildDateRangePicker(),
                  const SizedBox(height: 32),
                  
                  _buildGenerateButton(),
                ],
              ),
            ),
            const Divider(),
            _buildExportHistory(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('SELECT REPORT TYPE', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.lightGrey.withOpacity(0.5))),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedReportType,
              isExpanded: true,
              items: _reportTypes.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)))).toList(),
              onChanged: (val) => setState(() => _selectedReportType = val!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TIME PERIOD', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.lightGrey.withOpacity(0.5))),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Oct 01, 2023 - Oct 31, 2023', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('Full Month Report', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('Change', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report generation started. We\'ll notify you when it\'s ready.')));
      },
      icon: const Icon(Icons.auto_graph_rounded),
      label: const Text('Generate Report', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 64),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
    );
  }

  Widget _buildExportHistory() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('RECENT EXPORTS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          const SizedBox(height: 16),
          _buildHistoryItem('Q3_Performance_Final.pdf', 'Oct 24, 2023', '2.4 MB'),
          const SizedBox(height: 12),
          _buildHistoryItem('Revenue_Stream_Daily.csv', 'Oct 22, 2023', '145 KB'),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String name, String date, String size) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.lightGrey.withOpacity(0.5))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
            child: Icon(name.endsWith('.pdf') ? Icons.picture_as_pdf_rounded : Icons.table_chart_rounded, color: name.endsWith('.pdf') ? Colors.red.shade400 : Colors.green.shade400),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('$date • $size', style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded, color: AppColors.primary, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
