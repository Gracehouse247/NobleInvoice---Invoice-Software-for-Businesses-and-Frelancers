# Progress Tracker & Best Practices Skill

---
name: progress_best_practices
description: Instructions for tracking progress without context loss and following industry-leading tech stack practices.
---

## 🛤️ Progress Tracking
- **State Preservation**: Always check `task.md` and `implementation_plan.md` before starting a new task.
- **Update Frequency**: Update `TaskStatus` and `TaskSummary` in task boundaries every 5 tool calls or at major milestones.
- **Verification**: Never mark a task as complete [x] until successful build or manual verification is confirmed.

## 🚀 Tech Stack: Next.js 16 & React 19
- **Server Components**: Default to RSC (React Server Components) for all pages.
- **Client Components**: Use `'use client'` only when interactivity or browser APIs are needed.
- **Turbopack**: Ensure compatibility by avoiding legacy webpack plugins.
- **Caching**: Use Next.js `fetch` with `revalidate` for dynamic content.

## 🛡️ Performance & Reliability
- **Lighthouse**: Target 90+ across Performance, Accessibility, Best Practices, and SEO.
- **Error Boundaries**: Wrap major feature blocks in React Error Boundaries.
- **Type Safety**: No `any` types allowed. Use Zod for schema validation if necessary.
