# DailyAura backend setup — Phase 1

## Selected backend
Supabase (Postgres database, Authentication, and Storage). The free tier is suitable for initial setup/testing, but free projects can pause after inactivity and have usage limits. Check the current plan before relying on it for production.

## 1. Create a Supabase project
1. Open https://supabase.com and create/sign in to your account.
2. Create a project named **DailyAura**.
3. Choose a strong database password and save it somewhere safe.
4. Select a region close to your customers (India region if available).
5. Wait until the project is ready.

## 2. Create the database structure
1. Open the project dashboard.
2. Go to **SQL Editor** → **New query**.
3. Open and copy all contents from `supabase/migrations/001_dailyaura_schema.sql`.
4. Paste into SQL Editor and run.
5. Confirm tables appear in Table Editor.

## 3. Create the admin login
1. In Supabase, open **Authentication → Users**.
2. Add your admin user (email and password).
3. Copy the user's UUID.
4. In SQL Editor, run this, replacing the placeholder with your actual UUID:

```sql
insert into public.admin_users (user_id)
values ('PASTE-YOUR-USER-UUID-HERE');
```

Only this admin membership grants protected manager access. Do not share the UUID, password, database password, or any service-role key in chat.

## 4. Storage
The migration creates a public `product-images` bucket. Anyone can view storefront images; only authenticated DailyAura admins can upload, replace, or delete images.

## 5. Important security rules
- Cost prices are in separate private tables and are not part of public product queries.
- The public website can read only products marked `Published` and their public variant prices/images.
- Never place a Supabase service-role key in browser code or GitHub Pages.
- The next development phase will connect the manager using the Supabase public/anon key and authenticated admin session, then migrate existing local data.

## 6. Next implementation phase
Connect the React app to Supabase Auth + database, add migration/backup controls, and preserve a safe local export before moving existing products. The storefront will then consume the public tables.
