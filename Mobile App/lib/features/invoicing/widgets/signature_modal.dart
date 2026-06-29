// lib/features/invoicing/widgets/signature_modal.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';

/// Result returned from the signature modal.
class SignatureResult {
  final Uint8List bytes;
  final SignatureSource source;
  const SignatureResult({required this.bytes, required this.source});
}

enum SignatureSource { drawn, uploaded }

/// A bottom-sheet modal offering two signature capture modes:
///   1. Draw   — freehand canvas using the `signature` package
///   2. Upload — pick a PNG/JPG from gallery via `image_picker`
Future<SignatureResult?> showSignatureModal(BuildContext context) {
  return showModalBottomSheet<SignatureResult>(
    context: context,
    isScrollControlled: true,
    enableDrag: false, // Prevent bottom sheet from sliding down while drawing
    backgroundColor: Colors.transparent,
    builder: (_) => const _SignatureSheet(),
  );
}

class _SignatureSheet extends StatefulWidget {
  const _SignatureSheet();

  @override
  State<_SignatureSheet> createState() => _SignatureSheetState();
}

class _SignatureSheetState extends State<_SignatureSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2.5,
    penColor: const Color(0xFF0F172A),
    exportBackgroundColor: Colors.white,
    exportPenColor: const Color(0xFF0F172A),
  );

  Uint8List? _uploadedBytes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _pickImage() async {
    setState(() => _isLoading = true);
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 800,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      setState(() => _uploadedBytes = bytes);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmDrawn() async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please draw your signature first'),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    setState(() => _isLoading = true);
    final bytes = await _controller.toPngBytes();
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (bytes != null) {
      Navigator.pop(
          context, SignatureResult(bytes: bytes, source: SignatureSource.drawn));
    }
  }

  void _confirmUploaded() {
    if (_uploadedBytes == null) return;
    Navigator.pop(
        context,
        SignatureResult(
            bytes: _uploadedBytes!, source: SignatureSource.uploaded));
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
          children: [
            // ── Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            // ── Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF6C47FF)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.draw_rounded,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Invoice Signature',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 18)),
                      Text('Draw or upload your signature',
                          style: TextStyle(
                              color: Color(0xFF64748B), fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            // ── Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: _tabs,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppColors.primary,
                unselectedLabelColor: const Color(0xFF64748B),
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(icon: Icon(Icons.edit_rounded, size: 16), text: 'Draw'),
                  Tab(
                      icon: Icon(Icons.upload_rounded, size: 16),
                      text: 'Upload'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // ── Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabs,
                physics: const NeverScrollableScrollPhysics(), // Prevent horizontal swiping while drawing
                children: [
                  _DrawTab(
                    controller: _controller,
                    isLoading: _isLoading,
                    onConfirm: _confirmDrawn,
                  ),
                  _UploadTab(
                    uploadedBytes: _uploadedBytes,
                    isLoading: _isLoading,
                    onPick: _pickImage,
                    onConfirm: _uploadedBytes != null ? _confirmUploaded : null,
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}

// ── Draw Tab ──────────────────────────────────────────────────────────────────

class _DrawTab extends StatelessWidget {
  final SignatureController controller;
  final bool isLoading;
  final VoidCallback onConfirm;

  const _DrawTab({
    required this.controller,
    required this.isLoading,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          // Canvas
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: Stack(
                  children: [
                    Signature(
                      controller: controller,
                      backgroundColor: Colors.white,
                    ),
                    // Baseline guide
                    Positioned(
                      bottom: 70,
                      left: 32,
                      right: 32,
                      child: Container(
                        height: 1,
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                    const Positioned(
                      bottom: 52,
                      left: 32,
                      child: Text('Sign above',
                          style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFCBD5E1),
                              letterSpacing: 0.5)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Actions row
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: controller.clear,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Clear'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF64748B),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : onConfirm,
                  icon: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.check_rounded, size: 18),
                  label: const Text('Apply Signature',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Upload Tab ────────────────────────────────────────────────────────────────

class _UploadTab extends StatelessWidget {
  final Uint8List? uploadedBytes;
  final bool isLoading;
  final VoidCallback onPick;
  final VoidCallback? onConfirm;

  const _UploadTab({
    required this.uploadedBytes,
    required this.isLoading,
    required this.onPick,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          // Preview / Picker area
          Expanded(
            child: GestureDetector(
              onTap: onPick,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: uploadedBytes != null
                          ? AppColors.success.withOpacity(0.4)
                          : const Color(0xFFCBD5E1),
                      width: 1.5,
                      style: uploadedBytes == null
                          ? BorderStyle.solid
                          : BorderStyle.solid),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 20),
                  ],
                ),
                child: Center(
                  child: uploadedBytes != null
                      ? Padding(
                          padding: const EdgeInsets.all(24),
                          child: Image.memory(
                            uploadedBytes!,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.07),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.cloud_upload_rounded,
                                  size: 40, color: AppColors.primary),
                            ),
                            const SizedBox(height: 16),
                            const Text('Tap to upload signature image',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 6),
                            const Text('PNG or JPG with transparent background\nworks best',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF64748B), fontSize: 12, height: 1.5)),
                          ],
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (uploadedBytes != null) ...[
                OutlinedButton.icon(
                  onPressed: onPick,
                  icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                  label: const Text('Replace'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF64748B),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : uploadedBytes != null
                          ? onConfirm
                          : onPick,
                  icon: Icon(
                      uploadedBytes != null
                          ? Icons.check_rounded
                          : Icons.add_photo_alternate_rounded,
                      size: 18),
                  label: Text(
                      uploadedBytes != null
                          ? 'Apply Signature'
                          : 'Select from Gallery',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: uploadedBytes != null
                        ? AppColors.success
                        : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Encode signature bytes to a Base64 string for storage in metadata.
String signatureBytesToBase64(Uint8List bytes) =>
    'data:image/png;base64,${base64Encode(bytes)}';

/// Decode a Base64 signature string back to raw bytes for PDF rendering.
Uint8List? base64ToSignatureBytes(String? base64Str) {
  if (base64Str == null || !base64Str.contains(',')) return null;
  try {
    return base64Decode(base64Str.split(',').last);
  } catch (_) {
    return null;
  }
}
