# Best Practices Agent Skill

## Purpose
Ensure the NobleMind Web App adheres to industry-leading standards for Next.js 16, React 19, and Node.js.

## Core Directives
1. **Server Components**: Prefer Server Components for data fetching to reduce bundle size.
2. **Error Boundaries**: Use React Error Boundaries to prevent full app crashes.
3. **Optimized Caching**: Utilize `use cache` (Next.js 16) and `revalidateTag` for efficient data persistence.
4. **Security**: Sanitize all user inputs (especially for CMS). Always use HTTPS.
5. **Type Safety**: Mandatory TypeScript with strict types (avoid `any`).
6. **Efficiency**: Use Turbopack for local development and optimized production builds.

## Code Standards
- [ ] Type-safe API calls
- [ ] Optimized image & font loading
- [ ] Proper use of Client vs Server components
- [ ] Clean, documented functions
