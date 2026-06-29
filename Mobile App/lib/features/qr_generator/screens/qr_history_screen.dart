import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/core/widgets/empty_state.dart';
import 'package:noble_invoice/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:noble_invoice/features/qr_generator/controllers/qr_history_controller.dart';
import 'package:noble_invoice/features/qr_generator/controllers/qr_generator_controller.dart';
import 'package:noble_invoice/data/models/qr_code_model.dart';

class QrHistoryScreen extends StatefulWidget {
  final bool showHeader;
  const QrHistoryScreen({super.key, this.showHeader = true});

  @override
  State<QrHistoryScreen> createState() => _QrHistoryScreenState();
}

class _QrHistoryScreenState extends State<QrHistoryScreen> with AutomaticKeepAliveClientMixin {
  final List<String> _filters = ['All Types', 'Business', 'WiFi', 'URL', 'vCard', 'Image', 'PDF', 'MP3'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QrHistoryController>().loadHistory();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<QrHistoryController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                if (widget.showHeader)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('History', style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w800)),
                          if (controller.selectedFolderId != null)
                            GestureDetector(
                              onTap: () => controller.setSelectedFolderId(null),
                              child: Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                child: const Row(
                                  children: [
                                    Icon(Icons.folder_open_rounded, size: 10, color: AppColors.primary),
                                    SizedBox(width: 4),
                                    Text('Folder Active (Tap to clear)', style: TextStyle(color: AppColors.primary, fontSize: 9, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                       Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add_rounded, color: AppColors.primary),
                          onPressed: () {
                             Navigator.pushNamed(context, AppRoutes.qrTypeSelection);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: TextField(
                      onChanged: (val) => controller.setSearchQuery(val),
                      decoration: InputDecoration(
                        hintText: 'Search by name...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkGrey),
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.darkGrey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ),

                // Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: List.generate(_filters.length, (index) {
                      final isSelected = controller.selectedType == _filters[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => controller.setSelectedType(_filters[index]),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: isSelected ? null : Border.all(color: AppColors.lightGrey),
                            ),
                            child: Text(
                              _filters[index],
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isSelected ? Colors.white : AppColors.textBlack,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 20),

                // List
                Expanded(
                  child: controller.isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : controller.qrs.isEmpty 
                        ? EmptyState(
                            icon: controller.searchQuery.isEmpty ? Icons.qr_code_2_rounded : Icons.search_off_rounded,
                            title: controller.searchQuery.isEmpty ? 'No QR Codes Yet' : 'No matches found',
                            description: controller.searchQuery.isEmpty 
                              ? 'Start by creating your first QR code to see it appear in your history.'
                              : 'We couldn\'t find any QR codes matching your filters.',
                            actionLabel: controller.searchQuery.isEmpty ? 'Create QR Code' : 'Clear Filters',
                            onAction: () {
                              if (controller.searchQuery.isEmpty) {
                                Navigator.pushNamed(context, AppRoutes.qrTypeSelection);
                              } else {
                                controller.setSearchQuery('');
                                controller.setSelectedType('All Types');
                              }
                            },
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            itemCount: controller.qrs.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final qr = controller.qrs[index];
                              return _buildHistoryCard(qr);
                            },
                          ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryCard(QrCode qr) {
    final color = Color(int.parse(qr.colorPrimary.replaceFirst('#', '0xFF')));
    final dateStr = qr.createdAt != null ? DateFormat('MMM d, yyyy').format(qr.createdAt!) : 'Just now';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Preview
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Icon(_getIconForType(qr.type), size: 32, color: color),
          ),
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        qr.name,
                        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        qr.type.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Generated $dateStr',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.darkGrey, fontSize: 11),
                ),
                const SizedBox(height: 12),
                
                // Actions
                Row(
                  children: [
                    _buildActionButton(Icons.share_rounded, 'Share'),
                    const SizedBox(width: 16),
                    _buildActionButton(Icons.download_rounded, 'Save'),
                    const SizedBox(width: 16),
                    _buildActionButton(
                      Icons.edit_rounded, 
                      'Edit', 
                      onTap: () {
                        final gen = context.read<QrGeneratorController>();
                        gen.loadFromQrCode(qr);
                        
                        // Navigate to specific form
                        String route = AppRoutes.qrTypeSelection; // Fallback
                        switch(qr.type.toLowerCase()) {
                          case 'website': case 'url': route = AppRoutes.websiteQrForm; break;
                          case 'wifi': route = AppRoutes.wifiQrForm; break;
                          case 'vcard': route = AppRoutes.vCardQrForm; break;
                          case 'business': route = AppRoutes.businessQrForm; break;
                          case 'social_media': route = AppRoutes.socialMediaQrForm; break;
                          case 'pdf': route = AppRoutes.pdfQrForm; break;
                          case 'image': route = AppRoutes.imageQrForm; break;
                          case 'video': route = AppRoutes.videoQrForm; break;
                          case 'mp3': route = AppRoutes.mp3QrForm; break;
                          case 'email': route = AppRoutes.emailQrForm; break;
                          case 'whatsapp': route = AppRoutes.whatsappQrForm; break;
                        }
                        Navigator.pushNamed(context, route);
                      },
                    ),
                    const Spacer(),
                    const Icon(Icons.more_horiz_rounded, color: AppColors.darkGrey, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'wifi': return Icons.wifi_rounded;
      case 'url': case 'website': return Icons.language_rounded;
      case 'vcard': return Icons.contact_page_rounded;
      case 'image': return Icons.image_rounded;
      case 'pdf': return Icons.picture_as_pdf_rounded;
      case 'mp3': return Icons.music_note_rounded;
      case 'business': return Icons.business_center_rounded;
      default: return Icons.qr_code_2_rounded;
    }
  }

  Widget _buildActionButton(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
