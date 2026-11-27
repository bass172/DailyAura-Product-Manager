# DailyAura Firebase setup — Phase 1 (Authentication groundwork)

Firebase project: **daulyaura** (Spark/free plan).

## Implemented in the app
- Firebase web SDK configuration in `firebase.js`.
- Admin login using Firebase Email/Password Authentication.
- App requires an authenticated session to open the Product Manager.
- Sign-out button in the manager header.
- Firestore security rules draft in `firestore.rules` with default-deny behavior and separate private manager/public catalog paths.

## Required one-time console step: publish rules
1. Open Firebase Console and select project **daulyaura**.
2. Go to **Firestore Database → Rules**.
3. Copy the rules from this repository's `firestore.rules`.
4. Replace `REPLACE_WITH_ADMIN_EMAIL` with the exact email address of your admin account.
5. Click **Publish**.

Do not publish rules with the placeholder still in place. Until the admin email is replaced, Firestore access is intentionally denied.

## Authentication
Email/Password provider and the admin user were created in Firebase Console. The app login uses that account. Do not share your password in chat or commit it to GitHub.

## Data safety and next phase
This commit adds authentication only. Existing product/category/brand records still remain in this browser's local storage; **they have not been moved to Firestore yet**. The next implementation phase will add cloud sync and a safe migration/export prompt before transferring existing data. Cost-price fields must stay in the private manager collection; the public storefront will receive a separate projection containing only published products and public prices.

## Images
Image upload storage is not connected yet. Keep using image URLs or the current browser-local image workflow until a free hosting option is chosen. Firebase Storage may require a billing upgrade for new projects; do not upgrade or add a payment card as part of this setup.
