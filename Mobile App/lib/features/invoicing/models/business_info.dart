// lib/features/invoicing/models/business_info.dart

/// Business identity used when rendering a PDF —
/// pulled from the user's Supabase `profiles` row.
class BusinessInfo {
  final String  name;
  final String? industry;
  final String? businessAddress;
  final String? businessEmail;
  final String? businessPhone;
  final String? taxNumber;
  final String? logoUrl;    // Supabase Storage URL of the logo
  final String  brandColor; // hex e.g. '#2563EB'
  final String? footerText;
  final String? bankName;
  final String? accountName;
  final String? accountNumber;
  final String? swiftCode;
  final String? bankBranch;
  final String? signatureUrl;
  final String? defaultTemplate;

  const BusinessInfo({
    required this.name,
    this.industry,
    this.businessAddress,
    this.businessEmail,
    this.businessPhone,
    this.taxNumber,
    this.logoUrl,
    this.brandColor = '#2563EB',
    this.footerText,
    this.bankName,
    this.accountName,
    this.accountNumber,
    this.swiftCode,
    this.bankBranch,
    this.signatureUrl,
    this.defaultTemplate,
  });

  factory BusinessInfo.fromJson(Map<String, dynamic> j) => BusinessInfo(
    name:            j['business_name'] as String? ?? j['name'] as String? ?? 'My Business',
    industry:        j['industry'] as String?,
    businessAddress: j['business_address'] as String?,
    businessEmail:   j['business_email'] as String? ?? j['email'] as String?,
    businessPhone:   j['business_phone'] as String?,
    taxNumber:       j['tax_number'] as String?,
    logoUrl:         j['brand_logo_url'] as String?,
    brandColor:      j['brand_color'] as String? ?? '#2563EB',
    footerText:      j['invoice_footer'] as String?,
    bankName:        j['bank_name'] as String?,
    accountName:     j['account_name'] as String?,
    accountNumber:   j['account_number'] as String?,
    swiftCode:       j['swift_code'] as String?,
    bankBranch:      j['bank_branch'] as String?,
    signatureUrl:    j['brand_signature_url'] as String?,
    defaultTemplate: j['default_invoice_template'] as String?,
  );

  /// Sample/empty instance for previews
  factory BusinessInfo.placeholder() => const BusinessInfo(
    name:            'My Business',
    businessAddress: '123 Business St, City, Country',
    businessEmail:   'hello@mybusiness.com',
    businessPhone:   '+1 (555) 000-0000',
    brandColor:      '#2563EB',
  );

  Map<String, dynamic> toJson() => {
    'business_name':    name,
    'industry':         industry,
    'business_address': businessAddress,
    'business_email':   businessEmail,
    'business_phone':   businessPhone,
    'tax_number':       taxNumber,
    'brand_logo_url':   logoUrl,
    'brand_color':      brandColor,
    'invoice_footer':   footerText,
    'bank_name':        bankName,
    'account_name':     accountName,
    'account_number':   accountNumber,
    'swift_code':       swiftCode,
    'bank_branch':      bankBranch,
    'brand_signature_url': signatureUrl,
    'default_invoice_template': defaultTemplate,
  };
}
