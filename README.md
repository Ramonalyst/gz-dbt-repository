# gz-dbt-repository

A **dbt** project that models GZ (Greenweez) raw ecommerce + paid marketing data into curated **finance reporting marts** (daily + monthly KPIs).

The project is organized into the classic dbt layers:

- **Staging (`models/staging/`)**: light cleanup/renaming + type casting from raw sources
- **Intermediate (`models/intermediate/`)**: business logic joins/unions + KPI building blocks
- **Mart (`models/mart/`)**: final finance-facing models (tables) for reporting/BI

---

## What this project builds (high level)

### Data sources (BigQuery)
This project defines a `raw` source schema in BigQuery:

- Dataset: `gz_raw_data`
- Source tables (via `models/schema.yml`):
  - `raw_gz_sales` (sales lines)
  - `raw_gz_product` (product purchase prices)
  - `raw_gz_ship` (shipping & logistics costs)
  - `raw_gz_adwords`, `raw_gz_bing`, `raw_gz_criteo`, `raw_gz_facebook` (paid campaign performance)

### Staging models
Located in `models/staging/raw/`:

- `stg_raw__sales` (sales lines, includes `orders_id`, `products_id`, `revenue`, `quantity`)
- `stg_raw__product` (product costs / purchase prices)
- `stg_raw__ship` (shipping_fee, log_cost, ship_cost)
- `stg_raw__adwords`, `stg_raw__bing`, `stg_raw__criteo`, `stg_raw__facebook` (standardized paid campaign fields + cost cast to FLOAT64)

### Intermediate models
Located in `models/intermediate/`:

- `int_campaigns`: union of all paid sources into one campaigns model
- `int_campaigns_day`: daily aggregation of campaign cost / impressions / clicks
- `int_sales_margin`: joins sales to product cost to compute purchase_cost + margin
- `int_orders_margin`: aggregates margin metrics at the order level
- `int_orders_operational`: joins order margin with shipping/logistics to compute operational margin

### Finance mart models
Located in `models/mart/finance/`:

- `finance_days`: daily commerce KPIs (transactions, revenue, avg basket, margin, operational margin)
- `finance_campaigns_day`: combines daily finance + daily paid KPIs and computes `ads_margin`
- `finance_campaigns_month`: monthly rollup of finance_campaigns_day

---

## Project configuration

dbt project config is in `dbt_project.yml`.

Key settings:
- Project name (currently): `dbt_project.yml`
- Profile: `default`
- Materializations:
  - `models/staging`: views
  - `models/intermediate`: views
  - `models/mart`: tables
  - `models/mart/finance`: schema override to `finance`

---

## Getting started

### Prerequisites
- Python environment with `dbt` installed (adapter should match your warehouse, e.g. `dbt-bigquery`)
- A working dbt profile named **`default`** pointing at your warehouse (not committed in this repo)

### Install dependencies (if you add packages)
If you use `packages.yml`, run:
```bash
dbt deps
```

### Run the project
Build models:
```bash
dbt run
```

Run tests:
```bash
dbt test
```

Common developer workflow:
```bash
dbt build
```

---

## Testing & data quality

Tests are declared in `models/schema.yml` for:
- Uniqueness and not-null constraints on raw keys (ex: `ship.orders_id`, `product.products_id`)
- Uniqueness at the model grain level (ex: `(campaign_key || '-' || date_date)` for campaigns)

---

## Repository layout

```text
.
├── analyses/
├── macros/
├── models/
│   ├── schema.yml
│   ├── staging/
│   │   └── raw/
│   ├── intermediate/
│   └── mart/
│       └── finance/
├── seeds/
├── snapshots/
└── tests/
```

---

## How to contribute

1. Create a new branch
2. Add/modify models under the appropriate layer (staging → intermediate → mart)
3. Run:
   ```bash
   dbt build
   ```
4. Open a PR
