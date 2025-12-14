# Server (XAMPP) API

This folder contains a minimal REST API and SQL schema for running a local development API using XAMPP.

PHP endpoint (copy to `htdocs/api/scholarships.php`):
- `server/php/scholarships.php` — returns list (`GET`), creates (`POST`), updates (`PUT`) and deletes (`DELETE`) scholarships.

Database schema:
- `server/sql/schema.sql` — SQL to create the `scholarships` table.

Instructions:
1. Install XAMPP and start Apache and MySQL.
2. Import `server/sql/schema.sql` into a database named `scholarship_db` (or modify DSN in `scholarships.php`).
3. Copy `server/php/scholarships.php` to `htdocs/api/` inside the XAMPP installation. Use `server/sql/seed.sql` to add sample data if desired.
4. Test by visiting: `http://localhost/api/scholarships.php` in your browser or use `curl`.
