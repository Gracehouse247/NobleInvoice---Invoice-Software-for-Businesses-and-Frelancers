
const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "../src/components/shared/Navbar.tsx");
let content = fs.readFileSync(filePath, "utf-8");

// We need to replace the `platforms` and `products` arrays.
const newArrays = `
    const solutions = [
        {
            category: "Core Financials",
            items: [
                { title: "Invoicing Pro", desc: "High-end PDF generation", icon: "description", href: "/features/invoice-generator" },
                { title: "Expense Manager", desc: "Track spending & deductions", icon: "receipt_long", href: "/features/expense-manager" },
                { title: "Global Settlements", desc: "Get paid across borders", icon: "account_balance_wallet", href: "/features/settlements" },
                { title: "Products Catalog", desc: "Standardize your billing", icon: "category", href: "/features/products-services" },
                { title: "Growth Reports", desc: "Data-driven decisions", icon: "bar_chart", href: "/features/growth-reports" },
            ]
        },
        {
            category: "Growth & CRM",
            items: [
                { title: "CRM Engine", desc: "Full client lifecycle", icon: "hub", href: "/features/crm-engine" },
                { title: "Client Portal", desc: "White-label dashboard", icon: "vpn_key", href: "/features/client-portal" },
                { title: "Lead Intelligence", desc: "Track prospects to paid", icon: "track_changes", href: "/features/lead-intelligence" },
                { title: "Digital Cards", desc: "NFC & QR networking", icon: "contactless", href: "/features/digital-business-cards" },
                { title: "QR Payments", desc: "Scan to pay instantly", icon: "qr_code_scanner", href: "/features/qr-business-cards" },
            ]
        },
        {
            category: "Elite & Enterprise",
            items: [
                { title: "Inventory Hub", desc: "Real-time stock tracking", icon: "inventory_2", href: "/features/inventory-hub" },
                { title: "AI Voice Assistant", desc: "Hands-free business ops", icon: "mic", href: "/features/ai-voice-assistant" },
                { title: "Team Workspace", desc: "Multi-user collaboration", icon: "groups", href: "/features/team-workspace" },
                { title: "Enterprise Scaling", desc: "High-volume infrastructure", icon: "domain", href: "/features/enterprise-scaling" },
                { title: "Professional Identity", desc: "Premium custom branding", icon: "palette", href: "/features/professional-identity" },
            ]
        }
    ];

    const companyLinks = [
        { label: "About / Our Story", href: "/about" },
        { label: "Press Kit", href: "/blog" },
    ];
`;

// Replace platforms and products definition
content = content.replace(/const platforms = \[[\s\S]*?\];\s*const products = \[[\s\S]*?\];/m, newArrays.trim());

// We need to replace the Solutions Mega Menu JSX
const oldSolutionsJSX = /{ \/\* Solutions Mega Menu \*\/\}[\s\S]*?{ \/\* Products Mega Menu \*\/}/m;
const newSolutionsJSX = `{/* Solutions Mega Menu */}
                        <div
                            className="relative h-full flex items-center"
                            onMouseEnter={() => setActiveMenu("solutions")}
                            onMouseLeave={() => setActiveMenu(null)}
                        >
                            <button className={\`text-sm font-bold uppercase tracking-widest transition-colors flex items-center gap-1 \${activeMenu === "solutions" ? "text-noble-blue" : "text-near-black/70 hover:text-noble-blue"}\`}>
                                Solutions <ChevronDown className={\`w-3.5 h-3.5 transition-transform \${activeMenu === "solutions" ? "rotate-180" : ""}\`} />
                            </button>
                            <AnimatePresence>
                                {activeMenu === "solutions" && (
                                    <motion.div
                                        initial={{ opacity: 0, y: 10 }}
                                        animate={{ opacity: 1, y: 0 }}
                                        exit={{ opacity: 0, y: 10 }}
                                        transition={{ duration: 0.18 }}
                                        className="absolute top-[70px] left-1/2 -translate-x-1/2 w-[950px] bg-white/95 backdrop-blur-2xl rounded-3xl p-10 shadow-[0_50px_100px_rgba(0,0,0,0.1)] border border-near-black/5"
                                    >
                                        <div className="grid grid-cols-3 gap-10">
                                            {solutions.map((col) => (
                                                <div key={col.category}>
                                                    <h3 className="text-[10px] font-black text-noble-blue uppercase tracking-widest mb-6 border-b border-near-black/5 pb-2">{col.category}</h3>
                                                    <div className="space-y-6">
                                                        {col.items.map((item) => (
                                                            <Link key={item.title} href={item.href} className="flex gap-4 group cursor-pointer">
                                                                <div className="shrink-0 w-10 h-10 rounded-xl bg-noble-blue/5 flex items-center justify-center text-noble-blue group-hover:bg-noble-blue group-hover:text-white transition-all shadow-sm">
                                                                    <span className="material-symbols-outlined text-[20px]">{item.icon}</span>
                                                                </div>
                                                                <div>
                                                                    <h4 className="font-bold text-sm text-near-black group-hover:text-noble-blue transition-colors mb-0.5">{item.title}</h4>
                                                                    <p className="text-[11px] text-near-black/50 leading-relaxed font-medium">{item.desc}</p>
                                                                </div>
                                                            </Link>
                                                        ))}
                                                    </div>
                                                </div>
                                            ))}
                                        </div>
                                    </motion.div>
                                )}
                            </AnimatePresence>
                        </div>

                        {/* Company Mega Menu */}
                        <div
                            className="relative h-full flex items-center"
                            onMouseEnter={() => setActiveMenu("company")}
                            onMouseLeave={() => setActiveMenu(null)}
                        >
                            <button className={\`text-sm font-bold uppercase tracking-widest transition-colors flex items-center gap-1 \${activeMenu === "company" ? "text-noble-blue" : "text-near-black/70 hover:text-noble-blue"}\`}>
                                Company <ChevronDown className={\`w-3.5 h-3.5 transition-transform \${activeMenu === "company" ? "rotate-180" : ""}\`} />
                            </button>
                            <AnimatePresence>
                                {activeMenu === "company" && (
                                    <motion.div
                                        initial={{ opacity: 0, y: 10 }}
                                        animate={{ opacity: 1, y: 0 }}
                                        exit={{ opacity: 0, y: 10 }}
                                        transition={{ duration: 0.18 }}
                                        className="absolute top-[70px] left-1/2 -translate-x-1/2 w-[240px] bg-white/95 backdrop-blur-2xl rounded-2xl p-4 shadow-[0_50px_100px_rgba(0,0,0,0.1)] border border-near-black/5 flex flex-col gap-2"
                                    >
                                        {companyLinks.map((link) => (
                                            <Link
                                                key={link.label}
                                                href={link.href}
                                                className="px-4 py-3 rounded-xl hover:bg-noble-blue/5 text-sm font-bold text-near-black/70 hover:text-noble-blue transition-colors"
                                            >
                                                {link.label}
                                            </Link>
                                        ))}
                                    </motion.div>
                                )}
                            </AnimatePresence>
                        </div>`;

content = content.replace(oldSolutionsJSX, newSolutionsJSX);

// Now handle mobile menu
const oldMobileNavJSX = /{ \/\* Solutions Mobile Accordion \*\/\}[\s\S]*?{ \/\* Products Mobile Accordion \*\/}/m;
const newMobileNavJSX = `{/* Solutions Mobile Accordion */}
                                <div className="space-y-2">
                                    <button 
                                        onClick={() => setMobileSubmenu(mobileSubmenu === "solutions" ? null : "solutions")}
                                        className="w-full flex items-center justify-between py-3 px-4 rounded-xl hover:bg-near-black/5 transition-colors"
                                    >
                                        <span className="font-bold uppercase tracking-widest text-sm text-near-black/70">Solutions</span>
                                        <ChevronDown className={\`w-4 h-4 transition-transform \${mobileSubmenu === "solutions" ? "rotate-180" : ""}\`} />
                                    </button>
                                    <AnimatePresence>
                                        {mobileSubmenu === "solutions" && (
                                            <motion.div 
                                                initial={{ height: 0, opacity: 0 }}
                                                animate={{ height: "auto", opacity: 1 }}
                                                exit={{ height: 0, opacity: 0 }}
                                                className="overflow-hidden"
                                            >
                                                <div className="pl-6 pr-4 py-2 space-y-6">
                                                    {solutions.map((col) => (
                                                        <div key={col.category}>
                                                            <h4 className="text-[10px] font-black text-noble-blue uppercase tracking-widest mb-3">{col.category}</h4>
                                                            <div className="space-y-4">
                                                                {col.items.map(item => (
                                                                    <Link key={item.title} href={item.href} onClick={() => setMobileOpen(false)} className="flex items-center gap-3">
                                                                        <div className="w-8 h-8 rounded-lg bg-noble-blue/10 flex items-center justify-center text-noble-blue">
                                                                            <span className="material-symbols-outlined text-[16px]">{item.icon}</span>
                                                                        </div>
                                                                        <div>
                                                                            <div className="text-sm font-bold text-near-black">{item.title}</div>
                                                                        </div>
                                                                    </Link>
                                                                ))}
                                                            </div>
                                                        </div>
                                                    ))}
                                                </div>
                                            </motion.div>
                                        )}
                                    </AnimatePresence>
                                </div>

                                {/* Company Mobile Accordion */}
                                <div className="space-y-2">
                                    <button 
                                        onClick={() => setMobileSubmenu(mobileSubmenu === "company" ? null : "company")}
                                        className="w-full flex items-center justify-between py-3 px-4 rounded-xl hover:bg-near-black/5 transition-colors"
                                    >
                                        <span className="font-bold uppercase tracking-widest text-sm text-near-black/70">Company</span>
                                        <ChevronDown className={\`w-4 h-4 transition-transform \${mobileSubmenu === "company" ? "rotate-180" : ""}\`} />
                                    </button>
                                    <AnimatePresence>
                                        {mobileSubmenu === "company" && (
                                            <motion.div 
                                                initial={{ height: 0, opacity: 0 }}
                                                animate={{ height: "auto", opacity: 1 }}
                                                exit={{ height: 0, opacity: 0 }}
                                                className="overflow-hidden"
                                            >
                                                <div className="pl-6 pr-4 py-2 flex flex-col gap-3">
                                                    {companyLinks.map(link => (
                                                        <Link key={link.label} href={link.href} onClick={() => setMobileOpen(false)} className="text-sm font-bold text-near-black/70 hover:text-noble-blue">
                                                            {link.label}
                                                        </Link>
                                                    ))}
                                                </div>
                                            </motion.div>
                                        )}
                                    </AnimatePresence>
                                </div>`;

content = content.replace(oldMobileNavJSX, newMobileNavJSX);

// Also remove the "Products Mega Menu" JSX entirely as we consolidated it into "Solutions" and "Company"
content = content.replace(/{ \/\* Products Mega Menu \*\/\}[\s\S]*?{ \/\* Desktop CTA Group \*\/}/m, `{/* Desktop CTA Group */}`);
content = content.replace(/{ \/\* Products Mobile Accordion \*\/\}[\s\S]*?{ \/\* Mobile CTA \*\/}/m, `{/* Mobile CTA */}`);

fs.writeFileSync(filePath, content, "utf-8");
console.log("Navbar successfully refactored!");

