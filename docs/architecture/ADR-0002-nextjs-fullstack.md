# ADR-0002: Next.js Full-Stack vs Separate Frontend/Backend

## Status
✅ **ACCEPTED**

## Context
Architecture decision: Should we use Next.js full-stack (frontend + API routes) or separate frontend (Next.js/Vite) + backend (Express)?

## Decision
Use **Next.js full-stack** with API routes for MVP, split to separate backend if needed at scale.

## Rationale

### Why Next.js Full-Stack initially
1. **Faster development** — Single codebase, shared types
2. **Vercel deployment** — Zero-config hosting for frontend + API
3. **SSR for SEO** — ASO tool needs good SEO for marketing pages
4. **Built-in optimizations** — Image optimization, code splitting

### Backend Separation Criteria (future)
If we hit any of these, split to separate Node.js backend:
- API requests > 1000/minute sustained
- Background jobs need dedicated workers
- Multi-team development (frontend/backend teams)

### Why not separate from day 1
- Slower initial development
- More infrastructure complexity
- Not needed for indie dev MVP scope

## Architecture
```
├── app/                    # Next.js App Router
│   ├── api/               # API routes (backend)
│   ├── dashboard/         # Protected pages
│   └── landing/           # Marketing pages
├── lib/                   # Shared utilities
├── components/            # React components
└── prisma/               # Database schema + client
```

## API Route Structure
```
app/api/
├── auth/
│   ├── route.ts          # /api/auth/* handlers
├── apps/
│   ├── route.ts          # GET, POST /api/apps
│   └── [id]/
│       └── route.ts      # GET, DELETE /api/apps/:id
├── keywords/
│   └── route.ts
└── research/
    └── route.ts
```

## Consequences
- **Positive:** Faster MVP, simpler deployment
- **Negative:** API routes run on Vercel (serverless), long-running jobs need separate worker
- **Mitigation:** Use Bull + Redis for background jobs, separate if scale demands

## Related
- See `system-overview.md` for full architecture diagram
