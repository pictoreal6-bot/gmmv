# Godigamuwa Muslim Maha Vidyalaya — Results Portal

A Cloudflare Pages + D1 starter project for school examination records.

## Included
- Grades 1–13 and divisions A/B/C
- Class student and subject setup
- Separate subject-teacher links scoped to class, subject, academic year and term
- Auto-save marks (0–100) into Cloudflare D1
- Class results, totals, averages, rank ordering, CSV export and A4 print stylesheet
- A/B/C/S/W distribution charts using the Sri Lankan O/L-style boundaries configured in the UI
- Three-term report card printing and simple subject progress comparison
- Public read-only class results

## Important before real student data
This is a starter implementation, not a fully audited student information system. Test it with dummy records first. Student results are sensitive educational records. Obtain school approval for public disclosure, publish only permitted fields, restrict administrator access, back up D1, and arrange a process for revoking teacher links. Anyone holding an active teacher link can enter marks for its assigned subject/class/term. Do not send links in public groups.

The first release intentionally keeps teacher links bearer-token based and uses an administrator secret for administration. For a production school deployment, add named teacher accounts, expiring/revocable links UI, audit history, rate limiting, CSRF/origin protections, student privacy controls, and role-based examination-officer accounts before importing real records.

## 1. Create D1
In Cloudflare Dashboard → Workers & Pages → D1 SQL Database, create `godigamuwa-results`.
Copy its database ID into `wrangler.toml`, replacing `REPLACE_WITH_YOUR_D1_DATABASE_ID`.

Apply the schema:
```bash
npx wrangler d1 execute godigamuwa-results --remote --file=./migrations/0001_initial.sql
```

## 2. Set the administrator secret
Choose a long random secret. From this project folder run:
```bash
npx wrangler pages secret put ADMIN_KEY
```
Paste the secret when prompted. Never put this value in `app.js`, `index.html`, GitHub, or `wrangler.toml`.

## 3. GitHub / Cloudflare Pages
Push the project to GitHub. In Cloudflare → Workers & Pages → Create → Pages → Connect to Git, select the repository.
- Framework preset: None
- Build command: leave blank
- Build output directory: `/` (root)
- Root directory: `/`

The `functions/api/[[path]].js` file provides the API routes. Pages Functions require a Git-connected Pages deployment (not a dashboard Direct Upload).

Make sure the D1 binding is named exactly `DB` in Pages settings, or use the `wrangler.toml` binding and deploy with Wrangler. Redeploy after changing bindings/secrets.

## 4. Local development
```bash
npm install --save-dev wrangler
npx wrangler pages dev .
```
Set a local secret in `.dev.vars` (never commit it):
```
ADMIN_KEY=your-long-local-test-secret
```
Use the local D1 database for testing, or bind a local D1 instance as documented by Wrangler.

## 5. First use
1. Open the website and select academic year, grade and division.
2. Unlock Administration with your `ADMIN_KEY`.
3. Add the class students and subjects.
4. Create one teacher link per subject and term, then send that private URL to the relevant teacher.
5. Teachers open the URL and enter marks beside student names. Each change is saved to D1.
6. The results tab shows totals, averages and ranks for the selected term. Download CSV or print the A4 landscape schedule.
7. Open Analytics for grade distribution and individual term progression.
8. Use View beside a student to print the three-term report card.

## Calculation rules
- Total = sum of the marks actually entered for the selected term. Missing marks are excluded, not treated as zero.
- Average = total divided by the number of entered subject marks.
- Ranking = competition ranking based on total (1, 2, 2, 4). Students with no entered marks are unranked.
- Report card annual subject average = mean of the terms with a recorded mark.
- Report-card annual rank currently uses the selected term's class rank.
- Grade bands used by this starter: A 75–100, B 65–74, C 50–64, S 35–49, W 0–34. Confirm these thresholds against the exact examination policy your school wants to apply.

## Known next steps for a full school deployment
- Add edit/delete student and subject screens and import from CSV.
- Add publish/unpublish control so results are not visible until approved.
- Add named teacher accounts, link revocation/expiry UI and audit log (who changed what, when).
- Add examination-officer approval and class-teacher review workflows.
- Add full A4 report book pagination and Sinhala/Tamil font support if required.
- Add class/subject/term lock after final approval.
- Add accessible, privacy-compliant public result search instead of exposing full class lists.
