import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';

class QrPerformanceInsightsScreen extends StatelessWidget {
  const QrPerformanceInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('QR Performance', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.filter_list_rounded, color: AppColors.primary), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share_rounded, color: Colors.grey), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTimeframeSelector(),
            _buildKPICards(),
            _buildScanTrendsChart(),
            _buildGeographicMap(),
            _buildTopPerformingList(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeframeSelector() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Expanded(child: _buildTimeBtn('1D')),
            Expanded(child: _buildTimeBtn('7D')),
            Expanded(child: _buildTimeBtn('30D', isActive: true)),
            Expanded(child: _buildTimeBtn('1Y')),
            Expanded(child: _buildTimeBtn('ALL')),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBtn(String label, {bool isActive = false}) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] : null,
      ),
      child: Text(label, style: TextStyle(color: isActive ? AppColors.primary : Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  Widget _buildKPICards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildKPICard('Total Scans', '12,402', '+12.5%', Icons.qr_code_2_rounded, Colors.green),
          const SizedBox(width: 12),
          _buildKPICard('Unique Users', '8,915', '+5.2%', Icons.group_rounded, Colors.green),
          const SizedBox(width: 12),
          _buildKPICard('Conversion', '34.2%', '-1.4%', Icons.ads_click_rounded, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildKPICard(String title, String value, String growth, IconData icon, Color growthColor) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
              Icon(icon, color: AppColors.primary, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(growth.contains('+') ? Icons.trending_up_rounded : Icons.trending_down_rounded, color: growthColor, size: 14),
              const SizedBox(width: 4),
              Text(growth, style: TextStyle(color: growthColor, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScanTrendsChart() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Scan Trends', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('Avg. 413 scans/day', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 220,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.lightGrey)),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      // Simulated Bars
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(14, (index) {
                          final h = (0.2 + 0.8 * (index % 5 / 5.0)) * 100;
                          return Container(
                            width: 8,
                            height: h,
                            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(2)),
                          );
                        }),
                      ),
                      // Line Overlay
                      CustomPaint(
                        size: const Size(double.infinity, double.infinity),
                        painter: TrendLinePainter(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('MAY 01', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('MAY 15', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('MAY 30', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeographicMap() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Scans by Region', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextButton(onPressed: () {}, child: const Text('View Global', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?auto=format&fit=crop&q=80&w=1000'),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
              color: AppColors.primary.withOpacity(0.1),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Stack(
              children: [
                _buildMapDot(0.25, 0.3, 24),
                _buildMapDot(0.5, 0.6, 32),
                _buildMapDot(0.7, 0.2, 20),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.lightGrey)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMapLegendItem('California, US (4.2k)', AppColors.primary),
                        const SizedBox(height: 4),
                        _buildMapLegendItem('London, UK (1.8k)', AppColors.primary.withOpacity(0.1)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapDot(double top, double left, double size) {
    return Positioned(
      top: 200 * top,
      left: 300 * left, // Rough estimate
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
        child: Center(child: Container(width: size/3, height: size/3, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle))),
      ),
    );
  }

  Widget _buildMapLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTopPerformingList() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Top Performing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 4),
          _buildPerformingItem('Summer Campaign \'24', 'Retail Outlet A • Active', '4,812', 'Highest Scans', Colors.green),
          const SizedBox(height: 12),
          _buildPerformingItem('Menu-Table-VIP', 'Restaurant • Active', '2,104', 'Stable', Colors.grey),
          const SizedBox(height: 12),
          _buildPerformingItem('Concert Promo 05', 'Event Hall • Expired', '1,559', 'Final Count', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPerformingItem(String title, String subtitle, String count, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.lightGrey)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.qr_code_2_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(count, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              Text(status, style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class TrendLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.1, size.height * 0.55);
    path.lineTo(size.width * 0.2, size.height * 0.6);
    path.lineTo(size.width * 0.3, size.height * 0.4);
    path.lineTo(size.width * 0.4, size.height * 0.15);
    path.lineTo(size.width * 0.5, size.height * 0.3);
    path.lineTo(size.width * 0.6, size.height * 0.45);
    path.lineTo(size.width * 0.7, size.height * 0.6);
    path.lineTo(size.width * 0.8, size.height * 0.5);
    path.lineTo(size.width * 0.9, size.height * 0.65);
    path.lineTo(size.width, size.height * 0.05);

    canvas.drawPath(path, paint);
    
    // Dot at peak
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.15), 3, Paint()..color = AppColors.primary);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
