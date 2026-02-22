# API Endpoints

**Base URL:** `/api/v1`  
**Auth:** Bearer JWT token in Authorization header

---

## Authentication

### POST /auth/register
Register new user
```json
{
  "email": "user@example.com",
  "password": "securePassword123",
  "name": "John Doe"
}
```

### POST /auth/login
Login and get JWT
```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
```
Response:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "refreshToken": "...",
  "user": { "id": "...", "email": "...", "subscriptionTier": "starter" }
}
```

### POST /auth/refresh
Refresh access token
```json
{ "refreshToken": "..." }
```

### POST /auth/logout
Invalidate tokens

---

## Apps

### GET /apps
List user's apps
```json
[
  {
    "id": "app-uuid",
    "name": "My App",
    "platform": "ios",
    "category": "Productivity",
    "iconUrl": "https://...",
    "keywordCount": 23,
    "competitorCount": 5
  }
]
```

### POST /apps
Add new app
```json
{
  "appStoreId": "1234567890",
  "platform": "ios"
}
```

### GET /apps/:id
Get app details + stats

### DELETE /apps/:id
Remove app and all associated data

---

## Keywords

### GET /apps/:appId/keywords
List keywords for app
Query params: `?tracking=true&country=us&page=1&limit=50`

```json
{
  "keywords": [
    {
      "id": "kw-uuid",
      "keyword": "todo app",
      "difficultyScore": 45,
      "trafficEstimate": "high",
      "currentRank": 12,
      "previousRank": 15,
      "rankChange": +3,
      "country": "us",
      "isTracking": true
    }
  ],
  "pagination": { "page": 1, "limit": 50, "total": 123 }
}
```

### POST /apps/:appId/keywords
Add keyword to track
```json
{
  "keyword": "todo app",
  "country": "us",
  "language": "en"
}
```

### DELETE /keywords/:id
Stop tracking keyword

### GET /keywords/:id/rankings
Get ranking history
Query: `?from=2026-01-01&to=2026-02-22`
```json
[
  { "rank": 12, "checkedAt": "2026-02-22T00:00:00Z" },
  { "rank": 15, "checkedAt": "2026-02-21T00:00:00Z" }
]
```

---

## Keyword Research

### GET /research/suggestions
Get keyword suggestions
Query: `?seed=todo&appId=xyz&country=us`
```json
[
  { "keyword": "todo list", "difficulty": 38, "traffic": "high" },
  { "keyword": "task manager", "difficulty": 52, "traffic": "medium" }
]
```

### POST /research/analyze
Analyze specific keywords
```json
{
  "keywords": ["todo app", "task manager"],
  "country": "us"
}
```
Response:
```json
[
  {
    "keyword": "todo app",
    "difficultyScore": 45,
    "trafficEstimate": "high",
    "competitionLevel": "medium",
    "topCompetitors": ["app1", "app2", "app3"]
  }
]
```

---

## Competitors

### GET /apps/:appId/competitors
List competitors

### POST /apps/:appId/competitors
Add competitor
```json
{ "appStoreId": "9876543210", "platform": "ios" }
```

### GET /apps/:appId/competitors/gaps
Keyword gap analysis (what competitors rank for that you don't)
```json
{
  "gaps": [
    { "keyword": "productivity app", "competitorRank": 5, "yourRank": null },
    { "keyword": "daily planner", "competitorRank": 3, "yourRank": 45 }
  ]
}
```

---

## Insights

### GET /insights
List AI-generated insights
Query: `?unread=true&limit=10`

```json
[
  {
    "id": "ins-uuid",
    "type": "ranking_drop",
    "title": "Ranking dropped for 'todo app'",
    "description": "Your ranking dropped from #8 to #15 for keyword 'todo app'",
    "severity": "warning",
    "isRead": false,
    "generatedAt": "2026-02-22T00:00:00Z"
  }
]
```

### POST /insights/:id/read
Mark insight as read

---

## Exports

### POST /exports
Request export
```json
{
  "appId": "app-uuid",
  "type": "keywords",
  "format": "csv"
}
```

### GET /exports/:id/status
Check export status

### GET /exports/:id/download
Download exported file (redirects to S3 presigned URL)

---

## User / Billing

### GET /user/me
Current user info + subscription

### GET /user/subscription
Subscription details, usage stats

### POST /user/subscription/upgrade
Initiate upgrade (Stripe checkout)

---

## Webhooks (Stripe)

### POST /webhooks/stripe
Stripe webhook endpoint for:
- `invoice.paid` — Extend subscription
- `subscription.deleted` — Downgrade to free
- `payment_failed` — Notify user

---

## Rate Limits

| Endpoint | Limit |
|----------|-------|
| Auth | 10 req/min |
| Keyword research | 30 req/min |
| All other | 100 req/min |

Headers: `X-RateLimit-Limit`, `X-RateLimit-Remaining`

---

*Generated autonomously.*
