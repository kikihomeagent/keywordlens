# ADR-0001: PostgreSQL + Neon vs MongoDB

## Status
✅ **ACCEPTED**

## Context
We need a database for KeywordLens. Options considered:
- PostgreSQL (Neon serverless)
- MongoDB Atlas
- SQLite (ruled out — not suitable for SaaS)
- Firebase Firestore

## Decision
Use **PostgreSQL via Neon** (serverless PostgreSQL).

## Rationale

### Why PostgreSQL
1. **Relational data fits** — Apps, keywords, rankings have clear relationships
2. **Time-series support** — Ranking history with proper indexing
3. **JSONB flexibility** — Can store audit metadata without schema migrations
4. **Mature ecosystem** — Prisma, migrations, tooling

### Why Neon specifically
1. **Serverless scaling** — Pay for what you use, scales to zero
2. **Branching** — Can create db branches per PR (dev/staging)
3. **Low cost at start** — Free tier sufficient for MVP
4. **Postgres compatibility** — Standard SQL, no vendor lock-in

### Why not MongoDB
- Time-series queries (ranking history) would be less efficient
- No strong schema enforcement could lead to data inconsistency
- Less mature tooling for the Node.js ecosystem we chose

## Consequences
- Must design schema upfront (migrations required)
- Connection pooling needed (Neon provides this)
- Slightly more complex local dev setup (Docker or Neon branch)

## Related
- See `database-schema.md` for full schema design
