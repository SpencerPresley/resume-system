# Resume rules

Read this before writing or editing any bullet. When the user corrects something new, add the correction to `me/resume-rules.md` (personal) or here (if it applies to everyone).

## The core tension

Most resumes fail in one of two opposite directions:

1. **Junior fluff**: plain-language outcome claims anyone could type: "keeps systems alive," "removed the guesswork," "made X trustworthy." Unfalsifiable, so they read as junior. Banned.
2. **Label soup**: a string of impressive nouns with no mechanism: "token-priced admission control with deadlock-free database locking and no overcommit." It reads as made up and makes the reader doubt everything else. Banned.

The target between them: **the concrete mechanism, stated plainly, that only the person who built it would know.** Specificity is what gets past a "years of experience" filter. Vagueness invites the junior read, not a short tenure.

## Altitude

- **Your own infrastructure** (job queues, crash handling, caching, schedulers, data pipelines) is built from standard techniques. Describe it in detail: `SELECT FOR UPDATE SKIP LOCKED`, spawn-not-fork, chaos tests. A competitor gains nothing, and the detail is the proof.
- **Your employer's product internals** (its detection logic, ranking algorithm, pricing engine, proprietary pipeline) stay at altitude. Say what it does, not the architecture, data flow, or algorithm. A resume is not a design doc, and describing the product's internals leaks your employer's IP.
- Test: "Could someone rebuild this from my bullet?" If it's the product and the answer is yes, it's too low.

## Hard rules

- **Never claim something that isn't true.** Verify numbers against the code or the database, not memory or a reviewer's guess. No false negatives about other tools either: "X can't do Y" has to be true.
- **"Live" needs a caller.** Code that exists but is never called in production is not "in production."
- **Built but behind a flag still counts**, if it works and can be turned on.
- **No raw line or test counts as flexes.** "11.7K lines / 406 tests" says nothing. The *kind* of testing does: chaos tests, SIGKILL mid-run, race storms.
- **Say a selling point once**, in the role header, not in every bullet.
- **One idea per bullet.**
- **Stack tags are what you built with**, not what you read while debugging.
- **Don't paste reviewer or AI phrasing onto the page.** Treat it as fact-check input (true / false / where in the code), then write the bullet yourself.
- **Don't qualify your work down.** An apologetic parenthetical like "(using Python multiprocessing)" undercuts the claim. State the engineering.

## Before / after

- Fluff → mechanism: "Improved reliability of the dispatch system" → "Replaced a cron-driven dispatch loop with a Postgres job queue, so a slow carrier API no longer delays every other shipment."
- Product, too low (a blueprint): "Fraud scores combine a gradient-boosted model over 140 engineered velocity features with a rules layer that overrides on device-fingerprint mismatch…" → right altitude: "Shipped real-time fraud scoring that blocks card-testing attacks before authorization."
- Infra, keep the detail: "Workers claim one job atomically with `SELECT FOR UPDATE SKIP LOCKED`, priority-then-FIFO, gated on a dependency graph." It's standard technique and it reads senior.

## Process

- **The user talks, you shape.** They know the content and the taste. Get raw material from them or the code, then shape it to length and altitude. Don't invent your own version of their taste.
- **One bullet at a time.** State the constraints you think apply, then write.
- **Recognition over recall.** People spot a bad bullet instantly but can't always state the rule cold. Offer concrete options to react to.
