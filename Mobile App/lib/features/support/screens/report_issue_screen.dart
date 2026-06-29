import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String? _selectedSeverity;
  String? _selectedCategory;
  final _descriptionController = TextEditingController();
  bool _includeLogs = true;

  final List<String> _categories = ['UI / Layout', 'Speed / Lag', 'QR Scanning', 'AI Content Generation', 'Invoicing', 'Other'];
  final List<String> _severities = ['Low (Annoyance)', 'Medium (Hindrance)', 'High (Work Blocked)'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Report Technical Issue', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          const Text('Something not working?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('Provide as much detail as possible so our engineering team can fix it quickly.', style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 32),
          
          _buildDropdownSection('WHERE IS THE ISSUE?', _categories, _selectedCategory, (val) => setState(() => _selectedCategory = val)),
          const SizedBox(height: 24),
          
          _buildDropdownSection('HOW SEVERE IS IT?', _severities, _selectedSeverity, (val) => setState(() => _selectedSeverity = val)),
          const SizedBox(height: 24),

          _buildDescriptionInput(),
          const SizedBox(height: 24),

          _buildLogCaptureToggle(),
          const SizedBox(height: 48),

          _buildSubmitButton(),
          const SizedBox(height: 48),
        ],
      ),
    ),
  );
}

  Widget _buildDropdownSection(String header, List<String> items, String? currentVal, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentVal,
              hint: const Text('Select option', style: TextStyle(fontSize: 14)),
              isExpanded: true,
              items: items.map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontSize: 14)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('DESCRIBE WHAT HAPPENED', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
          ),
          child: TextField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'What steps did you take? What did you expect vs what actually happened?',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogCaptureToggle() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.bug_report_outlined, color: AppColors.primary),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Auto-capture diagnostics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('Includes device model, OS version, and app state.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _includeLogs,
                onChanged: (v) => setState(() => _includeLogs = v),
                activeColor: AppColors.primary,
              ),
            ],
          ),
          if (_includeLogs) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(),
            ),
            Row(
              children: [
                _buildCaptureTag('DEVICE: Pixel 7 Pro'),
                const SizedBox(width: 8),
                _buildCaptureTag('OS: Android 14'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCaptureTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_selectedCategory == null || _descriptionController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all required fields.')));
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report submitted. Ticket ID: #T-9921')));
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 64),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      child: const Text('Submit Report', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
    );
  }
}
