'use client';

import { motion } from 'framer-motion';
import { CheckCircle } from 'lucide-react';

export function PaymentSuccessCard() {
  return (
    <motion.div
      initial={{ opacity: 0, scale: 0.8, y: 20 }}
      animate={{ opacity: 1, scale: 1, y: 0 }}
      transition={{ type: 'spring', stiffness: 300, damping: 22, delay: 0.3 }}
      className="mt-8 flex flex-col items-center gap-5 rounded-[32px] border border-emerald-200/60 bg-emerald-50/60 p-10 text-center backdrop-blur-xl"
    >
      <motion.div
        initial={{ scale: 0 }}
        animate={{ scale: 1 }}
        transition={{
          type: 'spring',
          stiffness: 400,
          damping: 15,
          delay: 0.6,
        }}
        className="flex h-20 w-20 items-center justify-center rounded-full bg-emerald-100"
      >
        <CheckCircle className="h-10 w-10 text-emerald-500" />
      </motion.div>
      <h2
        className="text-3xl font-black tracking-tighter text-emerald-800"
        style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}
      >
        Payment Successful!
      </h2>
      <p className="max-w-sm text-sm leading-relaxed text-emerald-600">
        Your payment has been received and confirmed. A receipt will be sent to
        your email shortly. Thank you!
      </p>
      <motion.div
        initial={{ width: 0 }}
        animate={{ width: '100%' }}
        transition={{ delay: 0.8, duration: 0.6, ease: 'easeOut' }}
        className="h-1 max-w-[200px] rounded-full bg-gradient-to-r from-emerald-300 to-emerald-500"
      />
    </motion.div>
  );
}
