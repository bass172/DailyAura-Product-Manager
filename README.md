# DailyAura Product Manager

A lightweight, responsive product management dashboard for the DailyAura catalogue.

## Current features
- Dashboard counts and quick overview
- Create, edit and delete products
- Product name, brand, category and subcategory
- Image URL field
- MRP, selling price and cost price
- Size/variant list
- Search and category filtering
- CSV import/export
- Local browser storage

## Run
Open `index.html` in a modern browser. Product data is stored locally in that browser/device.

## Important MVP limitation
This initial version is local-only. Products do not yet sync across devices or power the public DailyAura storefront. A shared data backend is the next development stage. Cost price is only displayed in this manager app; the storefront connection must be implemented separately and must not expose cost price.

## CSV import format
Headers: `name,brand,category,subcategory,image,mrp,price,cost,sizes`
Use `|` to separate variants in the sizes field.
