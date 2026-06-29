import 'dart:math';
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:noble_invoice/features/qr_generator/controllers/qr_analytics_controller.dart';

class QrAnalyticsScreen extends StatefulWidget {
  const QrAnalyticsScreen({super.key});

  @override
  State<QrAnalyticsScreen> createState() => _QrAnalyticsScreenState();
}

class _QrAnalyticsScreenState extends State<QrAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QrAnalyticsController>().loadAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QrAnalyticsController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('QR Performance', style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: const SizedBox.shrink(),
          ),
          body: RefreshIndicator(
            onRefresh: () => controller.loadAnalytics(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Filter
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _buildDateFilter('7 Days', true),
                        _buildDateFilter('30 Days', false),
                        _buildDateFilter('All Time', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Key Metrics
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard('Total Scans', NumberFormat.compact().format(controller.totalScans), '+12%')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMetricCard('Unique Users', NumberFormat.compact().format(controller.uniqueUsers), '+8%')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTopPerformingCard(controller.topPerformingName),
                  
                  const SizedBox(height: 24),

                  // Scan Trends Chart
                  _buildChartSection(
                    'Scan Trends',
                    'Hourly Avg: ${(controller.totalScans / 168).toStringAsFixed(1)}',
                    Container(
                      height: 150,
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomPaint(
                        painter: _TrendLinePainter(color: AppColors.primary, data: controller.trendData),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Geo Distribution
                  _buildChartSection(
                    'Geographic Distribution',
                    '',
                    Row(
                      children: [
                         SizedBox(
                          width: 100,
                          height: 100,
                          child: CustomPaint(
                            painter: _PieChartPainter(data: controller.geoData),
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Column(
                            children: controller.geoData.entries.map((e) {
                              final index = controller.geoData.keys.toList().indexOf(e.key);
                              final opacities = [1.0, 0.6, 0.3, 0.15];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildLegendItem(e.key, '${e.value.toInt()}%', AppColors.primary.withOpacity(0.1)),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                  
                   const SizedBox(height: 24),
                   
                   // Recent Activity
                   Text('Real-time Activity', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                   const SizedBox(height: 12),
                   ...controller.recentActivity.map((a) => Padding(
                     padding: const EdgeInsets.only(bottom: 8),
                     child: _buildActivityItem(a['icon'], a['title'], a['subtitle']),
                   )),
                   
                   const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateFilter(String label, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected ? [
            BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
          ] : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.darkGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String change) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: AppColors.darkGrey, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(width: 6),
              Text(change, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformingCard(String name) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Top Performing QR', style: TextStyle(color: AppColors.darkGrey, fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          Container(
             width: 40,
             height: 40,
             decoration: BoxDecoration(
               color: AppColors.background,
               borderRadius: BorderRadius.circular(8),
             ),
             child: const Icon(Icons.qr_code_2_rounded, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(String title, String subtitle, Widget content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              if (subtitle.isNotEmpty)
                Text(subtitle, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.darkGrey)),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }
  
  Widget _buildLegendItem(String label, String percent, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
             Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
             const SizedBox(width: 8),
             Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
        Text(percent, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
  
  Widget _buildActivityItem(IconData icon, String title, String subtitle) {
      return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        children: [
           Container(
             width: 36,
             height: 36,
             decoration: const BoxDecoration(
               color: AppColors.background,
               shape: BoxShape.circle,
             ),
             child: Icon(icon, size: 20, color: AppColors.primary),
           ),
           const SizedBox(width: 12),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.darkGrey)),
               ],
             ),
           ),
        ],
      ),
    );
  }
}

class _TrendLinePainter extends CustomPainter {
  final Color color;
  final List<double> data;
  _TrendLinePainter({required this.color, required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final xStep = size.width / (data.length - 1);
    
    // Normalize data to fit size.height
    final maxVal = data.reduce(max).clamp(1.0, double.infinity);
    
    path.moveTo(0, size.height - (data[0] / maxVal * size.height * 0.8));
    
    for (int i = 1; i < data.length; i++) {
      path.lineTo(i * xStep, size.height - (data[i] / maxVal * size.height * 0.8));
    }

    canvas.drawPath(path, paint);
    
    // Gradient fill
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.1), color.withOpacity(0.1)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
      
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _TrendLinePainter oldDelegate) => oldDelegate.data != data;
}

class _PieChartPainter extends CustomPainter {
  final Map<String, double> data;
  _PieChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 8.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -1.57; // Start at top
    final opacities = [1.0, 0.6, 0.3, 0.15];
    int index = 0;

    data.forEach((key, value) {
      paint.color = AppColors.primary.withOpacity(0.1);
      final sweepAngle = (value / 100) * 2 * pi;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius - strokeWidth/2), startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
      index++;
    });
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) => oldDelegate.data != data;
}

