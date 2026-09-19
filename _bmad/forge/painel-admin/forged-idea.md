# Forged Idea: Schema-Driven Admin Panel (Nano Sites Engine)

## Locked Decisions (Locks)
- **Scope & Purpose**: In-project administration module (`lib/modules/admin`) within `vila-chico-bento-site` to enable copy editing (Hero and content sections) and uploading up to 10 gallery photos, featuring a real-time live preview and draft publishing mechanism.
- **Product Strategy**: Pilot directly inside Vila Chico Bento using standard Nano Core modular architecture; subsequently export the reusable automation pattern into an internal Skill in `nano-agents` for fast scaffolding of future client sites.
- **Data Architecture (Schema-Driven)**:
  - The Admin panel is agnostic to presentation layout: it renders reactive forms dynamically from a declarative catalog (`AdminField.text`, `AdminField.image`, `AdminField.gallery`).
  - The public Landing Page consumes content by key (`content.get('hero.title', fallback: '...')`), allowing arbitrary Figma layouts without modifying Admin code.
- **Isolation & Security**:
  - `nano_core` remains pure, lightweight, and untouched (no administrative UI or Firebase dependencies).
  - Multi-tenant / Multi-site hosting on agency Firebase infrastructure, guarded by strict Firestore (`sites/{siteId}`) and Storage (`sites/{siteId}/gallery/`) Security Rules.
  - End clients never touch the Google Cloud / Firebase console; they access only the authenticated `/admin` route.
- **Admin UX**:
  - Desktop split-screen (Form inputs on the left, responsive Live Preview on the right).
  - Strict file size/format constraints for images (2MB max, WebP/PNG/JPEG) and character limits for text.
  - Automatic fallback to code defaults: if the database is unreachable or fields are blank, the site never breaks.
- **Workflow Track**: Full BMAD formal lifecycle (Epics and Stories) requested by user for complete traceability and documentation prior to code implementation.

## Rejected Options (Killed)
- **Creating a standalone Dart Package immediately (`nano-cms`)**: Rejected to eliminate multi-repo maintenance overhead, versioning churn, and premature abstraction before production validation.
- **Free-form Layout Builder (Wix/Elementor style)**: Rejected. Clients edit CONTENT (copy and photos) only. Layout geometry and responsive styling remain strictly governed by the developer.
- **Dedicated Client-Owned Firebase Account**: Rejected due to high operational risk of lost credentials, accidental resource deletion, and configuration friction for non-technical small business owners.
