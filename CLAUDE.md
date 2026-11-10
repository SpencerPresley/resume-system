# CLAUDE.md

A resume system: markdown resumes rendered to HTML, PDF, and DOCX with pandoc and headless Chrome, written to a strict bullet spec.

This repo holds only the system. The person's own resumes, facts, and rules live in `me/`, a separate private git repo that this repo ignores. **Before any resume task, read `me/CLAUDE.md` if it exists.** It names the person, their source repos, and rules that override the defaults here. If `me/` doesn't exist, tell the user to run `./setup.sh`.

## Layout

- `render.sh`: md → html → pdf → docx, plus a page-count and font check.
- `.render/style.html`: print CSS that pandoc injects into every HTML render.
- `resume-rules.md`: the bullet spec. Read it before writing or editing any bullet.
- `example/me/`: the starter that `setup.sh` copies to `me/`.
- `.claude/skills/`: third-party resume skills (MIT, see `.agents/skills/LICENSE`).
- `me/`: the user's private repo. Suggested shape:
  - `versions/master/`: the source of truth, every strong bullet, allowed to run long.
  - `versions/variants/`: one-page cuts per role family.
  - `versions/tailored/<company>/`: per-application copies. Never edit master or variants for one application.
  - `facts.md` (or similar): verified raw material, with what may and may not be claimed.

## Rendering

`./render.sh path/to/file.md` writes `.html`, `.pdf`, and `.docx` next to the source. It fails when the PDF runs over `--max-pages` (default 1) or embeds Type 3 fonts. Re-render after every edit, and fix overflow by cutting words, not by shrinking the CSS.

Two settings in `.render/style.html` are load-bearing:
- `@page { margin: 0 }`. Without it, Chrome adds its own margin and silently pushes the resume onto page 2.
- `font-family: Arial`. System fonts (`-apple-system`) get embedded as Type 3 fonts, which ATS extractors parse badly (a name can come out as two lines). `render.sh` checks this with `pdffonts`.

## Writing rules (summary; `resume-rules.md` is the spec)

- Every bullet sits between two banned failure modes: **junior fluff** (unfalsifiable outcomes like "made X reliable") and **label soup** (impressive nouns with no mechanism). The target is the concrete mechanism, stated plainly, that only the builder would know.
- Lead with the outcome, not "Built…": "Cut…", "Replaced…", "Kept…", "Made…", then the mechanism.
- One idea per bullet, 1–3 lines. Say a selling point once (put "sole owner" in the role header, not in every bullet).
- Only claim what is true. If `me/` names source repos, verify numbers and tech tags against the code, not memory. Stack tags are what the person built with, not what they read while debugging.
- The employer's product: say what it does, never how it works. Test: "Could a competitor rebuild this from the bullet?" If yes, it's too low. Their own infrastructure built from standard techniques can be described in detail.
- The user supplies the content and the taste; you shape it to length and altitude. Offer concrete options to react to.

## Publishing

Phone numbers and personal email go on resumes that are sent directly, never on anything public (a portfolio site, a public repo). Before publishing a PDF, run `pdftotext` on it and grep for the number.
