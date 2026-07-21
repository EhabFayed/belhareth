# Balharith Website — Design & Implementation Spec

Date: 2026-07-21
Sources:
- Claude Design export: `~/Downloads/PDF UIUX Design Brief/Balharith Website - Medical.dc.html` (source of truth for markup, styling, copy)
- Arabic site-structure brief: `uploads/site_structure.pdf` (sitemap + goals)
- Image assets: `~/Downloads/PDF UIUX Design Brief/uploads/`

## Goal

Official website for Dr. Mohammed Ali Balharith — consultant in hip & knee
reconstruction/replacement and trauma surgery (Riyadh). Purpose per the brief:
build trust, present expertise, convert visitors to booked appointments, and
rank per-condition pages on search engines.

## Approach (chosen)

Server-rendered Rails pages (no SPA). The design export is a client-side SPA;
we convert it to real routes because SEO per condition page is an explicit
goal in the brief. Content lives in plain Ruby data (no DB) — YAGNI: no admin,
no models until the client needs editable content.

Rejected alternatives:
- Serving the standalone HTML as-is (SPA, one URL, no SEO, unmaintainable blob)
- DB-backed content + admin (premature; copy is fixed in the design)

## Target app

Rails 8 API scaffold at `~/milaknight/belhareth ` (note trailing space in dir
name). Changes to make it serve HTML:
- `config.api_only = false` in `config/application.rb`
- `ApplicationController < ActionController::Base`
- No asset-pipeline gem needed: CSS/JS/images served from `public/` with plain
  tags (avoids Gemfile changes and Docker image rebuild).

## Routes & pages (8 screens from the design)

| Route | View | Notes |
|---|---|---|
| `/` (root) | pages#home | hero (rotating word), stats, trust strip, marquee, about strip, 4 specialty cards, why, 5-step journey, outcomes, articles teaser, CTA |
| `/about` | pages#about | profile, training timeline, philosophy, CTA |
| `/specialties` | conditions#index | overview cards linking to 4 condition pages |
| `/specialties/:id` | conditions#show | template page: overview, symptoms, conservative vs surgical, when-surgery, FAQ, CTA. ids: `knee`, `hip`, `trauma`, `complex` |
| `/articles` | pages#articles | educational content grid (placeholder articles + video thumbs) |
| `/stories` | pages#stories | featured story + 6 patient stories |
| `/faq` | pages#faq | 3 groups: clinic, surgery, recovery |
| `/contact` | pages#contact | booking form (non-wired placeholder POST), WhatsApp, phone, map embed (24.7136, 46.6753) |

## Content model

- `app/models/condition.rb` — plain Ruby (ActiveModel-free) class with the 4
  conditions' data copied verbatim from the design script (overview, symptoms,
  conservative, surgical, whenSurgery, faq).
- Stories, FAQ groups: constants in the same style (`app/models/` plain Ruby or
  helpers) with copy verbatim from the design.

## Porting rules (design → ERB)

- `{{ nav.x }}` onClick spans → real `<a href>` links (styled identically)
- `<sc-if>` screens → separate ERB views; shared nav/footer → layout + partials
- `<sc-for>` → Ruby `each`
- `<x-import image-slot>` → `<img>` with `object-fit:cover` and same dimensions
- `style-hover="…"` → CSS classes in `public/site.css`
- Behaviors ported to `public/site.js` (vanilla): splash (home only, hides
  after 2s), hero word rotation, animated stat counters, scroll-reveal
  (`.rv`/`.rv-kids`), nav shadow on scroll, FAQ `<details>` accordions
- SPA page-transition overlay is dropped (real navigations)
- Fonts: Google Fonts (Plus Jakarta Sans + Figtree) as in the design
- Images: `uploads/*` copied to `public/images/`; Unsplash placeholder URLs
  kept remote (they are design placeholders to be replaced by real photos)

## Palette / type (from design)

Ink `#16283A`, navy `#0F2436`, blue `#1273BF` (hover `#0C5A99`), light blue
`#6FB4E4`/`#8FC6EC`, bg `#F7FAFC`/`#FDFEFF`, tint `#E4F0F9`, WhatsApp green
`#25D366`, star gold `#F5B942`. Headings: Plus Jakarta Sans 800 uppercase;
body: Figtree.

## Content source (updated after receiving BalHarith Website.pdf)

The approved bilingual content doc (`BalHarith Website.pdf`, repo root)
supersedes the design export's placeholder copy. Applied from it:

- Real contact data: Al Hamra Hospital (Dr. Sulaiman Al Habib Medical Group),
  Riyadh · +966 58 377 7871 · dr.balhareth@hotmail.com · Sat 9–12, Sun/Tue/Wed 4–8 PM
- Stats: **7+ years of experience** (not 15+); Canadian fellowship credentials
- Updated copy for hero, about strip, why/journey sections, all 4 condition
  pages, FAQ answers, specialties intro
- **Hidden at client request** (red notes in the PDF): home OUTCOMES +
  PATIENT EDUCATION sections, /stories and /articles pages — until real
  testimonials/articles exist. Routes commented out in `config/routes.rb`.
- About page's "surgical focus" percentages section removed entirely.

## Assumptions (flagged for review)

1. **English-only for now** — the content doc includes Arabic for a later
   Arabic/RTL phase.
2. Booking form has no backend: SUBMIT composes a WhatsApp message to the
   clinic from the entered fields (see `bookingForms` in `public/site.js`).
3. Doctor photos are Unsplash placeholders (client note: awaiting real photo).
4. Name spelling standardized to **Balhareth** (content doc + email use it;
   the design export mixed "Balharith"/"Balhareth").
5. No commits — working tree left for user review per their workflow.

## Testing / verification

- `docker compose up` boots the app (ports may need an override if neuskin
  occupies 3000 — use `docker-compose.override.yml` if so)
- Request specs: each route returns 200 and key headline copy
- Headless Chrome screenshots of `/`, `/specialties/knee`, `/contact` compared
  against `screenshots/standalone-final.png`
