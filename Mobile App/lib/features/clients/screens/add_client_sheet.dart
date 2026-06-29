import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/features/clients/controllers/add_client_controller.dart';
import 'package:noble_invoice/features/invoicing/models/client_model.dart';

class AddClientSheet extends StatelessWidget {
  final Client? existingClient;
  const AddClientSheet({super.key, this.existingClient});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddClientController(existingClient: existingClient),
      child: const _AddClientSheetView(),
    );
  }
}

class _AddClientSheetView extends StatelessWidget {
  const _AddClientSheetView();

  static const _primary   = Color(0xFF2563EB);
  static const _surface   = Color(0xFFF8FAFC);
  static const _textDark  = Color(0xFF1E293B);

  void _showUpgradePrompt(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60, height: 6,
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(3)),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: _primary.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.rocket_launch_rounded, color: _primary, size: 48),
            ),
            const SizedBox(height: 24),
            const Text('Upgrade to Noble Pulse', 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: _textDark, letterSpacing: -0.5)),
            const SizedBox(height: 12),
            Text(
              'You\'ve reached the 3-client limit on the Solo plan. Upgrade to Pulse for unlimited clients, premium branding, and dynamic QR codes.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pricing-plans');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 64),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: const Text('View All Plans', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Maybe Later', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _pickCountryCode(BuildContext context) {
    final controller = context.read<AddClientController>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: AddClientController.countryCodes.length,
        itemBuilder: (_, i) {
          final c = AddClientController.countryCodes[i];
          return ListTile(
            leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
            title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: Text(c.code, style: const TextStyle(color: _primary, fontWeight: FontWeight.bold)),
            onTap: () {
              controller.setCountry(c);
              Navigator.pop(ctx);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AddClientController>();
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),
            if (controller.inlineError != null)
              Container(
                margin: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline_rounded, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        controller.inlineError!,
                        style: TextStyle(color: Colors.red.shade900, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      _sectionLabel('CONTACT INFORMATION'),
                      _buildField(
                        controller: controller.nameController,
                        icon: Icons.person_outline_rounded,
                        label: 'Client Name *',
                        hint: 'Major EC Opumie',
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: FilledButton.icon(
                          onPressed: () => controller.importFromContacts(context),
                          icon: const Icon(Icons.import_contacts_rounded, size: 20),
                          label: const Text('Import from contacts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          style: FilledButton.styleFrom(
                            backgroundColor: _primary.withOpacity(0.1),
                            foregroundColor: _primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: _primary.withOpacity(0.2)),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            elevation: 0,
                          ),
                        ),
                      ),
                      _buildField(
                        controller: controller.emailController,
                        icon: Icons.mail_outline_rounded,
                        label: 'Email Address *',
                        hint: 'info@opufortymall.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Email is required';
                          if (!v.contains('@')) return 'Enter a valid email address';
                          return null;
                        },
                      ),

                      _buildLabel('Phone Number'),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => _pickCountryCode(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                decoration: BoxDecoration(
                                  color: _surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(controller.selectedCountry.flag, style: const TextStyle(fontSize: 20)),
                                    const SizedBox(width: 4),
                                    Text(controller.selectedCountry.code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _primary)),
                                    const Icon(Icons.arrow_drop_down, color: _primary, size: 18),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: controller.phoneController,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: '07045507824',
                                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                                  filled: true, fillColor: _surface,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: _primary, width: 2)),
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      _sectionLabel('BUSINESS INFORMATION'),
                      _buildField(
                        controller: controller.businessController,
                        icon: Icons.business_rounded,
                        label: 'Business Name *',
                        hint: 'Opuforty Nigeria Limited',
                      ),

                      _buildLabel('Position / Role'),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: DropdownButtonFormField<String>(
                          value: controller.selectedPosition,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.work_outline_rounded, size: 20, color: _primary),
                            hintText: 'Select position...',
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                            filled: true, fillColor: _surface,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: _primary, width: 2)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          items: AddClientController.positions.map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(p, style: const TextStyle(fontSize: 14)),
                          )).toList(),
                          onChanged: controller.setPosition,
                        ),
                      ),

                      _buildField(
                        controller: controller.addressController,
                        icon: Icons.location_on_outlined,
                        label: 'Business Address',
                        hint: '32 Mobolaji Bank Anthony Way, Maryland Lagos Nigeria',
                        maxLines: 2,
                        required: false,
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
              child: ElevatedButton(
                onPressed: controller.isSubmitting ? null : () => controller.submit(context, onUpgradePrompt: () => _showUpgradePrompt(context)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isEditing ? const Color(0xFF0F766E) : _primary,
                  disabledBackgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 64),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                  shadowColor: _primary.withOpacity(0.1),
                ),
                child: controller.isSubmitting
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Text(controller.isEditing ? 'Save Changes' : 'Save Client', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5)),
              ),
            ),
            if (!controller.isEditing)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: TextButton.icon(
                  onPressed: controller.isSubmitting ? null : () => controller.submit(context, redirectToInvoice: true, onUpgradePrompt: () => _showUpgradePrompt(context)),
                  icon: const Icon(Icons.receipt_long_rounded, size: 18),
                  label: const Text('Save & Create Invoice', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  style: TextButton.styleFrom(foregroundColor: _primary, minimumSize: const Size(double.infinity, 48)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() => Container(
    margin: const EdgeInsets.symmetric(vertical: 12),
    width: 40, height: 4,
    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
  );

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 16, top: 4),
    child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: _primary, letterSpacing: 1.5)),
  );

  Widget _buildLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: _textDark, letterSpacing: 0.8)),
  );

  Widget _buildField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool required = true,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            textInputAction: maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              prefixIcon: Icon(icon, size: 20, color: _primary),
              filled: true, fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: _primary, width: 2)),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.red, width: 2)),
              contentPadding: const EdgeInsets.all(16),
            ),
            validator: validator ?? (required ? (v) => (v == null || v.trim().isEmpty) ? 'This field is required' : null : null),
          ),
        ],
      ),
    );
  }
}
