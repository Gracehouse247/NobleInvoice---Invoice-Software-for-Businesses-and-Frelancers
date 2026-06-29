'use client';

import React, { useEffect, useState } from 'react';
import { supabase } from '@/lib/supabase';
import { motion } from 'framer-motion';

// This is a proxy wrapper that renders the actual BusinessCardStudio from the web app
// Note: You would import the actual BusinessCardStudio component here
// import BusinessCardStudio from '@/components/networking/BusinessCardStudio';

export default function EmbedBusinessCardStudio() {
  const [loading, setLoading] = useState(true);
  const [profile, setProfile] = useState<any>(null);

  useEffect(() => {
    const initEmbed = async () => {
      // Get the active session (should be injected or shared via SSO)
      const { data: { session } } = await supabase.auth.getSession();
      
      if (session?.user) {
        const { data } = await supabase
          .from('profiles')
          .select('*')
          .eq('id', session.user.id)
          .single();
        
        setProfile(data);
      }
      setLoading(false);
    };

    initEmbed();
  }, []);

  if (loading) return <div className="min-h-screen flex items-center justify-center bg-white"><div className="w-8 h-8 border-4 border-slate-200 border-t-blue-600 rounded-full animate-spin"></div></div>;

  return (
    <div className="w-full h-screen bg-slate-50 overflow-hidden flex flex-col">
      {/* 
        Here we render the identical BusinessCardStudio component used in the Web App,
        but since it is inside the /embed/layout.tsx, it has NO sidebars or Web Navigation.
        It occupies 100% of the screen, feeling exactly like a native Flutter page.
      */}
      <div className="flex-1 w-full h-full overflow-y-auto">
        <div className="p-4">
           {/* Replace with actual component: <BusinessCardStudio profile={profile} /> */}
           <div className="bg-white rounded-3xl p-6 shadow-xl border border-slate-100 flex flex-col items-center justify-center min-h-[400px]">
             <h2 className="text-xl font-black text-slate-900 mb-2">Native Engine Loaded</h2>
             <p className="text-slate-500 text-sm text-center">
               This is the Web App engine running seamlessly inside the native wrapper.
               <br/>User: {profile?.display_name || 'Authenticated User'}
             </p>
           </div>
        </div>
      </div>
    </div>
  );
}
