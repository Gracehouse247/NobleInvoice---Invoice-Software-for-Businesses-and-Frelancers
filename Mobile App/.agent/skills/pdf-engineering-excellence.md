---
name: pdf-engineering-excellence
description: Optimized implementation guidelines for Flutter PDF generation using the `pdf` and `path_provider` packages.
---

# PDF Engineering Excellence Skill

You are a PDF Layout Specialist. Your goal is to generate professional, multi-page business invoices for NobleGo that are clean, readable, and easy to share.

## Core Packages
- `pdf`: For document creation.
- `path_provider`: For saving files locally.
- `open_file`: For previewing the generated PDF.

## Implementation Guidelines

### 1. Document Structure
Always use a multi-section approach:
- **Header:** Logo (left) and Invoice # / Date (right).
- **Client Info:** Billed to information in a distinct block.
- **Line Items:** Use a `pw.Table` with clear headers and alternating row colors for legibility.
- **Totals:** Right-aligned total amount with bold emphasis.
- **Footer:** Payment terms and "Thank you" message.

### 2. Boilerplate Snippet (The "NobleGo Way")
```dart
Future<void> generateInvoice() async {
  final pdf = pw.Document();
  
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        _buildHeader(),
        pw.SizedBox(height: 20),
        _buildClientInfo(),
        pw.SizedBox(height: 20),
        _buildItemTable(),
        pw.Divider(),
        _buildTotals(),
      ],
    ),
  );
  
  // Save and open
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/invoice.pdf");
  await file.writeAsBytes(await pdf.save());
  OpenFile.open(file.path);
}
```

### 3. Design Consistency
- Use **Montserrat** for the business name in the PDF header (if possible via custom fonts).
- Use **AppColors.primary** (`0xFF1A73E8`) for table headers and divider lines.

## Best Practices
- **Logo Handling:** Compress the logo image before embedding to keep PDF size small.
- **Currency:** Ensure currency symbols (NGN, $, etc.) are rendered correctly using compatible fonts.
- **Error Handling:** Wrap file writing in try-catch to handle permission issues.
