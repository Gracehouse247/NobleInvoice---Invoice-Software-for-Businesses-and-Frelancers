# Modular Structure Skill: 600-Line Limit & Clean Architecture

---
name: modular_structure
description: Strict instructions for maintaining a modular, high-performance architecture with file size limits.
---

## 🏗️ Architectural Mandate
NobleMind is a high-performance, complex web application. To prevent technical debt and maintain speed, we enforce a **strict 600-line limit per file**.

## 🛠️ Implementation Rules

### 1. The 600-Line Rule
- No file should exceed 600 lines of code.
- If a component or service grows > 500 lines, **must** be refactored into smaller sub-components or utility functions.
- Run `node scripts/monitor_structure.js` before every commit/push.

### 2. Separation of Concerns
- **Components**: UI-only, logic-less where possible.
- **Hooks**: Encapuslate all React state and side effects (`usePosts`, `useHabits`).
- **Services/API**: Pure data-fetching logic (`src/lib/cmsApi.ts`).
- **Utils**: Pure helper functions.

### 3. Folder Structure
- Group related features in `src/components/features/[feature_name]/`.
- Use a single `index.ts` in feature folders to export clean public APIs.

### 4. Code Quality
- Use TypeScript interfaces/types for all data structures.
- Avoid deep nesting (max 3 levels of indentation).
- Use descriptive naming for functions and variables.
