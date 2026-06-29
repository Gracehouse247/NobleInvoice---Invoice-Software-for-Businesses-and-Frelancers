import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/features/business_card/controllers/business_card_controller.dart';
import 'package:noble_invoice/features/business_card/models/business_card_model.dart';
import 'package:noble_invoice/features/wallet/controllers/subscription_controller.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';

class EditCardDetailsSheet extends StatefulWidget {
  final BusinessCard card;
  const EditCardDetailsSheet({super.key, required this.card});

  @override
  State<EditCardDetailsSheet> createState() => _EditCardDetailsSheetState();
}

class _EditCardDetailsSheetState extends State<EditCardDetailsSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.card.customName);
    _titleController = TextEditingController(text: widget.card.customTitle);
    _phoneController = TextEditingController(text: widget.card.customPhone);
    _emailController = TextEditingController(text: widget.card.customEmail);
    _websiteController = TextEditingController(text: widget.card.customWebsite);
    _addressController = TextEditingController(text: widget.card.customAddress);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final cardCtrl = context.read<BusinessCardController>();
    final updatedCard = widget.card.copyWith(
      customName: _nameController.text.trim(),
      customTitle: _titleController.text.trim(),
      customPhone: _phoneController.text.trim(),
      customEmail: _emailController.text.trim(),
      customWebsite: _websiteController.text.trim(),
      customAddress: _addressController.text.trim(),
    );

    final sub = context.read<SubscriptionController>();
    final success = await cardCtrl.saveCard(updatedCard, sub);
    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Card details updated successfully'), backgroundColor: AppColors.success),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update card details'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 12,
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Customize Card Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Override your profile details for this specific card.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 24),
                _buildField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter name',
                  icon: Icons.person_rounded,
                ),
                _buildField(
                  controller: _titleController,
                  label: 'Title / Role',
                  hint: 'e.g. Creative Director',
                  icon: Icons.work_rounded,
                ),
                _buildField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: 'e.g. +234 810 000 0000',
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone,
                ),
                _buildField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'e.g. name@company.com',
                  icon: Icons.email_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildField(
                  controller: _websiteController,
                  label: 'Website',
                  hint: 'e.g. www.company.com',
                  icon: Icons.language_rounded,
                  keyboardType: TextInputType.url,
                ),
                _buildField(
                  controller: _addressController,
                  label: 'Address',
                  hint: 'e.g. 123 Business Street, Lagos',
                  icon: Icons.location_on_rounded,
                  maxLines: 2,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Save Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
