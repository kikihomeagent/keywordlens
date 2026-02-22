# KeywordLens System Architecture

**Date:** 2026-02-22  
**Status:** Draft  
**Author:** main (autonomous execution due to agent spawn blocked)

---

## 1. High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           CLIENT LAYER                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                  │
│  │   Web App    │  │  Chrome Ext  │  │   Mobile     │                  │
│  │  (Next.js)   │  │   (future)   │  │  (future)    │                  │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘                  │
└─────────┼─────────────────┼─────────────────┼──────────────────────────┘
          │                 │                 │
          └─────────────────┼─────────────────┘
                            │ HTTPS / JSON
┌───────────────────────────┼─────────────────────────────────────────────┐
│                           ▼                                             │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                         API GATEWAY                               │  │
│  │                    (Rate limiting, Auth, SSL)                     │  │
│  └───────────────────────────┬──────────────────────────────────────┘  │
│                              │                                          │
│  ┌───────────────────────────▼──────────────────────────────────────┐  │
│  │                      APPLICATION LAYER                            │  │
│  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐             │  │
│  │  │  Auth API    │ │ Keyword API  │ │  App Data    │             │  │
│  │  │  (JWT)       │ │  (core)      │ │   API        │             │  │
│  │  └──────────────┘ └──────────────┘ └──────────────┘             │  │
│  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐             │  │
│  │  │  Billing     │ │  Export      │ │  Webhooks    │             │  │
│  │  │  (Stripe)    │ │  (CSV/PDF)   │ │              │             │  │
│  │  └──────────────┘ └──────────────┘ └──────────────┘             │  │
│  └───────────────────────────┬──────────────────────────────────────┘  │
│                              │                                          │
│  ┌───────────────────────────▼──────────────────────────────────────┐  │
│  │                      SERVICE LAYER                                │  │
│  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐             │  │
│  │  │ Applyra      │ │ App Store    │ │   AI Recs    │             │  │
│  │  │ Sync         │ │ Scraper      │ │  (OpenAI)    │             │  │
│  │  │ (daily)      │ │ (on-demand)  │ │              │             │  │
│  │  └──────────────┘ └──────────────┘ └──────────────┘             │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                         │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                      DATA LAYER                                   │  │
│  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐             │  │
│  │  │ PostgreSQL   │ │    Redis     │ │  Object      │             │  │
│  │  │  (Neon)      │ │  (Upstash)   │ │  Storage     │             │  │
│  │  │  Primary DB  │ │  Cache/Jobs  │ │  (Screens)   │             │  │
│  │  └──────────────┘ └──────────────┘ └──────────────┘             │  │
│  └──────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Component Breakdown

### Frontend (Next.js 15 + Tailwind)
| Component | Tech | Purpose |
|-----------|------|---------|
| Dashboard | React + Recharts | Main UI with charts, stats |
| Kanban Board | React DnD | Task management (reuse from TaskMaster) |
| Calendar | Custom + date-fns | Ranking timeline view |
| Auth Pages | NextAuth.js | Login, signup, billing portal |

### Backend (Node.js + Express)
| Service | Responsibility |
|---------|----------------|
| Auth Service | JWT tokens, Stripe webhooks, user management |
| Keyword Service | CRUD for keywords, ranking tracking, competitor analysis |
| App Data Service | App metadata, screenshots, version tracking |
| Export Service | CSV/PDF generation, data exports |
| Webhook Service | Stripe events, external integrations |

### Background Jobs (Bull Queue + Redis)
| Job | Frequency | Description |
|-----|-----------|-------------|
| `sync-rankings` | Every 6 hours | Fetch ranking updates from Applyra |
| `scrape-competitors` | Daily | Update competitor app data |
| `generate-insights` | Daily | AI recommendations for each user |
| `cleanup-old-data` | Weekly | Archive old data, free storage |

---

## 3. Data Flow

### Keyword Research Flow
```
User searches keyword
    ↓
API checks cache (Redis)
    ↓
Miss → Query Applyra API
    ↓
Enrich with difficulty score (custom algorithm)
    ↓
Store in PostgreSQL + cache in Redis
    ↓
Return to user
```

### Ranking Tracking Flow
```
Scheduled job (Bull)
    ↓
Fetch rankings from Applyra
    ↓
Compare with previous data
    ↓
Detect changes → Queue notifications
    ↓
Update PostgreSQL
    ↓
Invalidate Redis cache
```

---

## 4. Security Considerations

- **Auth:** JWT with refresh tokens, httpOnly cookies
- **API Keys:** Encrypted at rest (AES-256), never logged
- **Rate Limiting:** Per-user and per-IP (Redis-based)
- **Data:** Row-level security in PostgreSQL (multi-tenant)
- **CORS:** Strict whitelist for frontend domains

---

## 5. Deployment Architecture

```
┌─────────────────────────────────────────┐
│              Vercel Edge               │
│         (Next.js Frontend)             │
└─────────────┬───────────────────────────┘
              │
┌─────────────▼───────────────────────────┐
│           Railway/Render               │
│      (API + Background Workers)        │
└─────────────┬───────────────────────────┘
              │
┌─────────────▼──────────┐ ┌─────────────┐
│      Neon PostgreSQL   │ │ Upstash     │
│    (Primary Database)  │ │ (Redis)     │
└────────────────────────┘ └─────────────┘
```

---

*Generated autonomously due to agent spawn limitations.*
