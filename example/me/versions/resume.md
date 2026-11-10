# Alex Rivera

555-010-0199 | [alex@example.com](mailto:alex@example.com) | [alexrivera.dev](https://alexrivera.dev) | [github.com/alexrivera](https://github.com/alexrivera)

## Experience

**Northwind Logistics — Software Engineer** | Jun 2024 – Present

*Route-planning platform for regional freight carriers. Sole owner of the dispatch backend.*

- **Replaced a cron-driven dispatch loop with a Postgres job queue**, so a slow carrier API no longer delays every other shipment. Workers claim jobs with `SELECT FOR UPDATE SKIP LOCKED`, and each carrier gets its own concurrency limit.
- **Cut the shipment search endpoint from 4.1 s to 90 ms** on an 18M-row table by replacing an `OR`-heavy filter with a composite index and a precomputed status column kept current by a trigger.
- **Made failed deliveries retry themselves.** A webhook failure schedules a retry with exponential backoff and jitter; after five attempts the job moves to a dead-letter table that support can replay from the admin page.

**Tidewater Analytics — Software Engineering Intern** | May 2023 – Aug 2023

- **Turned a weekly manual report into a scheduled pipeline** that loads raw sensor exports into Postgres, flags gaps over two hours, and emails a summary to the field team.

## Projects

**[tinykv](https://github.com/alexrivera/tinykv)** — *Rust, Tokio*

- Wrote a log-structured key-value store with a write-ahead log and background compaction; a crash test kills the process mid-write and checks every acknowledged key survives restart.

## Skills

- **Languages:** Python, Rust, TypeScript, SQL
- **Backend & infra:** Django, FastAPI, PostgreSQL, Redis, Docker, Linux, GitHub Actions
- **Cloud:** AWS (EC2, S3, RDS, IAM, CloudWatch)

## Education

**State University** — B.S. Computer Science | May 2024
