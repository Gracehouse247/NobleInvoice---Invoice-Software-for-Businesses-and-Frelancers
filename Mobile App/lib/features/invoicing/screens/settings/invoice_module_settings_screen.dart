import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/routes/app_routes.dart';
import 'package:noble_invoice/features/profile/controllers/team_controller.dart';
import 'package:noble_invoice/features/profile/models/team_model.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:noble_invoice/features/profile/controllers/profile_controller.dart';
import 'package:noble_invoice/features/invoicing/models/pdf_template.dart';

class InvoiceModuleSettingsScreen extends StatefulWidget {
  const InvoiceModuleSettingsScreen({super.key});

  @override
  State<InvoiceModuleSettingsScreen> createState() => _InvoiceModuleSettingsScreenState();
}

class _InvoiceModuleSettingsScreenState extends State<InvoiceModuleSettingsScreen> {
  late TextEditingController _taxRateController;
  late TextEditingController _prefixController;
  late TextEditingController _suffixController;

  @override
  void initState() {
    super.initState();
    final team = context.read<TeamController>().activeTeam;
    _taxRateController = TextEditingController(text: (team?.defaultVatRate ?? 15.0).toString());
    _prefixController = TextEditingController(text: team?.invoicePrefix ?? 'INV-');
    _suffixController = TextEditingController();

    // Listeners for Live Preview (Million Dollar UX)
    _taxRateController.addListener(() => setState(() {}));
    _prefixController.addListener(() => setState(() {}));
    _suffixController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _taxRateController.dispose();
    _prefixController.dispose();
    _suffixController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final teamCtrl = context.read<TeamController>();
    final success = await teamCtrl.updateTeamSettings(
      defaultVatRate: double.tryParse(_taxRateController.text),
      invoicePrefix: _prefixController.text,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully'),
            backgroundColor: AppColors.primary,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${teamCtrl.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final team = context.watch<TeamController>().activeTeam;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: AppColors.primary, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Invoice Settings', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: const Text('Save', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('LIVE PREVIEW (SMART HINTS)'),
            _buildLivePreview(),
            _buildSectionHeader('BUSINESS BRANDING'),
            _buildBrandingSection(team),
            _buildSectionHeader('FINANCE & RATES'),
            _buildFinanceSection(),
            _buildSectionHeader('DOCUMENT FORMATTING'),
            _buildFormattingSection(),
            const SizedBox(height: 32),
            _buildDangerousSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        title,
        style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildBrandingSection(Team? team) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(horizontal: BorderSide(color: AppColors.lightGrey)),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            onTap: () => Navigator.pushNamed(context, AppRoutes.invoiceBranding),
            leading: Stack(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    image: team?.brandLogoUrl != null 
                      ? DecorationImage(image: NetworkImage(team!.brandLogoUrl!), fit: BoxFit.cover)
                      : null,
                  ),
                  child: team?.brandLogoUrl == null 
                    ? const Icon(Icons.business_rounded, color: AppColors.lightGrey, size: 32)
                    : null,
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                ),
              ],
            ),
            title: 'Business Logo',
            subtitle: 'Appears on all issued invoices',
            showChevron: true,
          ),
          const Divider(height: 1, indent: 20),
          _buildSettingsTile(
            onTap: () => Navigator.pushNamed(context, AppRoutes.invoiceBranding),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08), 
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.1)),
              ),
              child: const Icon(Icons.draw_rounded, color: AppColors.primary),
            ),
            title: 'Digital Signature',
            subtitle: 'Add or update your signature',
            showChevron: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceSection() {
    final profile = context.watch<ProfileController>().profile;
    String currentTemplateName = 'Modern';
    if (profile?.defaultInvoiceTemplate != null) {
      try {
        final t = PdfTemplate.values.firstWhere((t) => t.name == profile!.defaultInvoiceTemplate);
        currentTemplateName = t.label.replaceAll('★ ', '').replaceAll('✦ ', '');
        if (currentTemplateName.length > 15) {
          currentTemplateName = '${currentTemplateName.substring(0, 12)}...';
        }
      } catch (_) {}
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(horizontal: BorderSide(color: AppColors.lightGrey)),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            onTap: () => _showCurrencyPicker(context),
            leading: const Icon(Icons.payments_rounded, color: Colors.grey),
            title: 'Base Currency',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.watch<InvoiceController>().currencyCode, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              ],
            ),
          ),
          const Divider(height: 1, indent: 60),
          _buildSettingsTile(
            onTap: () => Navigator.pushNamed(context, AppRoutes.taxDiscountSettings),
            leading: const Icon(Icons.percent_rounded, color: Colors.grey),
            title: 'Default Tax Rate',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${_taxRateController.text}%', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              ],
            ),
          ),
          const Divider(height: 1, indent: 60),
          _buildSettingsTile(
            onTap: () => Navigator.pushNamed(context, AppRoutes.invoiceTemplateSelector),
            leading: const Icon(Icons.dashboard_customize_rounded, color: Colors.grey),
            title: 'Invoice Template',
            trailing: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 150),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      currentTemplateName, 
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border.symmetric(horizontal: BorderSide(color: AppColors.lightGrey)),
          ),
          child: Column(
            children: [
              _buildInputTile(
                icon: Icons.format_indent_increase_rounded,
                label: 'Invoice Prefix',
                controller: _prefixController,
              ),
              const Divider(height: 1, indent: 60),
              _buildInputTile(
                icon: Icons.format_indent_decrease_rounded,
                label: 'Invoice Suffix',
                controller: _suffixController,
                placeholder: 'Optional',
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Text('Example: INV-0001', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildDangerousSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(horizontal: BorderSide(color: AppColors.lightGrey)),
      ),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
        child: const Text('Reset to Defaults', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }

  Widget _buildLivePreview() {
    final prefix = _prefixController.text.isEmpty ? 'INV-' : _prefixController.text;
    final suffix = _suffixController.text;
    final tax    = _taxRateController.text.isEmpty ? '0.0' : _taxRateController.text;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('INVOICE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 1)),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  '$prefix${suffix}0001', 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
           Container(height: 1, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tax / VAT Estimate', style: TextStyle(color: Colors.white70, fontSize: 11)),
              Text(
                '${CurrencyFormatter.format(context, 187.50, compact: true)} ($tax%)', 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amount', style: TextStyle(color: Colors.white70, fontSize: 11)),
              Text(
                CurrencyFormatter.format(context, 1437.50), 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required VoidCallback onTap,
    required Widget leading,
    required String title,
    String? subtitle,
    bool showChevron = false,
    Widget? trailing,
  }) {
    return ListTile(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: leading,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)) : null,
      trailing: trailing ?? (showChevron ? const Icon(Icons.chevron_right_rounded, color: Colors.grey) : null),
    );
  }

  Widget _buildInputTile({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    String? suffix,
    String? placeholder,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 24),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15))),
          SizedBox(
            width: 130, // Increased to fix clipping
            child: TextField(
              controller: controller,
              textAlign: TextAlign.end,
              onTap: () => HapticFeedback.selectionClick(),
              onChanged: (_) => HapticFeedback.selectionClick(),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: placeholder,
                hintStyle: const TextStyle(color: AppColors.lightGrey),
                suffixText: suffix,
                suffixStyle: const TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }


  void _showCurrencyPicker(BuildContext context) {
    final controller = context.read<InvoiceController>();
    final currencies = [
      {'code': 'USD', 'name': 'US Dollar (\$)'},
      {'code': 'NGN', 'name': 'Nigerian Naira (₦)'},
      {'code': 'GBP', 'name': 'British Pound (£)'},
      {'code': 'EUR', 'name': 'Euro (€)'},
      {'code': 'CAD', 'name': 'Canadian Dollar (\$)'},
      {'code': 'AUD', 'name': 'Australian Dollar (\$)'},
      {'code': 'INR', 'name': 'Indian Rupee (₹)'},
      {'code': 'JPY', 'name': 'Japanese Yen (¥)'},
      {'code': 'ZAR', 'name': 'South African Rand (R)'},
      {'code': 'GHS', 'name': 'Ghanaian Cedi (₵)'},
      {'code': 'KES', 'name': 'Kenyan Shilling (KSh)'},
      {'code': 'UGX', 'name': 'Ugandan Shilling (USh)'},
      {'code': 'RWF', 'name': 'Rwandan Franc (FRw)'},
      {'code': 'TZS', 'name': 'Tanzanian Shilling (TSh)'},
      {'code': 'XAF', 'name': 'Central African CFA (FCFA)'},
      {'code': 'XOF', 'name': 'West African CFA (CFA)'},
      {'code': 'EGP', 'name': 'Egyptian Pound (E£)'},
      {'code': 'MAD', 'name': 'Moroccan Dirham (MAD)'},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Currency', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final c = currencies[index];
                  final isSelected = controller.currencyCode == c['code'];
                  return ListTile(
                    title: Text(c['name']!),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                    onTap: () {
                      controller.setCurrency(c['code']!);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
