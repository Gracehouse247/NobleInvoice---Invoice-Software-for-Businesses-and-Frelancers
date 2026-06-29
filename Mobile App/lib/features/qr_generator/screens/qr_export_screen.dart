import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';

class QrExportScreen extends StatefulWidget {
  const QrExportScreen({super.key});

  @override
  State<QrExportScreen> createState() => _QrExportScreenState();
}

class _QrExportScreenState extends State<QrExportScreen> {
  String _selectedFormat = 'svg';

  final List<Map<String, dynamic>> _formats = [
    {
      'id': 'svg',
      'title': 'SVG Vector',
      'subtitle': 'Scalable design, professional use',
      'icon': Icons.layers_rounded,
      'size': '~450 KB',
      'tag': 'BEST FOR PRINT',
    },
    {
      'id': 'png',
      'title': 'PNG High Res',
      'subtitle': 'Transparent background, web ready',
      'icon': Icons.image_rounded,
      'size': '~1.2 MB',
    },
    {
      'id': 'jpg',
      'title': 'JPG (Standard)',
      'subtitle': 'Small size, compatible everywhere',
      'icon': Icons.photo_library_rounded,
      'size': '~240 KB',
    },
    {
      'id': 'pdf',
      'title': 'PDF Document',
      'subtitle': 'Easy sharing and documentation',
      'icon': Icons.picture_as_pdf_rounded,
      'size': '~890 KB',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Export Settings', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPreviewSection(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SELECT DOWNLOAD FORMAT', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                  const SizedBox(height: 16),
                  ..._formats.map((f) => _buildFormatOption(f)),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAkVa57Gxj3weWJ4To1BBKHrcx101nbGDf_C-aUqbeNvlhGdHiXFAg31SiajYBj8tl5eOukagMU2JbisGI5bTFGeNda9tnQj1GFphCT4YzVbBVWEAOlcLKIRw6RXp5F1GBbJDRNljL1dviQiB3riBhOTxupQl9DxpR7jQoHTV4sy7Jx5_2ajATWjnuH0SbYFn6btn67G-UtzJpLE-p_2LALTJ61modglI4TWxDqkBY9Ywmn33K6KROh8pdGvmwudthhGHk_KwBxFnQ',
              width: 140,
              height: 140,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text('noble-qr-7721.png', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildFormatOption(Map<String, dynamic> format) {
    bool isSelected = _selectedFormat == format['id'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => setState(() => _selectedFormat = format['id']),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.lightGrey, width: isSelected ? 2 : 1),
            boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 10)] : null,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(format['icon'], color: isSelected ? AppColors.primary : Colors.grey, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(format['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        if (format['tag'] != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                            child: Text(format['tag'], style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(format['subtitle'], style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
              Text(format['size'], style: TextStyle(color: isSelected ? AppColors.primary : Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RESOLUTION', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                  Text('2048 x 2048 px', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('COLOR PROFILE', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                  Text('CMYK / RGB', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            icon: const Icon(Icons.download_rounded),
            label: const Text('Download Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
