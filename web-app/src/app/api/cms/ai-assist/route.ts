import { NextRequest, NextResponse } from 'next/server';

const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
const GEMINI_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`;

type AssistMode =
  | 'improve'
  | 'expand'
  | 'summarize'
  | 'rephrase'
  | 'simplify'
  | 'formal'
  | 'casual'
  | 'conclusion'
  | 'intro'
  | 'faq'
  | 'outline'
  | 'repurpose_twitter'
  | 'repurpose_linkedin'
  | 'repurpose_newsletter';

const SYSTEM_PROMPTS: Record<AssistMode, string> = {
  improve: 'Improve the clarity, flow, and engagement of the following content. Keep the same length and meaning but make it more compelling. Return only the improved text.',
  expand: 'Expand the following content with more detail, examples, and depth. Roughly double the length. Return only the expanded text.',
  summarize: 'Summarize the following content into 3-5 concise bullet points. Return only the bullet points.',
  rephrase: 'Rephrase the following content in a fresh way while keeping the same meaning. Return only the rephrased text.',
  simplify: 'Simplify the following content to a Grade 8 reading level. Use short sentences and plain language. Return only the simplified text.',
  formal: 'Rewrite the following content in a formal, professional business tone. Return only the rewritten text.',
  casual: 'Rewrite the following content in a warm, friendly, conversational tone. Return only the rewritten text.',
  conclusion: 'Write a compelling conclusion paragraph for the following article. Return only the conclusion paragraph.',
  intro: 'Write an attention-grabbing introduction paragraph for the following article. Use a hook and clearly state what the reader will learn. Return only the introduction.',
  faq: 'Generate 5 frequently asked questions (with detailed answers) based on the following content. Format as Q: ... A: ... Return only the FAQ pairs.',
  outline: 'Create a detailed article outline with H2 and H3 sections based on the following topic/content. Return only the outline in markdown.',
  repurpose_twitter: 'Transform the following blog post into a compelling Twitter/X thread (10-15 tweets). Number each tweet. Keep each tweet under 280 characters. Start with a strong hook tweet. End with a CTA. Return only the thread.',
  repurpose_linkedin: 'Transform the following blog post into a professional LinkedIn post (400-600 words). Use line breaks for readability, include 3-5 relevant hashtags at the end. Return only the post.',
  repurpose_newsletter: 'Transform the following blog post into a friendly email newsletter (300-400 words). Include a subject line at the top, a personal greeting, the key insights, and a CTA. Return only the newsletter.',
};

export async function POST(req: NextRequest) {
  try {
    const { mode, content, title }: { mode: AssistMode; content: string; title?: string } = await req.json();

    if (!mode || !content) {
      return NextResponse.json({ error: 'mode and content are required.' }, { status: 400 });
    }

    const systemPrompt = SYSTEM_PROMPTS[mode];
    if (!systemPrompt) {
      return NextResponse.json({ error: `Unknown mode: ${mode}` }, { status: 400 });
    }

    const contextualContent = title ? `Article Title: "${title}"\n\nContent:\n${content}` : content;

    const geminiRes = await fetch(GEMINI_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [
          {
            parts: [
              { text: `${systemPrompt}\n\n---\n\n${contextualContent}` },
            ],
          },
        ],
        generationConfig: {
          temperature: mode.startsWith('repurpose') ? 0.8 : 0.5,
          maxOutputTokens: 2048,
        },
      }),
    });

    if (!geminiRes.ok) {
      const errText = await geminiRes.text();
      return NextResponse.json({ error: 'Gemini API error', details: errText }, { status: 502 });
    }

    const geminiData = await geminiRes.json();
    const result = geminiData.candidates?.[0]?.content?.parts?.[0]?.text || '';

    return NextResponse.json({ result });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Internal server error' }, { status: 500 });
  }
}
