/**
 * Lightweight sliding-window in-memory rate limiter.
 * No external dependencies required — uses a simple Map keyed by identifier.
 * 
 * For production at high scale, replace with Upstash Redis:
 * https://github.com/upstash/ratelimit
 */

interface RateLimitEntry {
  timestamps: number[];
}

const store = new Map<string, RateLimitEntry>();

// Periodically clean up old entries to prevent memory bloat
setInterval(() => {
  const now = Date.now();
  for (const [key, entry] of store.entries()) {
    // Remove entries where all timestamps are older than 5 minutes
    if (entry.timestamps.every(t => now - t > 5 * 60 * 1000)) {
      store.delete(key);
    }
  }
}, 60 * 1000);

/**
 * Check if a request is within rate limit.
 * @param identifier - Unique key (e.g. IP address, user ID)
 * @param limit - Maximum number of requests allowed
 * @param windowMs - Time window in milliseconds
 * @returns { allowed: boolean, remaining: number, resetMs: number }
 */
export function rateLimit(
  identifier: string,
  limit: number,
  windowMs: number
): { allowed: boolean; remaining: number; resetMs: number } {
  const now = Date.now();
  const windowStart = now - windowMs;

  const entry = store.get(identifier) ?? { timestamps: [] };

  // Remove timestamps outside the current window
  entry.timestamps = entry.timestamps.filter(t => t > windowStart);

  const remaining = Math.max(0, limit - entry.timestamps.length);
  const resetMs = entry.timestamps.length > 0
    ? Math.max(0, windowMs - (now - entry.timestamps[0]))
    : 0;

  if (entry.timestamps.length >= limit) {
    store.set(identifier, entry);
    return { allowed: false, remaining: 0, resetMs };
  }

  entry.timestamps.push(now);
  store.set(identifier, entry);

  return { allowed: true, remaining: remaining - 1, resetMs };
}

/**
 * Get the real client IP from a Next.js request, handling proxies.
 */
export function getClientIp(request: Request): string {
  const forwarded = request.headers.get('x-forwarded-for');
  if (forwarded) {
    return forwarded.split(',')[0].trim();
  }
  return request.headers.get('x-real-ip') ?? 'unknown';
}

/**
 * Build a standard 429 rate limit response.
 */
export function rateLimitResponse(resetMs: number): Response {
  return new Response(
    JSON.stringify({ error: 'Too many requests. Please slow down.' }),
    {
      status: 429,
      headers: {
        'Content-Type': 'application/json',
        'Retry-After': String(Math.ceil(resetMs / 1000)),
        'X-RateLimit-Limit': '0',
      },
    }
  );
}
