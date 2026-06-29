import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart' as ctrl;
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/core/utils/color_utils.dart';
import 'package:noble_invoice/features/invoicing/models/pdf_template.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_template_components.dart';
import 'package:noble_invoice/features/invoicing/widgets/premium_simple_templates.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_item_model.dart' as model_item;
import 'package:noble_invoice/features/invoicing/models/client_model.dart' as model_client;
import 'package:noble_invoice/features/invoicing/models/invoice_type.dart' as model_type;
import 'package:noble_invoice/features/invoicing/widgets/classic_template_ui.dart';
import 'package:noble_invoice/features/invoicing/widgets/colorful_invoice_templates.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';

class InvoiceTemplateUI extends StatelessWidget {
  final ctrl.InvoiceDetails invoice;
  final BusinessInfo business;
  final PdfTemplate template;

  const InvoiceTemplateUI({super.key, required this.invoice, required this.business, this.template = PdfTemplate.modern});

  @override
  Widget build(BuildContext context) {
    try {
      final brandColor = ColorUtils.fromHex(business.brandColor);
      
      if (template.name.startsWith('classic') && template != PdfTemplate.classic) {
        return ClassicTemplateUI.build(template, invoice, business, brandColor);
      }

      if (template.name.startsWith('classic') && template != PdfTemplate.classic) {
        return ClassicTemplateUI.build(template, invoice, business, brandColor);
      }

      switch (template) {
        // --- Core Aesthetic Layouts ---
        case PdfTemplate.modernCurve:
        case PdfTemplate.platinumNobleBlue:
        case PdfTemplate.platinumShodweGreen:
        case PdfTemplate.platinumYellowLotus:
        case PdfTemplate.platinumArowwaiNavy:
        case PdfTemplate.platinumChadGibbons:
        case PdfTemplate.platinumShodweWindow:
          return _buildCurveLayout(context, brandColor);

        case PdfTemplate.waveCorporate:
        case PdfTemplate.platinumScarletSwoosh:
        case PdfTemplate.platinumRed:
        case PdfTemplate.platinumLiceriaBlue:
        case PdfTemplate.platinumBlueSkyline:
          return _buildWaveLayout(context, brandColor);

        case PdfTemplate.geometricBlue:
        case PdfTemplate.platinumGeometricAzure:
        case PdfTemplate.platinumBorcelleModern:
        case PdfTemplate.platinumSalfordGeometric:
        case PdfTemplate.platinumTSCompany:
          return _buildGeometricLayout(context, brandColor);

        case PdfTemplate.boldClassic:
        case PdfTemplate.platinumDark:
        case PdfTemplate.platinumFaugetDark:
        case PdfTemplate.platinumFaugetAgencyDark:
          return _buildExecutiveLayout(context, brandColor);

        case PdfTemplate.minimalistAlpha:
        case PdfTemplate.platinumAlves:
        case PdfTemplate.platinumMauveMinimalist:
        case PdfTemplate.platinumLaranaStudio:
        case PdfTemplate.platinumWarnerSpencerBeige:
          return _buildMinimalistLayout(context, brandColor);

        case PdfTemplate.platinumSky:
        case PdfTemplate.platinumFaugetSteak:
        case PdfTemplate.platinumWarnerCopper:
        case PdfTemplate.platinumOrganicAmethyst:
          return _buildImmersiveLayout(context, brandColor);

        // --- Premium Simple Implementations ---
        case PdfTemplate.simpleDiamond:
          return SimpleDiamondTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.simpleBlobs:
          return SimpleBlobsTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.simpleMetallic:
          return SimpleMetallicTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.simpleGeometric:
          return SimpleGeometricTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.simpleAngled:
          return SimpleAngledTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.simpleWave:
          return SimpleWaveTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.simpleModern:
          return SimpleModernTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.simpleImmersive:
          return SimpleImmersiveTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.simplePillTotal:
          return SimplePillTotalTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.simpleArrowLabel:
          return SimpleArrowLabelTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.simpleCleanGrid:
          return SimpleCleanGridTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.simpleMinimalist:
          return SimpleMinimalistTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));

        // --- Colorful Templates ---
        case PdfTemplate.colorfulYellowBurst:
          return ColorfulYellowBurstTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulNavyDiagonal:
          return ColorfulNavyDiagonalTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulNavyHex:
          return ColorfulNavyHexTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulPinkMagenta:
          return ColorfulPinkMagentaTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulBlueCorporate:
          return ColorfulBlueCorporateTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulTealGreen:
          return ColorfulTealGreenTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulPurpleViolet:
          return ColorfulPurpleVioletTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulCleanMono:
          return ColorfulCleanMonoTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulNavyBold:
          return ColorfulNavyBoldTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulSkyWave:
          return ColorfulSkyWaveTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulDarkIndigo:
          return ColorfulDarkIndigoTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulCharcoalBlock:
          return ColorfulCharcoalBlockTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulOrangeBlob:
          return ColorfulOrangeBlobTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulSkyBlueSoft:
          return ColorfulSkyBlueSoftTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulFullOrange:
          return ColorfulFullOrangeTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulBlueBanner:
          return ColorfulBlueBannerTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulCleanLined:
          return ColorfulCleanLinedTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulYellowBlueSplit:
          return ColorfulYellowBlueSplitTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulTealOlive:
          return ColorfulTealOliveTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));
        case PdfTemplate.colorfulLightSlate:
          return ColorfulLightSlateTemplate(invoice: _toInvoice(invoice), business: business, fmtMoney: (v) => v.toStringAsFixed(2));

        // --- Creative Templates ---
        case PdfTemplate.creative01:
        case PdfTemplate.creative02:
        case PdfTemplate.creative03:
        case PdfTemplate.creative04:
        case PdfTemplate.creative05:
          return CreativeBatchPreview(
            invoice: _toInvoice(invoice),
            business: business,
            fmtMoney: (v) => v.toStringAsFixed(2),
            template: template,
          );

        default:
          return _buildStandardLayout(context, brandColor);
      }
    } catch (e, stacktrace) {
      debugPrint('TEMPLATE UI ERROR: $e');
      debugPrint(stacktrace.toString());
      return Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        color: Colors.red.shade900,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 48),
              const SizedBox(height: 16),
              Text('CRITICAL TEMPLATE ERROR', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(e.toString(), style: const TextStyle(color: Colors.yellow, fontSize: 14)),
              const SizedBox(height: 8),
              Text(stacktrace.toString(), style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildStandardLayout(BuildContext context, Color brandColor) {
    return Container(
      color: Colors.white, width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          decoration: BoxDecoration(color: brandColor.withOpacity(0.1), border: Border(bottom: BorderSide(color: brandColor, width: 2))),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (business.logoUrl != null) Image.network(business.logoUrl!, height: 40, width: 40, errorBuilder: (_,__,___) => const SizedBox()),
              const SizedBox(height: 12),
              Text(business.name.toUpperCase(), style: TextStyle(color: brandColor, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1), maxLines: 2, overflow: TextOverflow.ellipsis),
              if (business.businessAddress != null) Text(business.businessAddress!, style: const TextStyle(fontSize: 8, color: AppColors.darkGrey)),
            ])),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              FittedBox(fit: BoxFit.scaleDown, child: Text('INVOICE', style: TextStyle(color: brandColor, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2))),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Text('INV - ${invoice.invoiceNumber}', 
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.darkGrey, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ]),
          ]),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: InvoiceTemplateComponents.buildBody(context, invoice, business, brandColor),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: brandColor.withOpacity(0.1)))),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(business.businessEmail ?? '', style: const TextStyle(fontSize: 8, color: AppColors.darkGrey)),
              Text(business.businessPhone ?? '', style: const TextStyle(fontSize: 8, color: AppColors.darkGrey)),
            ]),
            Text(business.footerText ?? 'THANK YOU FOR YOUR BUSINESS', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: brandColor)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildCurveLayout(BuildContext context, Color brandColor) {
    return Container(
      color: Colors.white, width: double.infinity,
      child: Column(children: [
        SizedBox(height: 180, child: Stack(children: [
          ClipPath(clipper: HeaderCurveClipper(), child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [brandColor, brandColor.withOpacity(0.8)])))),
          Padding(padding: const EdgeInsets.fromLTRB(24, 40, 24, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: business.logoUrl != null ? ClipOval(child: Image.network(business.logoUrl!, height: 40, width: 40, fit: BoxFit.cover, errorBuilder: (_,__,___) => const SizedBox())) : Container(width: 40, height: 40)),
            const SizedBox(height: 16),
            Text(business.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: -0.5), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text("CREATING BRAND'S VISIBILITY", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ])),
          Positioned(top: 30, right: 24, child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('INVOICE', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2)),
            ConstrainedBox(constraints: const BoxConstraints(maxWidth: 120), child: Text('INV - ${invoice.invoiceNumber}', style: const TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]))),
        ])),
        Expanded(child: SingleChildScrollView(child: InvoiceTemplateComponents.buildBody(context, invoice, business, brandColor))),
        const SizedBox(height: 10),
        Container(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), decoration: BoxDecoration(color: brandColor, borderRadius: const BorderRadius.only(topLeft: Radius.circular(40))), child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.phone_rounded, color: Colors.white, size: 10), const SizedBox(width: 4), Text(business.businessPhone ?? '', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
            const SizedBox(width: 16), const Icon(Icons.language_rounded, color: Colors.white, size: 10), const SizedBox(width: 4), Text(business.businessEmail ?? '', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 6), Text(business.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5), maxLines: 1, overflow: TextOverflow.ellipsis),
        ])),
      ]),
    );
  }

  Widget _buildMinimalistLayout(BuildContext context, Color brandColor) {
    return Container(color: Colors.white, width: double.infinity, child: Column(children: [
      const SizedBox(height: 60), Text(business.name.toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w100, letterSpacing: 8)),
      const SizedBox(height: 8), Container(width: 40, height: 1, color: brandColor), const SizedBox(height: 40),
      Expanded(child: SingleChildScrollView(child: InvoiceTemplateComponents.buildBody(context, invoice, business, brandColor))),
    ]));
  }

  Widget _buildExecutiveLayout(BuildContext context, Color brandColor) {
    return Container(color: Colors.white, width: double.infinity, child: Column(children: [
      Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(border: Border(left: BorderSide(color: brandColor, width: 15))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(business.name.toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(business.businessEmail ?? '', style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ])),
        const FittedBox(fit: BoxFit.scaleDown, child: Text('OFFICIAL INVOICE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2))),
      ])),
      Expanded(child: SingleChildScrollView(child: InvoiceTemplateComponents.buildBody(context, invoice, business, brandColor))),
    ]));
  }

  Widget _buildImmersiveLayout(BuildContext context, Color brandColor) {
    return Container(color: Colors.white, width: double.infinity, child: Stack(children: [
      Positioned(top: -50, right: -50, child: Opacity(opacity: 0.1, child: Icon(Icons.star, size: 300, color: brandColor))),
      Column(children: [
        Container(height: 160, width: double.infinity, decoration: BoxDecoration(gradient: LinearGradient(colors: [brandColor, brandColor.withOpacity(0.8)])), child: Center(child: Text('INVOICE', style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 80, fontWeight: FontWeight.w900)))),
        Expanded(
          child: SingleChildScrollView(
            child: InvoiceTemplateComponents.buildBody(context, invoice, business, brandColor),
          ),
        ),
      ]),
    ]));
  }

  Widget _buildWaveLayout(BuildContext context, Color brandColor) {
    return Container(color: Colors.white, width: double.infinity, child: Column(children: [
      Container(width: double.infinity, padding: const EdgeInsets.all(32), decoration: BoxDecoration(color: brandColor, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('INVOICE', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
          Text('Date: ${invoice.issueDate}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ]),
        if (business.logoUrl != null) Image.network(business.logoUrl!, height: 60, width: 60, errorBuilder: (_,__,___) => const SizedBox()),
      ])),
      Expanded(child: SingleChildScrollView(child: InvoiceTemplateComponents.buildBody(context, invoice, business, brandColor))),
    ]));
  }

  Widget _buildGeometricLayout(BuildContext context, Color brandColor) {
    return Container(color: Colors.white, width: double.infinity, child: Column(children: [
      SizedBox(height: 120, child: Stack(children: [
        Positioned.fill(child: Container(color: brandColor)),
        Positioned(right: -50, top: -20, child: Transform.rotate(angle: 0.5, child: Container(width: 200, height: 200, color: Colors.black.withOpacity(0.1)))),
        Padding(padding: const EdgeInsets.all(24), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(business.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
              const Text('PROFESSIONAL INVOICE', style: TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 2)),
            ]),
          ),
          const SizedBox(width: 12),
          const Text('INVOICE', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w100)),
        ])),
      ])),
      Expanded(child: SingleChildScrollView(child: InvoiceTemplateComponents.buildBody(context, invoice, business, brandColor))),
    ]));
  }

  Widget _buildDarkLayout(BuildContext context, Color brandColor) {
    return Container(color: const Color(0xFF1A1A1A), width: double.infinity, child: Column(children: [
      Container(padding: const EdgeInsets.all(32), decoration: BoxDecoration(border: Border(bottom: BorderSide(color: brandColor, width: 4))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('INVOICE', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900)),
        if (business.logoUrl != null) Image.network(business.logoUrl!, height: 50, width: 50),
      ])),
      Expanded(child: SingleChildScrollView(child: InvoiceTemplateComponents.buildBody(context, invoice, business, brandColor, isDark: true))),
    ]));
  }
  Invoice _toInvoice(ctrl.InvoiceDetails d) {
    return Invoice(
      id: d.id.toString(),
      client: d.client,
      items: d.items,
      issueDate: DateTime.tryParse(d.issueDate) ?? DateTime.now(),
      dueDate: DateTime.tryParse(d.dueDate) ?? DateTime.now().add(const Duration(days: 14)),
      status: InvoiceStatus.values.firstWhere(
        (s) => s.name.toLowerCase() == d.status.toLowerCase(),
        orElse: () => InvoiceStatus.draft,
      ),
      notes: d.notes,
      taxRate: d.taxRate,
      currencyCode: d.currencyCode ?? 'USD',
    );
  }
}
