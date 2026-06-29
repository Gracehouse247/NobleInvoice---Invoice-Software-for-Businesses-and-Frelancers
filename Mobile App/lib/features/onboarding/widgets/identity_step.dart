import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';

class IdentityStep extends StatelessWidget {
  final TextEditingController businessNameController;
  final String selectedIndustry;
  final String selectedCountry;
  final List<String> industries;
  final List<String> countries;
  final Function(String?) onIndustryChanged;
  final Function(String?) onCountryChanged;
  final Color activeColor;

  const IdentityStep({
    super.key,
    required this.businessNameController,
    required this.selectedIndustry,
    required this.selectedCountry,
    required this.industries,
    required this.countries,
    required this.onIndustryChanged,
    required this.onCountryChanged,
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
            const Text('The Identity', 
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.2)),
            const SizedBox(height: 8),
            Text('How should the world address your business?', 
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            const SizedBox(height: 32),
            
            _buildStepInput(
              label: 'Business Name',
              controller: businessNameController,
              hint: 'e.g., Noble World Ltd.',
              icon: Icons.business_rounded,
            ),
            const SizedBox(height: 24),
            
            _buildStepDropdown(
              label: 'Industry',
              value: selectedIndustry,
              items: industries,
              onChanged: onIndustryChanged,
              icon: Icons.category_rounded,
            ),
            const SizedBox(height: 24),
            
            _buildStepDropdown(
              label: 'Location',
              value: selectedCountry,
              items: countries,
              onChanged: onCountryChanged,
              icon: Icons.public_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepInput({required String label, required TextEditingController controller, required String hint, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.2, color: AppColors.darkGrey)),
        const SizedBox(height: 10),
        _StepGlassContainer(
          child: TextField(
            controller: controller,
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

  Widget _buildStepDropdown({required String label, required String value, required List<String> items, required void Function(String?) onChanged, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.2, color: AppColors.darkGrey)),
        const SizedBox(height: 10),
        _StepGlassContainer(
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: value,
            onChanged: onChanged,
            items: items.map((i) => DropdownMenuItem(
              value: i, 
              child: Text(i, overflow: TextOverflow.ellipsis)
            )).toList(),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20, color: activeColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
