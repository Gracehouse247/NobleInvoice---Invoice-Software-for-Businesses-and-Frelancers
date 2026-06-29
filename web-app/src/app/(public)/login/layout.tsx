import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Sign In — Free Invoice Maker App | NobleInvoice',
  description: 'Sign in to NobleInvoice, the free invoice maker app. Is there an app for making invoices? Yes — create invoices, manage clients, and get paid from any device.',
  keywords: ['is there an app for making invoices', 'free invoice maker app', 'invoice generator login', 'how can I generate an invoice for free'],
};

export default function LoginLayout({ children }: { children: React.ReactNode }) {
  return <>{children}</>;
}
