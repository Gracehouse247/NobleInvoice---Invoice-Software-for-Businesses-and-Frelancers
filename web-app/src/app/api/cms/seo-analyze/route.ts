import { NextRequest, NextResponse } from 'next/server';

const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
const GEMINI_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`;

export async function POST(req: NextRequest) {
  try {
    const { title, content, metaTitle, metaDescription, slug, focusKeyword, wordCount } = await req.json();

    if (!title && !content) {
      return NextResponse.json({ error: 'Title and content are required.' }, { status: 400 });
    }

    const prompt = `You are an expert SEO analyst. Analyze the following blog post and return a detailed JSON SEO report.

BLOG POST DATA:
- Title: "${title}"
- Slug: "${slug}"
- Meta Title: "${metaTitle || title}"
- Meta Description: "${metaDescription}"
- Focus Keyword: "${focusKeyword || 'none specified'}"
- Word Count: ${wordCount}
- Content (first 3000 chars): "${content?.substring(0, 3000)}"

Return ONLY a valid JSON object (no markdown, no code blocks) with this exact structure:
{
  "overallScore": <number 0-100>,
  "readabilityScore": <number 0-100>,
  "seoScore": <number 0-100>,
  "keywordDensity": <number percentage, e.g. 1.8>,
  "readingTime": <number in minutes>,
  "sentiment": "<positive|neutral|negative>",
  "toneConsistency": "<formal|conversational|mixed>",
  "issues": [
    { "type": "<error|warning|info>", "message": "<short issue description>", "fix": "<actionable fix>" }
  ],
  "strengths": ["<strength 1>", "<strength 2>"],
  "lsiKeywords": ["<semantically related keyword>"],
  "missingTopics": ["<topic not covered that competitors likely cover>"],
  "titleAnalysis": {
    "hasKeyword": <boolean>,
    "length": <number>,
    "powerWords": ["<power word if any>"],
    "suggestion": "<improved title suggestion>"
  },
  "metaAnalysis": {
    "hasKeyword": <boolean>,
    "length": <number>,
    "isCompelling": <boolean>,
    "suggestion": "<improved meta description>"
  },
  "contentStructure": {
    "hasH1": <boolean>,
    "hasH2": <boolean>,
    "hasImages": <boolean>,
    "hasInternalLinks": <boolean>,
    "hasBulletPoints": <boolean>,
    "paragraphCount": <number>
  },
  "snippetPreview": {
    "title": "<optimized title for snippet>",
    "url": "<slug>",
    "description": "<optimized meta for snippet>"
  }
}`;

    const geminiRes = await fetch(GEMINI_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }],
        generationConfig: { temperature: 0.3, maxOutputTokens: 2048 },
      }),
    });

    if (!geminiRes.ok) {
      const errText = await geminiRes.text();
      return NextResponse.json({ error: 'Gemini API error', details: errText }, { status: 502 });
    }

    const geminiData = await geminiRes.json();
    const rawText = geminiData.candidates?.[0]?.content?.parts?.[0]?.text || '';

    // Strip any markdown code fences if Gemini wraps in ```json
    const jsonMatch = rawText.match(/```json\s*([\s\S]*?)```/) || rawText.match(/```\s*([\s\S]*?)```/);
    const jsonStr = jsonMatch ? jsonMatch[1].trim() : rawText.trim();

    let analysis;
    try {
      analysis = JSON.parse(jsonStr);
    } catch {
      return NextResponse.json({ error: 'Failed to parse AI response', raw: rawText }, { status: 500 });
    }

    return NextResponse.json({ analysis });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Internal server error' }, { status: 500 });
  }
}
