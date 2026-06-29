import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:noble_invoice/features/shared/widgets/web_engine_view.dart';
import 'package:noble_invoice/features/profile/controllers/profile_controller.dart';
import 'package:provider/provider.dart';

class InvoiceTemplateSelectorScreen extends StatelessWidget {
  const InvoiceTemplateSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: WebEngineView(
          path: '/embed/template-gallery',
          showAppBar: false,
          onMessageReceived: (String message) async {
            try {
              final Map<String, dynamic> data = jsonDecode(message);
              if (data['type'] == 'TEMPLATE_SELECTED') {
                final String templateId = data['payload'];
                
                final profileCtrl = context.read<ProfileController>();
                final success = await profileCtrl.updateDefaultTemplate(templateId);
                
                if (context.mounted) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Template applied successfully!')),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to apply template. Please try again.')),
                    );
                  }
                }
              }
            } catch (e) {
              debugPrint('Error processing template selection: $e');
            }
          },
        ),
      ),
    );
  }
}
