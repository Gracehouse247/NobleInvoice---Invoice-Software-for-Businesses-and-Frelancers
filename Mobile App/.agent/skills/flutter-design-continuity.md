---
name: flutter-design-continuity
description: Ensures consistent Flutter UI development by adhering to the NobleGo design system (Montserrat/Roboto fonts, specific color palette).
---

# NobleGo Flutter Design Continuity Skill

You are the Design System Guardian for the NobleGo project. Your role is to ensure that all new Flutter widgets and screens strictly adhere to the established design language defined in `lib/core/theme`.

## Core Design Tokens

### 🎨 Color Palette (`AppColors`)
- **Primary:** `0xFF1A73E8` (Logo Blue)
- **Primary Dark:** `0xFF0D47A1`
- **Secondary:** `0xFF00ACC1` (Cyan)
- **Accent:** `0xFFFFB74D` (Soft Orange)
- **Background:** `0xFFF7F9FC`
- **Success:** `0xFF34A853` | **Warning:** `0xFFFBBC05` | **Error:** `0xFFEA4335`

### Typography (`AppTextStyles`)
- **Headings (Montserrat):** Use for page titles and section headers.
  - `headlineLarge`: 32.0, Bold
  - `headlineMedium`: 24.0, Bold
  - `headlineSmall`: 18.0, w700
- **Body & Forms (Roboto):** Use for content, labels, and inputs.
  - `bodyLarge`: 16.0, Normal (Line height 1.5)
  - `bodyMedium`: 14.0, Normal (Grey)
  - `button`: 16.0, Bold, White, Letter Spacing 1.2
  - `textField`: 16.0, Normal

## Implementation Rules

1. **Never use hardcoded colors.** Always reference `AppColors.primary`, `AppColors.background`, etc.
2. **Never use hardcoded text styles.** Always use `AppTextStyles.bodyLarge` or the `Theme.of(context).textTheme` mappings.
3. **Widget Geometry:**
   - Buttons and input fields should have a `BorderRadius.circular(12)`.
   - Elevated buttons must have `AppColors.primary` background and `AppColors.white` foreground.
4. **Imports:** Always ensure you have the following imports when working on UI:
   ```dart
   import 'package:noblego_app/core/theme/app_colors.dart';
   import 'package:noblego_app/core/theme/app_text_styles.dart';
   ```

## Checklist for New Features
- [ ] Uses `Montserrat` for headings?
- [ ] Uses `Roboto` for body text?
- [ ] Uses `AppColors` constants?
- [ ] Border radius matches (12.0)?
- [ ] `ElevatedButton` padding follows the standard (vertical: 16, horizontal: 24)?
