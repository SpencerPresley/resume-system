# CLAUDE.md

A resume system: markdown resumes rendered to HTML, PDF, and DOCX with pandoc and headless Chrome, written to a strict bullet spec.

This repo holds only the system. The person's own resumes, facts, and rules live in `me/`, a separate private git repo that this repo ignores. **Before any resume task, read `me/CLAUDE.md` if it exists.** It names the person, their source repos, and rules that override the defaults here. If `me/` doesn't exist, tell the user to run `./setup.sh`.

Every bullet sits between two banned failure modes: **junior fluff** (unfalsifiable outcomes like "made X reliable") and **label soup** (impressive nouns with no mechanism). The target is the concrete mechanism, stated plainly, that only the builder would know. `resume-rules.md` is the full spec.

## Project map

- `render.sh`: md → html → pdf → docx, plus a page-count and font check.
- `setup.sh`: checks dependencies; creates `me/` from `example/me/` or clones a private repo into it.
- `.render/style.html`: print CSS that pandoc injects into every HTML render.
- `resume-rules.md`: the bullet spec, with before/after examples.
- `example/me/`: the starter `setup.sh` copies to `me/`.
- `.claude/skills/`: third-party resume skills (MIT, see `.agents/skills/LICENSE`).
- `me/`: the user's private repo. Suggested shape:
  - `versions/master/`: source of truth, every strong bullet, allowed to run long.
  - `versions/variants/`: one-page cuts per role family.
  - `versions/tailored/<company>/`: per-application copies.
  - a facts file: verified raw material, with what may and may not be claimed.

<important if="you need to render, re-render, set up, or check the page count of a resume">

| Command | What it does |
| --- | --- |
| `./setup.sh` | Check dependencies; create `me/` from the example and `git init` it |
| `./setup.sh <private-repo-url>` | Check dependencies; clone an existing private repo into `me/` |
| `./render.sh F.md` | Write `F.html`, `F.pdf`, `F.docx` next to `F.md`; fail over 1 page or on Type 3 fonts |
| `./render.sh --max-pages 2 F.md` | Same, allowing 2 pages (a master) |
| `./render.sh --force F.md` | Re-render even when the HTML is unchanged |
| `TITLE="..." ./render.sh F.md` | Override the PDF title (default: the `# ` heading) |

- Unchanged HTML (markdown + CSS + title) leaves the PDF and DOCX untouched, so re-renders don't create timestamp-only git diffs.
- Fix page overflow by cutting words, not by shrinking the CSS.
</important>

<important if="you are editing `.render/style.html`">
- Keep `@page { margin: 0 }`. Without it, Chrome adds its own print margin and silently pushes the resume onto page 2.
- Keep `font-family: Arial`. System fonts (`-apple-system`) get embedded as Type 3 fonts, which ATS extractors misread (a name can come out as two lines). `render.sh` fails on any Type 3 font.
</important>

<important if="you are drafting or rewording resume bullets">
- The user supplies the content and the taste; you shape it to length and altitude. Offer concrete options to react to, one bullet at a time.
- Lead with the outcome, not "Built…": "Cut…", "Replaced…", "Kept…", "Made…", then the mechanism.
- One idea per bullet, 1–3 lines. Say a selling point once (put "sole owner" in the role header, not every bullet).
</important>

<important if="you are adding or changing a factual claim, number, or tech/stack tag">
- Only claim what is true. If `me/` names source repos, verify against the code, not memory or a reviewer's guess.
- Stack tags are what the person built with, not what they read while debugging.
</important>

<important if="you are writing a bullet about the employer's product rather than the person's own infrastructure">
- Say what the product does, never how it works. Test: "Could a competitor rebuild this from the bullet?" If yes, it's too low.
- The person's own infrastructure built from standard techniques (queues, schedulers, crash handling) can be described in detail.
</important>

<important if="you are adding contact details or publishing a resume anywhere public (a portfolio site, a public repo)">
- Phone numbers go only on resumes that are sent directly. Render public copies from a copy without the number, then run `pdftotext` on the PDF and grep for it before publishing.
</important>
