# resume-system

Write your resume in markdown, render it to an ATS-clean PDF (plus HTML and DOCX) with one command, and keep the content in your own private repo. It's built to be worked with [Claude Code](https://claude.com/claude-code): `CLAUDE.md` and `resume-rules.md` teach it a strict bullet spec, so it writes concrete, mechanism-first bullets instead of fluff.

## How it's split

```
resume-system/          this repo (public): the renderer, the style, the rules
  render.sh
  setup.sh
  .render/style.html
  CLAUDE.md, resume-rules.md
  example/me/           starter content
  me/                   YOUR private repo, cloned here and ignored by this one
```

Your resumes, phone number, and notes about your job never touch this repo. `me/` is a separate git repo that this one lists in `.gitignore`. That way you can pull template updates with `git pull` and push your resume to your own private remote, and the two never mix.

It's deliberately not a git submodule. A submodule would write your private repo's URL into this public repo, and every resume edit would need a matching pointer commit here.

## Setup

Requirements: `pandoc`, `poppler` (for `pdfinfo` and `pdffonts`), and Google Chrome or Chromium.

```bash
# macOS
brew install pandoc poppler
# Debian/Ubuntu
sudo apt install pandoc poppler-utils chromium
```

**First time.** Click **Use this template** on GitHub (a copy with fresh history and no fork link), clone it, then:

```bash
./setup.sh                      # copies example/me/ to me/ and runs git init in it
gh repo create my-resume --private --source me --push   # or any private remote
```

**Another machine.** Clone this repo, then:

```bash
./setup.sh git@github.com:<you>/my-resume.git           # clones your private repo into me/
```

`setup.sh` also checks the dependencies and tells you what's missing.

## Rendering

```bash
./render.sh me/versions/resume.md                  # writes .html, .pdf, .docx next to it
./render.sh --max-pages 2 me/versions/master.md    # allow a 2-page master
./render.sh me/versions/variants/*.md              # several at once
```

Each render prints the page count and exits non-zero if the PDF runs past `--max-pages` (default 1) or embeds Type 3 fonts. The PDF title comes from the file's `# Name` heading; set `TITLE="..."` to override it. If Chrome isn't in a standard location, set `CHROME=/path/to/chrome`.

### Why the style looks the way it does

- **Arial, not the system font.** Chrome embeds macOS system fonts as Type 3 fonts, and ATS parsers extract those badly; a name can come out split across two lines. `render.sh` fails the render if any Type 3 font gets in.
- **`@page { margin: 0 }`.** Without it, Chrome adds its own print margin on top of the CSS padding and silently pushes a one-page resume onto page 2.
- **Send the PDF.** The DOCX is plain pandoc output and is there for portals that insist on Word.

## Writing the resume

The markdown format is ordinary pandoc markdown. See `example/me/versions/resume.md`:

```markdown
# Your Name

555-010-0199 | [you@example.com](mailto:you@example.com) | [site](https://...) | [github](https://...)

## Experience

**Company — Title** | Jun 2024 – Present

*One line on what the company does and what you own.*

- **Outcome first, in bold.** Then the mechanism that got it.
```

The rules that make the bullets good are in [`resume-rules.md`](resume-rules.md). In short, every bullet avoids two failure modes:

- **Junior fluff**: "Improved system reliability."
- **Label soup**: "Engineered a scalable, fault-tolerant, event-driven architecture."

It states the concrete mechanism that only the person who built it would know:

> **Replaced a cron-driven dispatch loop with a Postgres job queue**, so a slow carrier API no longer delays every other shipment.

## Using it with Claude Code

Open Claude Code in the repo root. It reads `CLAUDE.md`, which tells it to read `me/CLAUDE.md` before any resume work. Fill `me/CLAUDE.md` in with:

- the roles you're targeting;
- the repos it can read to verify your claims;
- a "never claim" list that grows every time you catch a wrong one.

Then ask for things like:

- "Tighten the second bullet under Northwind. It reads as fluff."
- "Make a variant for backend roles and keep it to one page."
- "Tailor a copy for this job posting: <paste>."

The skills in `.claude/skills/` (ATS checks, bullet writing, tailoring) are from [paramchoudhary/resumeskills](https://github.com/paramchoudhary/resumeskills), MIT-licensed; see `.agents/skills/LICENSE`.

## Keeping private things private

- Keep your phone number on resumes you send directly. Before publishing a PDF anywhere public, render it from a copy without the number and check: `pdftotext file.pdf - | grep -E '[0-9]{3}-[0-9]{3}-[0-9]{4}'`.
- Describe your employer's product by what it does, not how it works. See "Altitude" in `resume-rules.md`.

## License

MIT for this repo's own files; see `LICENSE`. The bundled skills keep their own MIT license.
