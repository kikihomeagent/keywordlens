# Database Schema

**Database:** PostgreSQL (Neon)  
**ORM:** Prisma (recommended) or raw SQL

---

## Core Tables

### Users
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100),
    subscription_tier VARCHAR(20) DEFAULT 'free', -- free, starter, pro, studio
    stripe_customer_id VARCHAR(255),
    stripe_subscription_id VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Apps (tracked apps per user)
```sql
CREATE TABLE apps (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    app_store_id VARCHAR(50), -- Apple App Store ID
    play_store_id VARCHAR(100), -- Google Play bundle ID
    name VARCHAR(255) NOT NULL,
    platform VARCHAR(20) NOT NULL, -- ios, android, both
    category VARCHAR(100),
    current_version VARCHAR(50),
    icon_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Keywords
```sql
CREATE TABLE keywords (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    app_id UUID REFERENCES apps(id) ON DELETE CASCADE,
    keyword VARCHAR(255) NOT NULL,
    difficulty_score INTEGER CHECK (difficulty_score BETWEEN 0 AND 100),
    traffic_estimate VARCHAR(20), -- low, medium, high, very_high
    current_rank INTEGER,
    previous_rank INTEGER,
    rank_change INTEGER,
    country VARCHAR(2) DEFAULT 'us',
    language VARCHAR(5) DEFAULT 'en',
    is_tracking BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, app_id, keyword, country, language)
);
```

### Rankings (time-series data)
```sql
CREATE TABLE rankings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    keyword_id UUID REFERENCES keywords(id) ON DELETE CASCADE,
    rank INTEGER NOT NULL,
    search_volume INTEGER, -- estimated
    checked_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for time-series queries
CREATE INDEX idx_rankings_keyword_date ON rankings(keyword_id, checked_at DESC);
```

### Competitors
```sql
CREATE TABLE competitors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    app_id UUID REFERENCES apps(id) ON DELETE CASCADE, -- user's app
    competitor_app_id UUID REFERENCES apps(id) ON DELETE CASCADE,
    overlap_keywords INTEGER DEFAULT 0, -- cached count
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(app_id, competitor_app_id)
);
```

### Insights (AI-generated)
```sql
CREATE TABLE insights (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    app_id UUID REFERENCES apps(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL, -- keyword_opportunity, ranking_drop, optimization_tip
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    severity VARCHAR(20) DEFAULT 'info', -- info, warning, critical
    is_read BOOLEAN DEFAULT FALSE,
    generated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Exports
```sql
CREATE TABLE exports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    app_id UUID REFERENCES apps(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL, -- keywords, rankings, full_report
    format VARCHAR(20) NOT NULL, -- csv, pdf
    file_url TEXT,
    status VARCHAR(20) DEFAULT 'pending', -- pending, processing, ready, error
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE
);
```

### Audit Log
```sql
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL, -- keyword_added, ranking_updated, etc
    entity_type VARCHAR(50), -- keyword, app, etc
    entity_id UUID,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

---

## Key Relationships

```
users (1) ────< (N) apps
users (1) ────< (N) keywords
users (1) ────< (N) insights
users (1) ────< (N) exports

apps (1) ────< (N) keywords
apps (1) ────< (N) competitors

keywords (1) ────< (N) rankings
```

---

## Indexes for Performance

```sql
-- Fast lookups by user
CREATE INDEX idx_apps_user ON apps(user_id);
CREATE INDEX idx_keywords_user ON keywords(user_id);
CREATE INDEX idx_keywords_app ON keywords(app_id);

-- Active tracking queries
CREATE INDEX idx_keywords_tracking ON keywords(user_id, is_tracking) WHERE is_tracking = TRUE;

-- Recent insights
CREATE INDEX idx_insights_user_unread ON insights(user_id, is_read, generated_at DESC) WHERE is_read = FALSE;

-- Audit log queries
CREATE INDEX idx_audit_user ON audit_logs(user_id, created_at DESC);
```

---

## Data Retention

| Data Type | Retention | Policy |
|-----------|-----------|--------|
| Rankings | 1 year | Archive to S3 after 1 year |
| Audit logs | 6 months | Auto-delete after 6 months |
| Exports | 30 days | Auto-delete files after 30 days |
| Insights | Forever | Keep for historical analysis |

---

*Generated autonomously.*
