# PRD: KeywordLens - ASO Keyword Research SaaS for Indie Developers

## Document Information
- **Version:** 1.0
- **Date:** February 21, 2026
- **Author:** AI Product Strategist
- **Status:** Draft for Review

---

## 1. Executive Summary

### 1.1 Product Vision
**KeywordLens** is a subscription-based SaaS platform designed specifically for indie app developers to perform comprehensive App Store Optimization (ASO) keyword research. By leveraging the Applyra.io API combined with proprietary data scraping and AI analysis, KeywordLens provides actionable insights that help indie developers compete against larger studios with bigger ASO budgets.

### 1.2 Target Market
- **Primary:** Solo indie developers and small app studios (1-5 people)
- **Secondary:** Freelance ASO consultants serving indie clients
- **Tertiary:** Small digital marketing agencies focused on mobile apps

### 1.3 Key Value Proposition
"Professional-grade ASO keyword research at indie-friendly prices. Turn data into rankings without the enterprise price tag."

---

## 2. Market Analysis

### 2.1 Market Size
- Global ASO Tools Market: ~$1.2B (2024), growing at 15% CAGR
- Indie developers segment: ~2.5M active iOS/Android indie developers worldwide
- Addressable market: $150M+ annually

### 2.2 Competitive Landscape

| Competitor | Price Range | Strengths | Weaknesses |
|------------|-------------|-----------|------------|
| **Sensor Tower** | $199-$999/mo | Enterprise data, accurate estimates | Too expensive for indies |
| **AppTweak** | $69-$599/mo | Great UI, comprehensive | Complex for beginners |
| **Mobile Action** | $49-$299/mo | Good data, affordable tiers | Limited indie-focused features |
| **Applyra** | $9.99/mo | Affordable, simple | Limited advanced features |
| **ASO Tools ( niche )** | $29-$99/mo | Various | Fragmented capabilities |

### 2.3 Market Gap
**The "Indie Gap":** Existing tools are either:
- Too expensive for indie budgets ($50+/month)
- Too complex for non-ASO experts
- Don't provide actionable "what to do next" guidance

---

## 3. Product Definition

### 3.1 Core Philosophy
**"Data → Insights → Actions"**
Every feature must translate raw data into clear, actionable recommendations that indie developers can implement immediately.

### 3.2 Feature Set Overview

#### TIER 1: ESSENTIAL (MVP)

##### 3.2.1 App Intelligence Dashboard
- **Purpose:** Centralized view of your app's ASO health
- **Data Sources:** Applyra API + App Store Scraper + Google Play Scraper
- **Features:**
  - Real-time keyword ranking tracker (up to 100 keywords/app)
  - Visibility score calculation (weighted ranking index)
  - Category ranking monitoring
  - Competitor positioning map
  - Historical trend charts (90 days)

##### 3.2.2 Keyword Research Engine
- **Purpose:** Discover high-opportunity keywords
- **Data Sources:** Applyra API + Search suggestion APIs + Competitor scraping
- **Features:**
  - Keyword difficulty score (0-100)
  - Traffic estimate (low/medium/high/very high)
  - Competition intensity analysis
  - Relevance scoring (AI-powered)
  - Long-tail keyword suggestions
  - Keyword gap analysis (vs competitors)

##### 3.2.3 Competitor Analysis
- **Purpose:** Understand competitor ASO strategies
- **Data Sources:** App Store Scraper + Google Play Scraper + Applyra
- **Features:**
  - Track up to 10 competitors per app
  - Competitor keyword overlap analysis
  - Metadata comparison (title, subtitle, description)
  - Ranking comparison charts
  - New keyword alerts (when competitors rank for new terms)

##### 3.2.4 AI-Powered ASO Recommendations
- **Purpose:** Turn data into actionable tasks
- **Technology:** LLM integration (Claude/GPT) + rule-based engine
- **Features:**
  - Priority-ranked optimization suggestions
  - Title/subtitle keyword insertion recommendations
  - Description optimization tips
  - Keyword cannibalization warnings
  - Seasonal trend alerts

#### TIER 2: PROFESSIONAL (Post-MVP)

##### 3.2.5 Review Intelligence
- **Purpose:** Mine user reviews for keyword opportunities
- **Data Sources:** App Store Reviews API + Google Play Reviews + Sentiment Analysis
- **Features:**
  - Keyword extraction from reviews
  - Sentiment analysis by feature
  - Feature request identification
  - Pain point discovery (for messaging)
  - Review response templates

##### 3.2.6 Localization Insights
- **Purpose:** Identify global expansion opportunities
- **Features:**
  - Country-specific keyword rankings
  - Localization gap analysis
  - Translation difficulty scoring
  - Market opportunity sizing by region

##### 3.2.7 A/B Testing Framework
- **Purpose:** Test ASO changes scientifically
- **Features:**
  - Metadata change tracking
  - Correlation analysis (changes → ranking impact)
  - A/B test design templates
  - Statistical significance calculator

#### TIER 3: ENTERPRISE (Future)

##### 3.2.8 API Access
- RESTful API for power users
- Webhook notifications for ranking changes
- Bulk data export

##### 3.2.9 Team Collaboration
- Multi-user workspaces
- Role-based permissions
- Client reporting (for agencies)

---

## 4. Technical Architecture

### 4.1 Data Sources & APIs

#### Primary: Applyra.io API
**Subscription:** Unlimited Plan ($9.99/month)
**Data Available:**
- Keyword ranking data (daily updates)
- Competitor tracking
- AI-powered ASO suggestions
- Historical ranking data
- CSV export capabilities

**API Endpoints Needed:**
```
GET /api/v1/apps/{app_id}/keywords
GET /api/v1/apps/{app_id}/rankings
GET /api/v1/apps/{app_id}/competitors
GET /api/v1/keywords/{keyword}/metrics
GET /api/v1/keywords/suggestions
GET /api/v1/insights/aso-audit
```

#### Secondary: App Store Scraper (Open Source)
**Library:** facundoolano/app-store-scraper
**Data Available:**
- App metadata (title, description, screenshots, version)
- Search results for any keyword
- Similar apps (competitor discovery)
- Reviews and ratings
- Developer information
- Category rankings

**Rate Limits:** Self-managed (needs proxy rotation)

#### Tertiary: Google Play Scraper (Open Source)
**Library:** facundoolano/google-play-scraper
**Data Available:**
- App details (installs, ratings, description)
- Search results
- Similar apps
- Reviews
- Category listings

### 4.2 Technology Stack

**Frontend:**
- Next.js 15 (React framework)
- Tailwind CSS (styling)
- Recharts (data visualization)
- React Query (data fetching)

**Backend:**
- Node.js / Express or Python / FastAPI
- PostgreSQL (primary database)
- Redis (caching + sessions)
- Bull Queue (background jobs)

**AI/ML:**
- OpenAI API or Anthropic Claude (recommendations)
- Custom keyword difficulty algorithm
- Sentiment analysis (Hugging Face transformers)

**Infrastructure:**
- Vercel (frontend hosting)
- Railway or Render (backend hosting)
- Upstash (Redis)
- Neon (PostgreSQL)

### 4.3 Data Pipeline

```
[App Store] ──┐
              ├──→ [Scraper Service] ──→ [Data Processor] ──→ [Database]
[Play Store] ─┘           │                    │
                          ↓                    ↓
[Applyra API] ─────────→ [Enrichment] ──→ [AI Analysis] ──→ [User Dashboard]
```

**Daily Sync Jobs:**
- Keyword ranking updates (every 6 hours)
- Competitor tracking (daily)
- Review scraping (every 12 hours)
- AI insight generation (daily)

---

## 5. Business Model

### 5.1 Pricing Tiers

#### FREE TIER (Freemium)
- **Price:** $0
- **Limits:**
  - 1 app
  - 10 keywords tracked
  - 3 competitors
  - 7 days history
  - Basic keyword suggestions
- **Purpose:** User acquisition, trial conversion

#### STARTER TIER
- **Price:** $19/month
- **Limits:**
  - 3 apps
  - 50 keywords per app
  - 5 competitors per app
  - 90 days history
  - AI recommendations (basic)
  - CSV export
- **Target:** Hobbyist developers, early-stage indies

#### PROFESSIONAL TIER (Recommended)
- **Price:** $49/month
- **Limits:**
  - 10 apps
  - 200 keywords per app
  - 10 competitors per app
  - Unlimited history
  - AI recommendations (advanced)
  - Review intelligence
  - Localization insights
  - Priority support
- **Target:** Serious indie developers, small studios

#### STUDIO TIER
- **Price:** $99/month
- **Limits:**
  - 25 apps
  - 500 keywords per app
  - 20 competitors per app
  - Everything in Pro
  - A/B testing framework
  - Team collaboration (5 seats)
  - API access
  - Custom reports
- **Target:** App studios, agencies

### 5.2 Cost Structure (Monthly)

#### Fixed Costs
| Item | Cost | Notes |
|------|------|-------|
| Applyra API | $10 | Unlimited plan |
| OpenAI API | ~$50 | Estimated at 1000 users |
| Vercel Pro | $20 | Hosting |
| Railway/Render | $50 | Backend hosting |
| Neon PostgreSQL | $20 | Database |
| Upstash Redis | $20 | Caching |
| Proxy Service | $30 | For scraping |
| **Total Fixed** | **~$200** | Base operational cost |

#### Variable Costs (Per Active User)
| Item | Cost |
|------|------|
| AI API calls | ~$0.50 |
| Scraping proxy | ~$0.30 |
| Storage | ~$0.10 |
| **Total per user** | **~$0.90** |

### 5.3 Unit Economics

**Break-even Analysis:**
- Fixed costs: $200/month
- Contribution margin: $19 - $0.90 = $18.10 (Starter)
- **Break-even:** 12 Starter subscribers

**Profit Targets:**
- 100 subscribers: $1,610 profit/month
- 500 subscribers: $9,250 profit/month
- 1000 subscribers: $19,100 profit/month

### 5.4 Revenue Projections (Year 1)

| Month | Subscribers | MRR | Cumulative |
|-------|-------------|-----|------------|
| 1 | 10 | $190 | $190 |
| 3 | 50 | $950 | $2,850 |
| 6 | 150 | $2,850 | $11,400 |
| 9 | 300 | $5,700 | $28,500 |
| 12 | 500 | $9,500 | $57,000 |

---

## 6. Go-to-Market Strategy

### 6.1 Launch Channels

1. **Product Hunt Launch**
   - Target: #1 Product of the Day
   - Preparation: 2 weeks pre-launch community building
   - Offer: 50% off lifetime for first 100 users

2. **Indie Hacker / Reddit**
   - r/iOSProgramming, r/androiddev, r/indiegames
   - Genuine value-add posts, not spam
   - Case studies showing ranking improvements

3. **Twitter/X Growth**
   - Build in public account
   - Daily ASO tips
   - User success stories
   - Free tools (keyword density checker, etc.)

4. **Content Marketing**
   - ASO guides for indie developers
   - YouTube tutorials
   - Newsletter with weekly ASO insights

### 6.2 Customer Acquisition Cost (CAC) Targets
- **Organic/Social:** $0 (time investment)
- **Product Hunt:** $5-10 per user
- **Paid Ads (future):** $30-50 per paying user

### 6.3 Retention Strategy
- Weekly ASO report emails
- Ranking change alerts (push notifications)
- Monthly "ASO health check" summaries
- Community Discord server
- Regular feature updates based on feedback

---

## 7. Product Roadmap

### Phase 1: MVP (Months 1-2)
- [ ] App Intelligence Dashboard
- [ ] Keyword Research Engine (basic)
- [ ] Competitor Analysis (5 competitors)
- [ ] Basic AI recommendations
- [ ] User authentication & billing
- [ ] Product Hunt launch

### Phase 2: Growth (Months 3-4)
- [ ] Review Intelligence feature
- [ ] Localization Insights
- [ ] Improved AI recommendations
- [ ] Chrome extension for quick checks
- [ ] Affiliate program

### Phase 3: Scale (Months 5-6)
- [ ] A/B Testing Framework
- [ ] API access for Studio tier
- [ ] Team collaboration features
- [ ] Mobile app (iOS/Android)
- [ ] Integration with App Store Connect

### Phase 4: Expansion (Months 7-12)
- [ ] Support for other platforms (Steam, etc.)
- [ ] AI-powered metadata generator
- [ ] Automated ASO optimization suggestions
- [ ] White-label option for agencies

---

## 8. Risk Analysis

### 8.1 Technical Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Apple/Google change scraping | Medium | High | Multiple data sources, Applyra API as backup |
| Rate limiting on scrapers | High | Medium | Proxy rotation, caching, respectful delays |
| AI API costs spike | Low | Medium | Usage limits, caching responses |
| Database scaling issues | Low | Medium | Proper indexing, read replicas |

### 8.2 Business Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Competitor price war | Medium | High | Differentiate on indie-focus, not just price |
| Applyra API changes | Low | High | Build abstraction layer, multiple sources |
| Low conversion rates | Medium | High | Freemium model, excellent onboarding |
| Churn | Medium | High | Regular value delivery, community building |

### 8.3 Legal/Compliance
- GDPR compliance for EU users
- App Store/Google Play ToS compliance (no automated actions)
- Clear data usage policies

---

## 9. Success Metrics

### 9.1 North Star Metric
**Monthly Recurring Revenue (MRR)** — Target: $10,000 by Month 12

### 9.2 Key Performance Indicators (KPIs)

| Metric | Target (Month 6) | Target (Month 12) |
|--------|------------------|-------------------|
| Monthly Active Users | 500 | 2,000 |
| Paying Customers | 100 | 500 |
| Free-to-Paid Conversion | 5% | 8% |
| Monthly Churn Rate | <10% | <5% |
| Customer Lifetime Value | $200 | $300 |
| Net Promoter Score | >40 | >50 |

### 9.3 Feature Engagement Metrics
- Keyword tracking usage (daily active)
- AI recommendations click-through rate
- Report generation frequency
- Time spent in dashboard

---

## 10. Appendix

### 10.1 Applyra.io API Data Points
Based on research, Applyra provides:

**App Data:**
- App metadata (title, description, icon, screenshots)
- Category and genre information
- Developer details
- Price and in-app purchase info
- Version history
- Content rating

**Keyword Data:**
- Keyword rankings (daily updates)
- Search volume estimates
- Difficulty scores
- Traffic estimates
- Historical trends

**Competitor Data:**
- Competitor app listings
- Keyword overlap analysis
- Ranking comparisons
- Market share estimates

**AI Insights:**
- ASO audit results
- Optimization suggestions
- Keyword opportunities
- Risk warnings

### 10.2 Competitor Keyword Research Tools

**Direct Competitors:**
1. **App Radar** — $39-$199/month
2. **The Tool (ASO)** — $69-$299/month
3. **Checkaso** — $49-$199/month
4. **ASOdesk** — $49-$299/month
5. **AppFollow** — $49-$499/month

**Adjacent Tools:**
- App Annie (data.ai) — Enterprise only
- AppFigures — $9.99-$199/month
- StoreMaven — Enterprise

### 10.3 Recommended Tech Stack Details

**Why Next.js?**
- SEO-friendly (critical for content marketing)
- Server-side rendering for fast dashboards
- API routes for backend integration
- Easy deployment to Vercel

**Why PostgreSQL?**
- JSON support for flexible app metadata
- Time-series data for ranking history
- Full-text search for keywords
- Cost-effective at scale

**Why Bull Queue?**
- Reliable background job processing
- Rate limiting for scrapers
- Job scheduling for daily updates
- Retry logic for failed jobs

### 10.4 Keyword Difficulty Algorithm (Draft)

```
Difficulty Score = (
  (Top 10 App Authority * 0.4) +
  (Keyword Competition * 0.3) +
  (Search Result Saturation * 0.2) +
  (Age of Top Rankings * 0.1)
)

Where:
- App Authority = (ratings * rating_score) + (installs_estimate / 1000)
- Keyword Competition = Number of apps targeting exact keyword
- Search Result Saturation = Number of results for keyword
- Age of Rankings = How long top apps have held positions
```

### 10.5 Glossary

- **ASO:** App Store Optimization
- **MRR:** Monthly Recurring Revenue
- **CAC:** Customer Acquisition Cost
- **LTV:** Lifetime Value
- **Keyword Cannibalization:** When multiple of your apps compete for same keyword
- **Long-tail Keywords:** Specific, multi-word search phrases
- **Metadata:** App title, subtitle, description, keywords field
- **Visibility Score:** Weighted index of all keyword rankings

---

## 11. Next Steps

### Immediate Actions (This Week)
1. [ ] Sign up for Applyra Unlimited plan ($9.99)
2. [ ] Set up development environment
3. [ ] Create initial database schema
4. [ ] Build proof-of-concept scraper

### Short Term (Next 2 Weeks)
1. [ ] Build MVP dashboard
2. [ ] Implement keyword tracking
3. [ ] Add basic competitor analysis
4. [ ] Set up user authentication

### Medium Term (Month 1)
1. [ ] Complete MVP feature set
2. [ ] Beta test with 10 users
3. [ ] Iterate based on feedback
4. [ ] Prepare Product Hunt launch

---

**Document End**

*This PRD is a living document. Update as market conditions change, new features are prioritized, or business strategy evolves.*
