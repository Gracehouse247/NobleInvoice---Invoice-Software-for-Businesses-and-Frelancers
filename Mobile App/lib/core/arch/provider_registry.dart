// lib/core_v2/arch/provider_registry.dart
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:noble_invoice/features/auth/controllers/auth_controller.dart';
import 'package:noble_invoice/features/profile/controllers/profile_controller.dart';
import 'package:noble_invoice/features/profile/controllers/team_controller.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart';
import 'package:noble_invoice/features/wallet/controllers/payment_controller.dart';
import 'package:noble_invoice/features/invoicing/controllers/recurring_invoice_controller.dart';
import 'package:noble_invoice/features/expenses/controllers/expense_controller.dart';
import 'package:noble_invoice/features/inventory/controllers/product_controller.dart';
import 'package:noble_invoice/features/wallet/controllers/subscription_controller.dart';
import 'package:noble_invoice/features/clients/controllers/client_crm_controller.dart';
import 'package:noble_invoice/features/wallet/controllers/revenue_analytics_controller.dart';
import 'package:noble_invoice/features/qr_generator/controllers/qr_generator_controller.dart';
import 'package:noble_invoice/features/qr_generator/controllers/folder_controller.dart';
import 'package:noble_invoice/features/qr_generator/controllers/qr_analytics_controller.dart';
import 'package:noble_invoice/features/qr_generator/controllers/qr_history_controller.dart';
import 'package:noble_invoice/features/brand/controllers/brand_controller.dart';
import 'package:noble_invoice/features/profile/controllers/session_controller.dart';
import 'package:noble_invoice/features/brand/controllers/asset_gallery_controller.dart';
import 'package:noble_invoice/features/business_card/controllers/business_card_controller.dart';
import 'package:noble_invoice/features/analytics/controllers/intelligence_controller.dart';
import 'package:noble_invoice/features/admin/controllers/admin_controller.dart';
import 'package:noble_invoice/features/ai_assistant/controllers/ai_assistant_controller.dart';

List<SingleChildWidget> buildProviders() => [
  // ── TIER 1: Core System & Auth (No Dependencies) ──────────────────────
  ChangeNotifierProvider(create: (_) => SubscriptionController()),
  ChangeNotifierProvider(create: (_) => AuthController()),
  ChangeNotifierProvider(create: (_) => ProfileController()),
  ChangeNotifierProvider(create: (_) => AdminController()),
  ChangeNotifierProvider(create: (_) => AssetGalleryController()),
  ChangeNotifierProvider(create: (_) => SessionController()),
  ChangeNotifierProvider(create: (_) => AiAssistantController()),

  // ── TIER 2: System-Dependent (Depends on Subscription/Auth) ───────────
  ChangeNotifierProxyProvider<SubscriptionController, TeamController>(
    create: (_) => TeamController(),
    update: (_, s, c) => c!..setSubscriptionStatus(s.currentTier, s.isElite),
  ),

  // ── TIER 2: Team-scoped (lazy by default in Provider) ─────────────────
  ChangeNotifierProxyProvider<TeamController, InvoiceController>(
    create: (_) => InvoiceController(),
    update: (_, t, c) => c!..setActiveTeamId(t.activeTeamId),
  ),
  ChangeNotifierProxyProvider<TeamController, ExpenseController>(
    create: (_) => ExpenseController(),
    update: (_, t, c) => c!..setActiveTeamId(t.activeTeamId),
  ),
  ChangeNotifierProxyProvider<TeamController, ProductController>(
    create: (_) => ProductController(),
    update: (_, t, c) => c!..setActiveTeamId(t.activeTeamId),
  ),
  ChangeNotifierProxyProvider2<TeamController, SubscriptionController, ClientCrmController>(
    create: (_) => ClientCrmController(),
    update: (_, t, s, c) => c!
      ..setActiveTeamId(t.activeTeamId)
      ..setSubscriptionStatus(s.currentTier, s.canUse('clients', currentCount: c.clients.length)),
  ),
  ChangeNotifierProxyProvider<TeamController, RecurringInvoiceController>(
    create: (_) => RecurringInvoiceController(),
    update: (_, t, c) => c!..setActiveTeamId(t.activeTeamId),
  ),
  ChangeNotifierProxyProvider<TeamController, QrHistoryController>(
    create: (_) => QrHistoryController(),
    update: (_, t, c) => c!..setActiveTeamId(t.activeTeamId),
  ),
  ChangeNotifierProxyProvider<TeamController, QrAnalyticsController>(
    create: (_) => QrAnalyticsController(),
    update: (_, t, c) => c!..setActiveTeamId(t.activeTeamId),
  ),
  ChangeNotifierProxyProvider<TeamController, RevenueAnalyticsController>(
    create: (_) => RevenueAnalyticsController(),
    update: (_, t, c) => c!..setActiveTeamId(t.activeTeamId),
  ),
  ChangeNotifierProxyProvider<TeamController, IntelligenceController>(
    create: (_) => IntelligenceController(),
    update: (_, t, c) => c!..setActiveTeamId(t.activeTeamId),
  ),
  ChangeNotifierProxyProvider<TeamController, BrandController>(
    create: (ctx) => BrandController(ctx.read<TeamController>()),
    update: (_, t, c) => c!..loadBrandKit(),
  ),
  ChangeNotifierProxyProvider<TeamController, BusinessCardController>(
    create: (ctx) => BusinessCardController(ctx.read<TeamController>()),
    update: (_, t, c) => c!..loadCurrentCard(),
  ),

  // ── TIER 4: Independent Utilities ─────────────────────────────────────
  ChangeNotifierProxyProvider<SubscriptionController, QrGeneratorController>(
    create: (_) => QrGeneratorController(),
    update: (_, s, c) => c!..setSubscriptionStatus(s.currentTier, s.canUse('dynamic_qr')),
  ),
  ChangeNotifierProvider(create: (_) => PaymentController()),
  ChangeNotifierProvider(create: (_) => FolderController()),
];
