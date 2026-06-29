# SEO Agent Skill: NobleMind Professional Search Optimization

---
name: seo_optimization
description: Specialized instructions for maximizing Google search rankings for NobleMind.
---

## 🎯 Objective
Ensure every page and blog post on NobleMind ranks #1 for target keywords by implementing deep, technical, and semantic SEO.

## 🛠️ Implementation Guidelines

### 1. Dynamic Metadata (Next.js 16)
- **Title Tags**: Must be 50-60 characters. Format: `Primary Keyword | Secondary Keyword - NobleMind AI`
- **Descriptions**: Must be 120-160 characters. Include a clear Call to Action (CTA).
- **Slug Management**: URL slugs must be lower-case, hyphenated, and keyword-rich (e.g., `/blog/ai-productivity-tips`).

### 2. Semantic HTML & Core Web Vitals
- Use exactly one `<h1>` per page.
- Maintain a strict heading hierarchy (`h1` -> `h2` -> `h3`).
- All images must have descriptive `alt` text including keywords.
- Optimize LCP (Largest Contentful Paint) by lazy-loading non-critical images and using Next.js `Image` component.

### 3. JSON-LD Structured Data
- Inject `Article` schema for all blog posts.
- Inject `SoftwareApplication` schema for the main app dashboard.
- Inject `BreadcrumbList` for nested navigation.

### 4. Indexing & Utility
- **Sitemap**: Automatically update `sitemap.ts` when new posts are published.
- **Robots.txt**: Maintain a healthy crawl budget.
- **Canonical Tags**: Prevent duplicate content issues.

### 5. Content Optimization (Admin Tips)
- Use a 1-2% keyword density.
- Include internal links to other NobleMind features/posts.
- Aim for a reading time of 3-7 minutes for blog posts.
