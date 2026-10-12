---
title: 'Painel Domain & Central User Authorization Architecture'
type: 'feature'
created: '2026-10-11'
status: 'done'
route: 'oneshot'
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Client operators currently rely on a vulnerable and unscalable `adminEmails` string array inside individual site documents, and a dev password mock (`admin123`) intercepts real Firebase authentication in debug mode, causing permission-denied errors when communicating with Firestore. Furthermore, the domain strategy for the unified client portal `painel.nanodevs.com.br` needs clean alignment across app configuration and security rules.

**Approach:** Implement Firestore Security Rules checking a centralized `/users/{uid}` collection with `isSuperAdmin` (global access for Durval and spouse) and `allowedSites` (tenant-scoped access for clients like Vila Chico Bento). Remove the `admin123` bypass in `FirebaseAuthRepository` so legitimate Firebase tokens are issued, configure the `/users/{uid}` model, and update tests to verify seamless authorization.

</frozen-after-approval>

## Implementation Notes

- **`firestore.rules`**: Implemented `isSuperAdmin()` and `canEditSite(siteId)` checking `/users/$(request.auth.uid)` with `exists(...)` safety checks, plus a backwards-compatible fallback for `adminEmails`. Validated successfully with zero errors.
- **`FirebaseAuthRepository`**: Cleaned up the `kDebugMode` mock interceptor so authentications invoke `_auth.signInWithEmailAndPassword`, issuing real JWT tokens to Firestore.
- **`AdminLoginPage`**: Removed the demo bypass button and cleaned up unused foundation imports.
- **Firestore Central User**: Created SuperAdmin profile in Firestore at `/users/Ic1FQ1EjBCZVFvfdDYMYqEtdQrq1` (`isSuperAdmin: true`) for `teste@nanodevs.com.br`.
- **Validation**: 53/53 tests passed (`flutter test`), and static analysis (`dart analyze`) returned 0 warnings/errors.
