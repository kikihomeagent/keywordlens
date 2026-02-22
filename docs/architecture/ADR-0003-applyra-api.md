# ADR-0003: Applyra API as Primary Data Source

## Status
✅ **ACCEPTED**

## Context
Where do we get keyword ranking data? Options:
- Applyra API (paid, $10/month unlimited)
- App Store Scraper (free, fragile, ToS risk)
- Sensor Tower API (expensive, enterprise)
- Build own scraper (time-intensive, maintenance burden)

## Decision
Use **Applyra API** as primary data source, supplement with open-source scrapers for edge cases.

## Rationale

### Why Applyra
1. **Affordable** — $10/month unlimited plan fits indie budget
2. **Reliable** — Commercial API with support, not fragile scraping
3. **Legal** — Official API, no App Store ToS concerns
4. **Fast** — Structured JSON, no parsing HTML

### Supplemental Scraping
Use `app-store-scraper` (open source) only for:
- Competitor discovery (similar apps)
- App metadata (screenshots, descriptions)
- Review sentiment analysis

Never use scraping for ranking data — too fragile.

## Data Flow
```
User requests keyword analysis
    ↓
Check cache (Redis, 1 hour TTL)
    ↓
Cache miss → Applyra API
    ↓
Store in PostgreSQL + Redis
    ↓
Return to user
```

## Rate Limiting Strategy
Applyra limits: ~100 requests/minute on unlimited plan

Our approach:
1. Aggressive caching (Redis, 6-hour TTL for rankings)
2. Batch requests where possible
3. Queue jobs (Bull) to respect rate limits
4. Graceful degradation — show cached data if API down

## Fallback Strategy
If Applyra becomes unavailable:
1. Serve cached data with "stale" warning
2. Queue refresh jobs for retry
3. Emergency: disable real-time features, keep historical

## Cost Analysis
| Source | Monthly Cost | Reliability |
|--------|--------------|-------------|
| Applyra | $10 | High |
| Sensor Tower | $299+ | High |
| Self-scrape | $0 (labor) | Low |

**Winner:** Applyra for MVP, re-evaluate at 1000+ paying users.

## Consequences
- **Dependency risk** — If Applyra shuts down, we need migration plan
- **Positive:** Fast development, reliable data
- **Mitigation:** Abstract data layer, could swap to Sensor Tower if we grow

## Related
- See PRD Section 4.1 for full data source breakdown
