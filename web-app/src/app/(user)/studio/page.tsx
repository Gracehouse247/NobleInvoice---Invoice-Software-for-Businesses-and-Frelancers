'use client';

import { NobleCardStudio } from '../../../components/identity/studio/NobleCardStudio';
import { useFeatureGate, useAuth } from '@/context/AuthContext';
import { useRouter } from 'next/navigation';
import { useEffect } from 'react';
import { toast } from 'react-hot-toast';

export default function BusinessCardPage() {
  const { hasFeature } = useFeatureGate();
  const { loading } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (!loading && !hasFeature('brand_identity_studio')) {
      toast.error('Brand Studio access requires an active Noble Pulse or Elite subscription.', { icon: '🚀' });
      router.push('/pricing');
    }
  }, [hasFeature, loading, router]);

  if (loading || !hasFeature('brand_identity_studio')) {
    return null;
  }

  return (
    <main className="w-full h-screen overflow-hidden bg-slate-50">
      <NobleCardStudio />
    </main>
  );
}
