# Architecture

- Client: Godot 4, GDScript, Android ARM64, Compatibility renderer.
- Backend: authoritative dedicated server; modular monolith for first online milestone.
- Persistence: PostgreSQL with migrations and immutable economy ledger.
- Server validates movement, money, inventory, ownership, job eligibility, cooldowns and role permissions.
- Character identity is separate from account identity.
- All money changes are atomic, idempotent and auditable.
- Initial vertical slice: two clients, server-authoritative movement, reconnect, proximity chat, one legal job, one police role and persistent wallet.
- Android target: 30 FPS baseline on mid-range devices; profile on physical devices before expanding the map.
- Security gates: auth/session expiry, rate limits, malformed packet handling, backups, moderation audit, load and reconnect tests.
