import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/core/widgets/glass_container.dart';
import 'package:noble_invoice/routes/app_routes.dart';

class ActionCards extends StatelessWidget {
  const ActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: [
            _buildDashboardAction(context, Icons.receipt_long_rounded, 'Invoicing', AppColors.primary, AppRoutes.invoiceDashboard),
            _buildDashboardAction(context, Icons.people_alt_rounded, 'Clients', AppColors.secondary, AppRoutes.crmDashboard),
            _buildDashboardAction(context, Icons.inventory_2_rounded, 'Inventory', const Color(0xFF6366F1), AppRoutes.productList),
            _buildDashboardAction(context, Icons.auto_awesome_rounded, 'Intelligence', AppColors.primary, AppRoutes.financialIntelligence),
            _buildDashboardAction(context, Icons.badge_rounded, 'Business Card', Colors.orange, AppRoutes.businessCardDesigner),
            _buildDashboardAction(context, Icons.groups_rounded, 'Team', AppColors.primaryDark, AppRoutes.teamManagement),
        ],
      );
  }

  Widget _buildDashboardAction(BuildContext context, IconData icon, String title, Color color, String route) {
    return GlassContainer(
      borderRadius: BorderRadius.circular(24), // Bento box styling
      opacity: 0.7,
      blur: 20,
      border: Border.all(
        color: Colors.white.withOpacity(0.65),
        width: 1.5,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, route),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.12),
                      color.withOpacity(0.12),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textBlack,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
