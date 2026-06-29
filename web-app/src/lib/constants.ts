import { 
    LayoutDashboard, FileText, Users, Layers, Wallet,
    Settings, Network, BarChart3, CreditCard, Receipt,
    QrCode, Contact, LifeBuoy, Package, ShieldCheck, Zap,
    Building2
} from 'lucide-react';

export const QUOTES = [
    { text: "The secret of getting ahead is getting started.", author: "Mark Twain" },
    { text: "Success is not final, failure is not fatal: It is the courage to continue that counts.", author: "Winston S. Churchill" },
    { text: "Excellence is not a destination but a continuous journey.", author: "Brian Tracy" },
    { text: "The way you do one thing is the way you do everything.", author: "NobleInvoice AI" },
    { text: "Productivity is never an accident. It is always the result of excellence.", author: "Paul J. Meyer" },
    { text: "Your focus determines your reality. Control the workflow.", author: "NobleInvoice AI" },
    { text: "Strive not to be a success, but rather to be of value.", author: "Albert Einstein" },
];

export const MENU_GROUPS = [
    {
        label: 'Workspace',
        items: [
            { name: 'Dashboard', icon: LayoutDashboard, href: '/dashboard' },
            { name: 'Invoicing Engine', icon: FileText, href: '/invoices' },
            { name: 'Client CRM', icon: Users, href: '/clients' },
            { name: 'Team Intelligence', icon: ShieldCheck, href: '/settings/team', requiredPlan: 'elite' },
        ]
    },
    {
        label: 'Financials & Stock',
        items: [
            { name: 'Expenses Hub', icon: Receipt, href: '/expenses' },
            { name: 'Products & Services', icon: Layers, href: '/products' },
            { name: 'Inventory Ledger', icon: Package, href: '/inventory', requiredPlan: 'pro' },
            { name: 'Wallet & Payments', icon: Wallet, href: '/wallet', requiredPlan: 'pro' },
        ]
    },
    {
        label: 'Networking & Growth',
        items: [
            { name: 'QR Code Engine', icon: QrCode, href: '/qr-generator' },
            { name: 'Professional Identity', icon: Contact, href: '/studio' },
            { name: 'Lead Intelligence', icon: Zap, href: '/networking', requiredPlan: 'pro' },
            { name: 'Enterprise Scaling', icon: Building2, href: '/enterprise/identity', requiredPlan: 'elite' },
            { name: 'Growth Reports', icon: BarChart3, href: '/reports' },
        ]
    },
    {
        label: 'System',
        items: [
            { name: 'Settings', icon: Settings, href: '/settings/brand' },
            { name: 'Billing & Plans', icon: CreditCard, href: '/upgrade' },
            { name: 'Support Node', icon: LifeBuoy, href: '/support' },
        ]
    }
];
