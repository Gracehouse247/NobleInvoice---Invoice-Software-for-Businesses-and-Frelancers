'use client';

import { useEffect } from 'react';

export default function PWARegistration() {
    useEffect(() => {
        if (
            typeof window !== 'undefined' &&
            'serviceWorker' in navigator &&
            window.location.hostname !== 'localhost'
        ) {
            window.addEventListener('load', () => {
                navigator.serviceWorker.register('/sw.js').then(
                    (reg) => {
                        console.log('[SW] Registration successful');
                    },
                    (err) => {
                        console.warn('[SW] Registration failed: ', err);
                    }
                );
            });
        }
    }, []);

    return null;
}

