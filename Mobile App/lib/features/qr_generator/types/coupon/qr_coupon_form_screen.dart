import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/routes/app_routes.dart';
import 'package:noble_invoice/features/qr_generator/controllers/qr_generator_controller.dart';

class QrCouponFormScreen extends StatefulWidget {
  const QrCouponFormScreen({super.key});

  @override
  State<QrCouponFormScreen> createState() => _QrCouponFormScreenState();
}

class _QrCouponFormScreenState extends State<QrCouponFormScreen> {
  final _titleController = TextEditingController();
  final _discountController = TextEditingController();
  final _expiryController = TextEditingController();
  final _termsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _discountController.dispose();
    _expiryController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _expiryController.text = DateFormat('MMMM dd, yyyy').format(picked);
      });
    }
  }

  void _handleGenerate() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a coupon title')),
      );
      return;
    }

    context.read<QrGeneratorController>().updateData(
      name: 'Coupon: $title',
      type: 'coupon',
      content: {
        'title': title,
        'discount': _discountController.text.trim(),
        'expiry': _expiryController.text.trim(),
        'terms': _termsController.text.trim(),
      },
    );

    Navigator.pushNamed(context, AppRoutes.qrPreview);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.primary, size: 20),
        ),
        title: Text(
          'Promotion QR Setup',
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: AppColors.lightGrey, height: 1),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120, left: 24, right: 24, top: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offer Details',
                  style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w900, fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create an attractive coupon that users can scan to unlock deals.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkGrey, height: 1.5),
                ),
                const SizedBox(height: 40),
                
                _buildLabel('Coupon Title', isRequired: true),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(hintText: 'e.g. Summer Flash Sale'),
                ),
                const SizedBox(height: 24),
                
                _buildLabel('Discount Amount (e.g. 20% or \$50 OFF)'),
                TextField(
                  controller: _discountController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 25%',
                    prefixIcon: Icon(Icons.sell_outlined, size: 20),
                  ),
                ),
                const SizedBox(height: 24),
                
                _buildLabel('Expiry Date'),
                TextField(
                  controller: _expiryController,
                  readOnly: true,
                  onTap: _selectDate,
                  decoration: const InputDecoration(
                    hintText: 'Select date',
                    prefixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                  ),
                ),
                const SizedBox(height: 24),
                
                _buildLabel('Terms & Conditions'),
                TextField(
                  controller: _termsController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Specify usage limits or minimum spend...',
                  ),
                ),
                const SizedBox(height: 40),
                
                _buildPromotionCard(),
              ],
            ),
          ),
          
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.lightGrey, width: 0.5)),
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleGenerate,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Generate Preview'),
                        SizedBox(width: 8),
                        Icon(Icons.qr_code_2_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: RichText(
        text: TextSpan(
          text: text,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textBlack),
          children: isRequired
              ? [
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  Widget _buildPromotionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.loyalty_rounded, color: Colors.white, size: 40),
          const SizedBox(height: 16),
          const Text(
            'High Conversion Design',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Our coupons are designed to maximize scans and redemptions for your business.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(0.1), fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }
}
