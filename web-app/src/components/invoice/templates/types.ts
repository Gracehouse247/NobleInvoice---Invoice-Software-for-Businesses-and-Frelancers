import React from 'react';
import { Mail, Phone, Globe, MapPin, User, Calendar, FileText, Diamond, Building2, CheckCircle2, Star, ShieldCheck, Signature } from 'lucide-react';

export interface SharedEngineProps {
  id: string;
  data: any;
  brand: any;
  containerRounding: string;
  isSerif?: boolean;
  fontClass?: string;
  renderLogo?: (size?: string, light?: boolean) => React.ReactNode;
}
