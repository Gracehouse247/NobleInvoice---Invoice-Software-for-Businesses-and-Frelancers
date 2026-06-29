import { TemplateDefinition } from './templateRegistry';
import { PLATINUM_TEMPLATES } from './categories/platinumTemplates';
import { PROFESSIONAL_TEMPLATES } from './categories/professionalTemplates';
import { ESSENTIALS_TEMPLATES } from './categories/essentialsTemplates';
import { GEOMETRIC_TEMPLATES } from './categories/geometricTemplates';
import { CREATIVE_TEMPLATES } from './categories/creativeTemplates';

export const INVOICE_TEMPLATES: TemplateDefinition[] = [
  ...PLATINUM_TEMPLATES,
  ...PROFESSIONAL_TEMPLATES,
  ...ESSENTIALS_TEMPLATES,
  ...GEOMETRIC_TEMPLATES,
  ...CREATIVE_TEMPLATES
];
