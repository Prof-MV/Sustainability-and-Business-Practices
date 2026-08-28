# MGMT-3105 Sustainability and Business Practices

Lecture notes for **MGMT-3105 - Sustainability and Business Practices**, an introduction
to project management, built as a [Quarto](https://quarto.org) book.

The book is published at
<https://prof-mv.github.io/Sustainability-and-Business-Practices/> (HTML, PDF, and EPUB).

## Building locally

```sh
quarto render          # full book, all formats
quarto preview         # live HTML preview while editing
```

Requires [Quarto](https://quarto.org/docs/get-started/), R with the packages listed in
`R/required_packages.R` (auto-installed on first render), and
[TinyTeX](https://quarto.org/docs/output-formats/pdf-basics.html#installation) for PDF
output (`quarto install tinytex`).

Interactive R cells use the vendored [`quarto-webr`](https://github.com/coatless/quarto-webr)
extension in `_extensions/coatless/webr/` and only execute in a browser served over
`http://` (they show source only in PDF/EPUB).

## Structure

- `index.qmd`, `NN-Chapter-Name.qmd` - chapter source files, in `_quarto.yml`'s `book: chapters:` order
- `_quarto.yml` - book metadata and format settings (HTML/PDF/EPUB)
- `images/` - figures and diagrams referenced by chapters
- `R/` - shared helper functions (`helpers.R`) and package setup (`required_packages.R`)
- `OriginalInfo/` - source lecture decks, case studies, and course templates the chapters are built from (not rendered)
- `.github/workflows/publish.yml` - CI: renders the book and deploys `docs/` to the `gh-pages` branch on every push to `master`

## Chapter map

| Ch | Topic | Source lecture |
|----|-------|----------------|
| 1  | Sustainability | Lecture 1 |
| 2  | Introduction to Project Management and Communication | Lecture 2 |
| 3  | Project Scope, Charter, and Organizational Structures | Lecture 3 |
| 4  | Leadership and the Project Manager | Lecture 4 |
| 5  | Work Breakdown Structures (WBS) | Lecture 5 |
| 6  | Network Diagrams and Activity-on-Node (AON) | Lecture 6 |
| 7  | Risk Management | Lecture 7 |
| 8  | Project Scheduling | Lecture 8 |
| 9  | Cost Estimation and Budgeting | Lecture 9 |
| 10 | Negotiation and Conflict Management | Lecture 10 |
| 11 | Resource Management | Lecture 11 |
| 12 | Project Control Systems | course map Lecture 12 |
| 13 | Project Closeout and Termination | Lecture 12 (file) |
