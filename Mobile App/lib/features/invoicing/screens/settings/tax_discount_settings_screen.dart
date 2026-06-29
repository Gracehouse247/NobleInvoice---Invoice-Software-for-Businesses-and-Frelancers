import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/features/profile/controllers/profile_controller.dart';
import 'package:noble_invoice/features/profile/controllers/team_controller.dart';

class TaxDiscountSettingsScreen extends StatefulWidget {
  const TaxDiscountSettingsScreen({super.key});

  @override
  State<TaxDiscountSettingsScreen> createState() => _TaxDiscountSettingsScreenState();
}

class _TaxDiscountSettingsScreenState extends State<TaxDiscountSettingsScreen> {
  bool _taxEnabled = true;
  double _taxRate = 15.0;
  bool _discountEnabled = true;
  bool _isPercentageDiscount = true;
  double _discountValue = 5.0;

  @override
  void initState() {
    super.initState();
    final team = context.read<TeamController>().activeTeam;
    if (team != null) {
      _taxRate = team.defaultVatRate;
      _taxEnabled = _taxRate > 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left_rounded, color: AppColors.primary),
          label: const Text('Back', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ),
        title: const Text('Tax & Discounts', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('TAX SETTINGS'),
                const SizedBox(height: 8),
                _buildTaxSection(),
                const SizedBox(height: 24),
                _buildSectionHeader('DISCOUNT SETTINGS'),
                const SizedBox(height: 8),
                _buildDiscountSection(),
                const SizedBox(height: 200), // Space for footer
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildFooter(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.primary.withOpacity(0.6),
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildTaxSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.percent_rounded, color: AppColors.primary, size: 20),
            ),
            title: const Text('Apply VAT / Tax', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            subtitle: const Text('Enable tax for this invoice', style: TextStyle(color: Colors.grey, fontSize: 12)),
            trailing: Switch.adaptive(
              value: _taxEnabled,
              onChanged: (val) => setState(() => _taxEnabled = val),
              activeTrackColor: AppColors.primary.withOpacity(0.5),
              activeThumbColor: AppColors.primary,
            ),
          ),
          if (_taxEnabled) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TAX PERCENTAGE (%)', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '0.00',
                      suffixText: '%',
                      filled: true,
                      fillColor: AppColors.background.withOpacity(0.5),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    onChanged: (val) => setState(() => _taxRate = double.tryParse(val) ?? 0),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tax will be calculated based on the subtotal after discounts.',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDiscountSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.sell_rounded, color: Colors.green, size: 20),
            ),
            title: const Text('Add Discount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            subtitle: const Text('Deduct from subtotal', style: TextStyle(color: Colors.grey, fontSize: 12)),
            trailing: Switch.adaptive(
              value: _discountEnabled,
              onChanged: (val) => setState(() => _discountEnabled = val),
              activeTrackColor: AppColors.primary.withOpacity(0.5),
              activeThumbColor: AppColors.primary,
            ),
          ),
          if (_discountEnabled) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Expanded(child: _buildSegmentButton('Percentage', _isPercentageDiscount, () => setState(() => _isPercentageDiscount = true))),
                        Expanded(child: _buildSegmentButton('Flat Amount', !_isPercentageDiscount, () => setState(() => _isPercentageDiscount = false))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('DISCOUNT VALUE', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '0.00',
                      suffixText: _isPercentageDiscount ? '%' : '\$',
                      filled: true,
                      fillColor: AppColors.background.withOpacity(0.5),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    onChanged: (val) => setState(() => _discountValue = double.tryParse(val) ?? 0),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.primary : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppColors.lightGrey)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPriceRow('Subtotal', 1000.00),
            const SizedBox(height: 8),
            _buildPriceRow('Discount (${_discountValue.toStringAsFixed(0)}%)', -50.00, isHighlight: true),
            const SizedBox(height: 8),
            _buildPriceRow('Tax (${_taxRate.toStringAsFixed(0)}%)', 142.50),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TOTAL BALANCE', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w900)),
                    Text('\$1,092.50', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    final success = await context.read<TeamController>().updateTeamSettings(
                      defaultVatRate: _taxEnabled ? _taxRate : 0,
                    );
                    if (mounted) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Settings saved successfully!')),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to save settings.')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                  ),
                  child: context.watch<ProfileController>().isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Apply Changes', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
        Text(
          '${amount < 0 ? "-" : "+"}\$${amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isHighlight ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}
