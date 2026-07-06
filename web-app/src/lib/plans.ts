export interface Plan {
  id: string;
  name: string;
  tier: 'explorer' | 'pulse' | 'elite' | 'payg';
  priceMonthly: number;
  priceYearly: number;
  monthlyPrice?: number;
  yearlyPrice?: number;
  earlyBirdPrice?: number;
  earlyBirdYearlyPrice?: number;
  features: string[];
  flutterwavePlanIdMonthly?: string;
  flutterwavePlanIdYearly?: string;
  flutterwavePlanIdEarlyBird?: string;
  flutterwaveOneTimeAmount?: number; // For PAYG one-time charge
  popular?: boolean;
  tagline?: string;
}

/** Represents the state of the user's PAYG bundles */
export interface PaygBundleState {
  // Credits available to use
  credits: {
    invoiceTemplates: number;
    businessCardTemplates: number;
    qrCodeTemplates: number;
    clientSlots: number;
  };
  // Specific templates that have been permanently unlocked
  unlockedTemplates: {
    invoices: string[];
    businessCards: string[];
    qrCodes: string[];
  };
  purchases: Array<{
    purchasedAt: string;
    transactionId?: string;
  }>;
}

export const PAYG_PRICE_USD = 1.00;
export const PAYG_PRICE_NGN = 1500; // ≈ $1 at current rates — update as needed

export const PLANS: Record<string, Plan> = {
  explorer: {
    id: 'explorer',
    name: 'Starter',
    tier: 'explorer',
    priceMonthly: 0,
    priceYearly: 0,
    monthlyPrice: 0,
    yearlyPrice: 0,
    tagline: 'For freelancers getting started',
    features: [
      'Up to 10 invoices/month',
      '5 active clients',
      '10 invoice templates',
      'Basic PDF export',
      'Payment link generation',
      'Expense tracking',
      'Email support',
    ],
  },
  pro: {
    id: 'pulse',
    name: 'Noble Pulse',
    tier: 'pulse',
    priceMonthly: 9.99,
    priceYearly: 99.00,
    monthlyPrice: 9.99,
    yearlyPrice: 99.00,
    popular: true,
    tagline: 'For growing businesses',
    features: [
      'Everything in Starter, plus:',
      'Unlimited invoices & clients',
      '180+ premium invoice templates',
      'Advanced Invoice & Client Customization',
      'Recurring invoices & auto-reminders',
      'Full CRM & client portal',
      'Inventory & product catalog',
      'Flutterwave payment integration',
      'Digital Business Cards (NFC & QR)',
      'Digital Product Passports (DPP)',
      'Financial analytics dashboard',
      'Priority email support',
    ],
    flutterwavePlanIdMonthly: '160676',
    flutterwavePlanIdYearly: '160677',
  },
  elite: {
    id: 'elite',
    name: 'Noble Elite',
    tier: 'elite',
    priceMonthly: 24.99,
    priceYearly: 240.00,
    monthlyPrice: 24.99,
    yearlyPrice: 240.00,
    earlyBirdPrice: 199.99,
    earlyBirdYearlyPrice: 199.99,
    tagline: 'For scaling enterprises',
    features: [
      'Everything in Professional, plus:',
      'Multi-user team workspace',
      'Global multi-currency settlements',
      'Advanced tax & compliance reporting',
      'API access & webhooks',
      'Dedicated account manager',
      'White-label client portal',
      'Custom contract & e-signature',
      'Priority 24/7 phone support',
      'Early access to new features',
    ],
    flutterwavePlanIdMonthly: '160678',
    flutterwavePlanIdYearly: '160679',
    flutterwavePlanIdEarlyBird: '160679',
  },
};

export const SUBSCRIPTION_PLANS = Object.values(PLANS);

export type PlanTier = 'explorer' | 'pulse' | 'elite' | 'payg';

/** PAYG product — not a subscription, a one-time invoice template unlock */
export const PAYG_PLAN = {
  id: 'payg',
  name: 'Pay-As-You-Go',
  tier: 'payg' as const,
  priceUSD: PAYG_PRICE_USD,
  priceNGN: PAYG_PRICE_NGN,
  tagline: 'Unlock one premium template, one client, one QR card',
  features: [
    '1 premium invoice template (your choice)',
    '1 client slot',
    '1 QR business card (locked to that client)',
    '1 Digital Product Passport (up to 3 images)',
    'Professional PDF download',
    'Please note this plan is only capable to free user who does not have monthly or yearly subscription',
  ],
};
