import { INVOICE_TEMPLATES } from './invoiceTemplates';
import { IDENTITY_TEMPLATES } from './businessCardTemplates';

export type TemplateCategory = 'recommended' | 'essentials' | 'professional' | 'creative' | 'geometric' | 'platinum' | 'minimal' | 'executive' | 'dynamic';
export type TemplateType = 'invoice' | 'identity';

export interface TemplateDefinition {
  id: string;
  name: string;
  type: TemplateType;
  category: TemplateCategory[];
  accentColor: string;
  headerStyle: 'stripe' | 'wave' | 'diagonal' | 'block' | 'minimal' | 'photo' | 'dark' | 'geometric' | 'bloom' | 'image' | 'glass';
  footerStyle: 'stripe' | 'wave' | 'diagonal' | 'block' | 'minimal' | 'none' | 'dark' | 'geometric';
  tableStyle?: 'bordered' | 'striped' | 'clean' | 'dark-header';
  logoPosition: 'top-left' | 'top-right' | 'center' | 'none';
  orientation?: 'horizontal' | 'vertical';
  theme?: 'light' | 'dark' | 'glass';
  isPremium: boolean;
  thumbnail: string;
}

// Separate high-performing registries
export { INVOICE_TEMPLATES } from './invoiceTemplates';
export { IDENTITY_TEMPLATES } from './businessCardTemplates';

// Global registry for backwards-compatibility
export const TEMPLATES: TemplateDefinition[] = [...INVOICE_TEMPLATES, ...IDENTITY_TEMPLATES];

// Strictly separated category configurations
export const INVOICE_TEMPLATE_CATEGORIES = [
  { id: 'recommended',  label: 'Recommended',  emoji: '⭐' },
  { id: 'essentials',    label: 'Essentials',    emoji: '⚡' },
  { id: 'professional',  label: 'Professional',  emoji: '💼' },
  { id: 'creative',      label: 'Creative',      emoji: '🎨' },
  { id: 'geometric',     label: 'Geometric',     emoji: '📐' },
  { id: 'platinum',      label: 'Platinum',      emoji: '💎' },
] as const;

export const IDENTITY_TEMPLATE_CATEGORIES = [
  { id: 'executive',     label: 'Executive',     emoji: '💼' },
  { id: 'dynamic',       label: 'Dynamic',       emoji: '⚡' },
  { id: 'creative',      label: 'Creative',      emoji: '🎨' },
] as const;

// Backward-compatible category array mapping
export const TEMPLATE_CATEGORIES = [
  ...IDENTITY_TEMPLATE_CATEGORIES,
  ...INVOICE_TEMPLATE_CATEGORIES.filter(c => c.id !== 'creative') // prevent duplicates for the same ID
] as const;

export function getTemplatesByCategory(category: TemplateCategory) {
  return TEMPLATES.filter(t => t.category.includes(category));
}

export function getTemplatesByType(type: TemplateType) {
  return TEMPLATES.filter(t => t.type === type);
}
