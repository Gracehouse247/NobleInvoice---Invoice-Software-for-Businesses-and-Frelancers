// lib/features/invoicing/widgets/invoice_template_components.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart' as ctrl;
import 'package:noble_invoice/features/invoicing/models/business_info.dart';

/// Base components and helpers for InvoiceTemplateUI.
class InvoiceTemplateComponents {
  static Widget buildBody(
    BuildContext context,
    ctrl.InvoiceDetails invoice,
    BusinessInfo business,
    Color brandColor, {
    bool isDark = false,
    bool darkPillTotal = false,
  }) {
    final textColor = isDark ? Colors.white : AppColors.black;
    final secondaryTextColor = isDark ? Colors.white70 : AppColors.darkGrey;
    final hasTax = invoice.taxRate > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        // ── Invoice To & Business From ──────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('INVOICE TO:',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: brandColor)),
                    const SizedBox(height: 4),
                    Text(invoice.client.name.toUpperCase(),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: textColor)),
                    Text(invoice.client.email,
                        style: TextStyle(fontSize: 10, color: secondaryTextColor)),
                    if (invoice.client.address != null)
                      Text(invoice.client.address!,
                          style:
                              TextStyle(fontSize: 10, color: secondaryTextColor)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('FROM:',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: brandColor)),
                    const SizedBox(height: 4),
                    Text(business.name.toUpperCase(),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: textColor)),
                    Text(business.businessEmail ?? '',
                        style: TextStyle(fontSize: 10, color: secondaryTextColor)),
                    Text(business.businessPhone ?? '',
                        style: TextStyle(fontSize: 10, color: secondaryTextColor)),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Invoice Metadata Row (dates / number) ──────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _metaChip('INVOICE #', invoice.invoiceNumber, brandColor, textColor),
              _metaChip(
                  'DATE',
                  _formatDateStr(invoice.issueDate),
                  brandColor,
                  textColor),
              _metaChip(
                  'DUE DATE',
                  _formatDateStr(invoice.dueDate),
                  brandColor,
                  textColor),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ── Items Table ────────────────────────────────────────────
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            border:
                Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Table header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: brandColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: const Row(children: [
                  Expanded(
                      flex: 4,
                      child: Text('DESCRIPTION',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w900))),
                  Expanded(
                      flex: 1,
                      child: Text('QTY',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w900))),
                  Expanded(
                      flex: 2,
                      child: Text('PRICE',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w900))),
                  Expanded(
                      flex: 2,
                      child: Text('TOTAL',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w900))),
                ]),
              ),
              // Item rows
              ...invoice.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isEven = index % 2 == 0;
                final priceText =
                    CurrencyFormatter.format(context, item.unitPrice);
                final totalText = CurrencyFormatter.format(context, item.total);
                final priceFontSize =
                    (priceText.length > 12 || totalText.length > 12) ? 7.5 : 9.0;
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isEven
                        ? Colors.white
                        : AppColors.lightGrey.withOpacity(0.2),
                    border: Border(
                        top: BorderSide(
                            color:
                                AppColors.lightGrey.withOpacity(0.3))),
                  ),
                  child: Row(children: [
                    Expanded(
                        flex: 4,
                        child: Text(item.description,
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: textColor))),
                    Expanded(
                        flex: 1,
                        child: Text('${item.quantity}',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 9, color: textColor))),
                    Expanded(
                        flex: 2,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(priceText,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: priceFontSize, color: textColor)),
                        )),
                    Expanded(
                        flex: 2,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(totalText,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: priceFontSize,
                                  fontWeight: FontWeight.w900,
                                  color: textColor)),
                        )),
                  ]),
                );
              }),
            ],
          ),
        ),

        const Divider(height: 30, indent: 24, endIndent: 24),

        // ── Payment Details + Totals Summary ───────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payment details (left)
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PAYMENT DETAILS:',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: brandColor)),
                    const SizedBox(height: 4),
                    Text(business.bankName ?? 'BANK NAME',
                        style: TextStyle(fontSize: 9, color: textColor)),
                    Text(business.accountNumber ?? 'ACCOUNT NO.',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
                    Text(business.accountName ?? 'ACCOUNT NAME',
                        style: TextStyle(
                            fontSize: 8, color: secondaryTextColor)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Totals (right)
              Expanded(
                flex: 3,
                child: _buildTotals(
                  context,
                  invoice,
                  brandColor,
                  textColor,
                  darkPill: darkPillTotal,
                  hasTax: hasTax,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ── Signature Block (ALWAYS VISIBLE) ───────────────────────
        _buildSignatureBlock(invoice, business, brandColor, secondaryTextColor),

        const SizedBox(height: 16),

        // ── Terms & Notes Footer Band ──────────────────────────────
        _buildTermsFooter(invoice, brandColor, isDark),
      ],
    );
  }

  // ── Totals Widget ─────────────────────────────────────────────────
  static Widget _buildTotals(
    BuildContext context,
    ctrl.InvoiceDetails invoice,
    Color brandColor,
    Color textColor, {
    bool darkPill = false,
    bool hasTax = false,
  }) {
    final totalColor = darkPill ? Colors.white : brandColor;
    final totalBg = darkPill ? const Color(0xFF212121) : brandColor.withOpacity(0.1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _summaryRow('SUB TOTAL',
            CurrencyFormatter.format(context, invoice.subtotal), textColor),
        if (hasTax)
          _summaryRow(
              'TAX (${invoice.taxRate}%)',
              CurrencyFormatter.format(context, invoice.taxAmount),
              textColor),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: totalBg,
            borderRadius: BorderRadius.circular(darkPill ? 24 : 6),
          ),
          child: _summaryRow(
              'TOTAL DUE',
              CurrencyFormatter.format(context, invoice.totalAmount),
              totalColor,
              isBold: true,
              fontSize: 11),
        ),
      ],
    );
  }

  static Widget _summaryRow(String label, String value, Color color,
      {bool isBold = false, double fontSize = 9}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
                    color: color)),
            const SizedBox(width: 8),
            Text(value,
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: isBold ? FontWeight.w900 : FontWeight.normal,
                    color: color)),
          ],
        ),
      ),
    );
  }

  // ── Signature Block — ALWAYS RENDERED ────────────────────────────
  static Widget _buildSignatureBlock(
    ctrl.InvoiceDetails invoice,
    BusinessInfo business,
    Color brandColor,
    Color secondaryTextColor,
  ) {
    final sigBase64 = invoice.metadata['signature']?.toString();
    final sigUrl = business.signatureUrl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Signature image or placeholder space
              SizedBox(
                height: 48,
                width: 130,
                child: sigBase64 != null
                    ? Image.memory(
                        base64Decode(sigBase64.split(',').last),
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            _signaturePlaceholder(secondaryTextColor),
                      )
                    : sigUrl != null
                        ? Image.network(
                            sigUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                _signaturePlaceholder(secondaryTextColor),
                          )
                        : _signaturePlaceholder(secondaryTextColor),
              ),
              // Underline
              Container(
                width: 130,
                height: 1,
                color: secondaryTextColor.withOpacity(0.5),
              ),
              const SizedBox(height: 4),
              Text(
                'AUTHORIZED SIGNATURE',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _signaturePlaceholder(Color color) {
    return Container(
      width: 130,
      height: 48,
      alignment: Alignment.bottomCenter,
      child: Text(
        '',
        style: TextStyle(color: color.withOpacity(0.3)),
      ),
    );
  }

  // ── Terms & Notes Footer Band ─────────────────────────────────────
  static Widget _buildTermsFooter(
    ctrl.InvoiceDetails invoice,
    Color brandColor,
    bool isDark,
  ) {
    final bgColor = isDark
        ? const Color(0xFF2C2C2C)
        : brandColor.withOpacity(0.06);
    final labelColor = isDark ? Colors.white70 : brandColor;
    final textColor = isDark ? Colors.white54 : const Color(0xFF757575);
    final termsText = (invoice.notes != null && invoice.notes!.isNotEmpty)
        ? invoice.notes!
        : 'Thank you for your business. Please make payment within 15 days. '
            'Late payments may be subject to additional fees.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Terms & Notes',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: labelColor,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            termsText,
            style: TextStyle(
              fontSize: 8,
              color: textColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Metadata chip helper ──────────────────────────────────────────
  static Widget _metaChip(
      String label, String value, Color brandColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w900,
                color: brandColor)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 160),
          child: Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: textColor)),
        ),
      ],
    );
  }

  static String _formatDateStr(String? s) {
    if (s == null || s.isEmpty) return '—';
    final dt = DateTime.tryParse(s);
    if (dt == null) return s;
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';
  }
}

class HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height - 40);
    path.quadraticBezierTo(
        size.width * 0.75, size.height - 80, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
