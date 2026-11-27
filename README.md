# DailyAura Product Manager (Prototype)

A responsive React/Vite starter for the DailyAura product-management companion app.

## Run locally
1. Install Node.js (LTS).
2. Open a terminal in this project folder.
3. Run `npm install`.
4. Run `npm run dev`.
5. Open the localhost URL Vite prints.

## Current prototype functionality
- Category landing page and quick add with category preselected
- Dashboard metrics and shortcuts
- Products navigation: category icons -> subcategory icons -> compact product list
- Search product name, brand, or product ID
- Product details, add/edit/delete, status editing
- Variants/sizes
- Cost price, profit and margin fields
- Category/subcategory management
- Pricing manager
- Image coverage manager (image URL field currently)
- CSV export/import
- Settings screens and local demo connection status
- Local browser persistence using localStorage

## Important limitations
This is a frontend prototype. It does not yet connect to the DailyAura website, Google Sheets, a secure backend, cloud image storage, authentication, or live publishing/sync. Cost price is local prototype data and is excluded from CSV export, but localStorage is **not** secure storage. Do not use it for confidential real business cost data until a private backend and authentication are implemented. Publishing status is a demo label, not confirmation that a product is live on the website.

## Next phase
Connect the app to an authenticated backend. Public product fields can then be synced to the website; cost price and profit data must be kept in a separate private datastore and excluded from all public product feeds.

## Phase 1 improvements (working copy)
- Manager CSV export now includes cost price and variant data (JSON serialized in the `variants` CSV column).
- CSV import supports quoted cells, embedded commas/newlines, variants, cost fields, and skips duplicate product IDs.
- Product save validates required name/ID, duplicate IDs, non-negative prices, variant names, and MRP/selling price relationships.
- Added full JSON backup download and restore for products and categories.
- Updated privacy wording to clarify that manager exports contain private cost fields and must not be published to the public storefront.

Note: this phase remains a browser-local prototype; online sync and cloud persistence still require backend work.


## GitHub Pages deployment
The project is deployed using the GitHub Actions workflow in `.github/workflows/deploy.yml`. In repository Settings → Pages, the publishing source must be set to **GitHub Actions**.
