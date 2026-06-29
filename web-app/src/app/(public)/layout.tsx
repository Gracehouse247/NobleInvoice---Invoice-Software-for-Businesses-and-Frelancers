'use client';

import { usePathname } from 'next/navigation';
import Navbar from '@/components/shared/Navbar';
import CookieConsent from '@/components/shared/CookieConsent';

const AUTH_PATHS = ['/register', '/login'];

export default function PublicLayout({
    children,
}: {
    children: React.ReactNode;
}) {
    const pathname = usePathname();
    const isAuthPage = AUTH_PATHS.includes(pathname);

    return (
        <div className="flex flex-col min-h-screen bg-[#F8FAFC]">
            {!isAuthPage && <Navbar />}
            <main className={`flex-1 ${!isAuthPage ? 'max-w-[1430px] mx-auto w-full' : ''}`}>
                {children}
            </main>
            <CookieConsent />
        </div>
    );
}
