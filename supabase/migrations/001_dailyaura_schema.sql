-- DailyAura central product database (Supabase / PostgreSQL)
-- Run this in Supabase SQL Editor after creating a project.
-- Public storefront data is separated from private cost data.

create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create or replace function public.is_dailyaura_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.admin_users
    where user_id = auth.uid()
  );
$$;

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  icon text default '📦',
  sort_order integer not null default 0,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.subcategories (
  id uuid primary key default gen_random_uuid(),
  category_id uuid not null references public.categories(id) on delete cascade,
  name text not null,
  sort_order integer not null default 0,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  unique(category_id, name)
);

create table if not exists public.brands (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  product_code text unique,
  name text not null,
  brand_id uuid references public.brands(id) on delete set null,
  category_id uuid references public.categories(id) on delete set null,
  subcategory_id uuid references public.subcategories(id) on delete set null,
  size text,
  image_url text,
  mrp numeric(12,2) not null default 0 check (mrp >= 0),
  sale_price numeric(12,2) not null default 0 check (sale_price >= 0),
  status text not null default 'Unpublished' check (status in ('Published','Unpublished','Needs Attention')),
  clearing_out boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.product_variants (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  label text not null,
  image_url text,
  mrp numeric(12,2) not null default 0 check (mrp >= 0),
  sale_price numeric(12,2) not null default 0 check (sale_price >= 0),
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  unique(product_id, label)
);

-- Private cost data: deliberately separate from public product and variant tables.
create table if not exists public.product_costs (
  product_id uuid primary key references public.products(id) on delete cascade,
  cost_price numeric(12,2) not null default 0 check (cost_price >= 0),
  updated_at timestamptz not null default now()
);

create table if not exists public.variant_costs (
  variant_id uuid primary key references public.product_variants(id) on delete cascade,
  cost_price numeric(12,2) not null default 0 check (cost_price >= 0),
  updated_at timestamptz not null default now()
);

create index if not exists products_public_listing_idx on public.products(status, category_id, subcategory_id);
create index if not exists products_brand_idx on public.products(brand_id);
create index if not exists variants_product_idx on public.product_variants(product_id);

alter table public.admin_users enable row level security;
alter table public.categories enable row level security;
alter table public.subcategories enable row level security;
alter table public.brands enable row level security;
alter table public.products enable row level security;
alter table public.product_variants enable row level security;
alter table public.product_costs enable row level security;
alter table public.variant_costs enable row level security;

-- Admin membership can only be managed by the project's database owner initially.
-- Admins can read their own membership record.
create policy "Admins can read own admin membership"
on public.admin_users for select to authenticated
using (user_id = auth.uid());

create policy "Public can read active categories"
on public.categories for select to anon, authenticated
using (active = true);

create policy "Admins manage categories"
on public.categories for all to authenticated
using (public.is_dailyaura_admin())
with check (public.is_dailyaura_admin());

create policy "Public can read active subcategories"
on public.subcategories for select to anon, authenticated
using (active = true);

create policy "Admins manage subcategories"
on public.subcategories for all to authenticated
using (public.is_dailyaura_admin())
with check (public.is_dailyaura_admin());

create policy "Public can read active brands"
on public.brands for select to anon, authenticated
using (active = true);

create policy "Admins manage brands"
on public.brands for all to authenticated
using (public.is_dailyaura_admin())
with check (public.is_dailyaura_admin());

create policy "Public can read published products"
on public.products for select to anon, authenticated
using (status = 'Published');

create policy "Admins manage products"
on public.products for all to authenticated
using (public.is_dailyaura_admin())
with check (public.is_dailyaura_admin());

create policy "Public can read variants of published products"
on public.product_variants for select to anon, authenticated
using (exists (
  select 1 from public.products p
  where p.id = product_variants.product_id and p.status = 'Published'
));

create policy "Admins manage variants"
on public.product_variants for all to authenticated
using (public.is_dailyaura_admin())
with check (public.is_dailyaura_admin());

create policy "Admins read product costs"
on public.product_costs for select to authenticated
using (public.is_dailyaura_admin());

create policy "Admins manage product costs"
on public.product_costs for all to authenticated
using (public.is_dailyaura_admin())
with check (public.is_dailyaura_admin());

create policy "Admins read variant costs"
on public.variant_costs for select to authenticated
using (public.is_dailyaura_admin());

create policy "Admins manage variant costs"
on public.variant_costs for all to authenticated
using (public.is_dailyaura_admin())
with check (public.is_dailyaura_admin());

-- Storage bucket for customer-facing product images.
insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do nothing;

create policy "Public can view product images"
on storage.objects for select to anon, authenticated
using (bucket_id = 'product-images');

create policy "Admins upload product images"
on storage.objects for insert to authenticated
with check (bucket_id = 'product-images' and public.is_dailyaura_admin());

create policy "Admins update product images"
on storage.objects for update to authenticated
using (bucket_id = 'product-images' and public.is_dailyaura_admin())
with check (bucket_id = 'product-images' and public.is_dailyaura_admin());

create policy "Admins delete product images"
on storage.objects for delete to authenticated
using (bucket_id = 'product-images' and public.is_dailyaura_admin());

-- Optional initial categories/brands can be loaded after the admin is configured.
