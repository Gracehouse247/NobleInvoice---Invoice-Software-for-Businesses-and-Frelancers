'use client';

import { useEffect } from 'react';

export default function PWAClient() {
    useEffect(() => {
        if ('serviceWorker' in navigator && window.location.protocol === 'https:') {
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
        } else if ('serviceWorker' in navigator && process.env.NODE_ENV === 'development') {
            // UNREGISTER service workers in development to prevent caching bugs and HMR issues
            navigator.serviceWorker.getRegistrations().then((registrations) => {
                for (let registration of registrations) {
                    registration.unregister();
                    console.log('ServiceWorker unregistered in development');
                }
            }).catch((err) => {
                console.error('ServiceWorker unregistration failed: ', err);
            });
        }
    }, []);

    return null;
}

