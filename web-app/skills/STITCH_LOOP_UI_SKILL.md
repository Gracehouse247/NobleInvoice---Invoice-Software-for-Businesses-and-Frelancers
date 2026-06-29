# Google Stitch Loop Skill: Premium UI/UX Design System

---
name: stitch_loop_ui
description: Instructions for maintaining a premium, "Stitch Loop" aesthetic across the NobleMind web app.
---

## 🎨 Design Philosophy
"Stitch Loop" is a design system characterized by seamless transitions, glassmorphism, and high-quality micro-animations that feel "alive" and premium.

## 🛠️ Visual Standards

### 1. The Glassmorphism Core
- **Backgrounds**: Use `backdrop-blur-xl` with semi-transparent borders (`border-white/10`).
- **Gradients**: Use smooth HSL-based gradients, avoiding pure black/white.
- **Shadows**: Use colored shadows that match the component's accent (e.g., `shadow-indigo-500/20`).

### 2. Typography & Hierarchy
- **Font**: Use `Outfit` for headers and `Inter` for body text.
- **Letter Spacing**: Use `tracking-tight` for large headers and `tracking-widest` for small labels.
- **Contrast**: Maintain a clear accessible contrast between slate-400 (secondary) and slate-200 (primary) text.

### 3. Motion & Interaction (Framer Motion)
- **Hover States**: Every interactive element must scale slightly (`scale: 1.02`) or glow.
- **Page Transitions**: Use smooth entrance animations (`opacity: 0, y: 10` -> `opacity: 1, y: 0`).
- **Micro-interactions**: Use subtle spring animations for buttons and cards.

### 4. Visual Excellence Checklist
- [ ] No sharp corners (use `rounded-2xl` or `rounded-3xl`).
- [ ] No generic colors (use indigo, violet, emerald, and amber with HSL nuances).
- [ ] High-quality icons (Lucide-React with consistent stroke weights).
- [ ] Subtle noise texture on dark backgrounds to reduce banding.
