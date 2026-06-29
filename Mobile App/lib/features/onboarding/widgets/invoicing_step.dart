import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';

class InvoicingStep extends StatelessWidget {
  final TextEditingController taxNumberController;
  final TextEditingController footerController;
  final Color activeColor;

  const InvoicingStep({
    super.key,
    required this.taxNumberController,
    required this.footerController,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: FadeInRight(
        duration: const Duration(milliseconds: 500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Smart Billing', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.2)),
            const SizedBox(height: 8),
            Text('Finalize your professional invoice architecture.', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            const SizedBox(height: 32),
            
            _buildStepInput(
              label: 'VAT / Tax ID (Optional)',
              controller: taxNumberController,
              hint: 'e.g., UK1234567',
              icon: Icons.receipt_long_rounded,
            ),
            const SizedBox(height: 24),
            
            _buildStepInput(
              label: 'Invoice Footer Note',
              controller: footerController,
              hint: 'e.g., Thank you for your business!',
              icon: Icons.comment_rounded,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepInput({required String label, required TextEditingController controller, required String hint, required IconData icon, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.2, color: AppColors.darkGrey)),
        const SizedBox(height: 10),
        _StepGlassContainer(
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, size: 20, color: activeColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class _StepGlassContainer extends StatelessWidget {
  final Widget child;
  const _StepGlassContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: child,
    );
  }
}
