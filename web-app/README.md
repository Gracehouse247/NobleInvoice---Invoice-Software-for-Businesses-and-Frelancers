# NobleInvoice Web Platform

NobleInvoice is a premium, enterprise-grade business suite designed for modern professionals and creative agencies. It combines advanced invoicing, client management, and financial analytics into a unified, high-performance ecosystem.

## Core Features

- **Advanced Invoicing**: Professional, customizable templates with global tax support.
- **Client CRM**: Manage relationships and project history in a focused environment.
- **Financial Analytics**: Deep insights into revenue streams and expense tracking.
- **AI-Powered Insights**: Smart suggestions for billing optimizations and growth metrics.
- **PWA Ready**: Installable as a progressive web app for native-like performance on all devices.

## Tech Stack

- **Framework**: [Next.js 16 (App Router)](https://nextjs.org/)
- **Logic**: TypeScript & React 19
- **Styling**: Tailwind CSS v4 & Framer Motion
- **Database**: Supabase (PostgreSQL) & Firebase (Auth/Sync)
- **Payments**: Flutterwave Integration

## Getting Started

### Prerequisites

- Node.js 20+
- npm / yarn / pnpm

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```
3. Set up environment variables in `.env.local`:
   ```env
   NEXT_PUBLIC_FIREBASE_API_KEY=your_key
   NEXT_PUBLIC_FLW_PUBLIC_KEY=your_key
   NEXT_PUBLIC_API_URL=https://nobleinvoice.noblesworld.com.ng/api
   ```
4. Start the development server:
   ```bash
   npm run dev
   ```

## License

© 2026 NoblesWorld. All rights reserved.
