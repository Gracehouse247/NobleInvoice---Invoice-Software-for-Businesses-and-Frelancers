'use client';

import Script from 'next/script';

export default function SchemaOrg() {
  const schema = {
    "@context": "https://schema.org",
    "@type": "SoftwareApplication",
    "name": "NobleInvoice",
    "applicationCategory": "BusinessApplication",
    "operatingSystem": "Web",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Enterprise-Grade Invoicing, Client Management, and Business Intelligence platform.",
    "publisher": {
      "@type": "Organization",
      "name": "NobleInvoice Team",
      "url": "https://nobleinvoice.noblesworld.com.ng",
      "logo": "https://nobleinvoice.noblesworld.com.ng/images/logo.png"
    }
  };

  return (
    <Script
      id="schema-org"
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }}
    />
  );
}
