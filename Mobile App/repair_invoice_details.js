const fs = require('fs');

const path = 'lib/features/invoicing/screens/invoice_details_screen.dart';
let content = fs.readFileSync(path, 'utf8');

const buildMethodRegex = /@override\s*Widget build\(BuildContext context\) \{[\s\S]*?(?=bottomSheet:)/;

const newBuildStart = \@override
  Widget build(BuildContext context) {
    final invoiceCtrl = context.watch<InvoiceController>();
    final sub = context.watch<SubscriptionController>();
    final invoice = invoiceCtrl.currentDetails;

    if (invoiceCtrl.isLoading && invoice == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.85),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(invoice?.invoiceNumber != null ? 'INV-\' : 'Details', 
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: invoice == null
          ? const Center(child: Text('Invoice not found'))
          : Hero(
              tag: 'invoice-\',
              child: Material(
                color: Colors.transparent,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(invoice.client.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 8),
                          Text('\ \', 
                            style: const TextStyle(fontSize: 20, color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          const Divider(),
                          // Add project costs section here
                          _ProjectCostsSection(
                            invoiceId: invoice.id,
                            invoiceNumber: invoice.invoiceNumber,
                            invoiceTotal: invoice.totalAmount,
                            currencyCode: invoice.currencyCode ?? 'USD',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
      \;

content = content.replace(buildMethodRegex, newBuildStart);

fs.writeFileSync(path, content);
console.log('Repaired invoice_details_screen.dart');
