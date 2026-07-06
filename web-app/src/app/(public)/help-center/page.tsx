import React from 'react';
import type { Metadata } from 'next';
import Script from 'next/script';
import HelpClientPage from '@/components/help/HelpClientPage';

export const metadata: Metadata = {
    title: 'Help Center | Customer Support | NobleInvoice',
    description: 'Explore the NobleInvoice Help Center. Find setup guides, billing troubleshooting, integration help, and API documentation.',
    keywords: ['help center', 'customer support', 'nobleinvoice help', 'setup guide', 'billing troubleshooting'],
    openGraph: {
        title: 'Help Center | NobleInvoice',
        description: 'Find answers, setup guides, and best practices for using NobleInvoice.',
        url: 'https://nobleinvoice.com/help-center',
        type: 'website',
    },
};

const helpCenterSchema = [
    {
        "@context": "https://schema.org",
        "@type": "WebPage",
        "name": "NobleInvoice Help Center",
        "description": "Explore the NobleInvoice Help Center for setup guides, billing troubleshooting, integration help, and API documentation.",
        "url": "https://nobleinvoice.com/help-center",
        "publisher": { "@type": "Organization", "name": "NobleInvoice" }
    },
    {
        "@context": "https://schema.org",
        "@type": "WebSite",
        "url": "https://nobleinvoice.com/help-center",
        "potentialAction": {
            "@type": "SearchAction",
            "target": "https://nobleinvoice.com/help-center?q={search_term_string}",
            "query-input": "required name=search_term_string"
        }
    }
];

export default function HelpCenterPage() {
    return (
        <div className="bg-white text-near-black font-inter antialiased overflow-x-hidden pt-[118px]">
            <Script id="help-schema" type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(helpCenterSchema) }} />
            <HelpClientPage />
        </div>
    );
}
