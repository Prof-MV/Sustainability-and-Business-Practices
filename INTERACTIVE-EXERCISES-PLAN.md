# Interactive exercises: audit and plan

Book: *Sustainability and Business Practices* (MGMT-3105), 13 chapters.
Status: **Phases 3 and 4 built on branch `interactive-exercises`: all 13 chapters have 4 exercises, 6 of them with a graded Brightspace twin set, plus 7 challenge cards and 1 simulation.** What was built is in sections 7 and 8; open items at the end of section 8.

Legend for the tables: **S** = student alone, **C** = also works on a projector;
effort **S/M/L**; ★ = build first in that chapter. "Twin" = also exported to
`quizzes/tryit_<chapter>.csv` for Brightspace (with different numbers from the
on-page copy).

---

## 1. Where the book stands today

**Build.** Quarto book (`_quarto.yml`), knitr engine, `freeze: auto` (`_freeze/`
is committed), HTML + PDF (xelatex, TinyTeX is installed here) + EPUB. CI
(`.github/workflows/publish.yml`) renders everything on push to `master` and
publishes `docs/` to `gh-pages`. `docs/` and `quizzes/` are gitignored, so
generated Brightspace files are not committed. `js/` is already a Quarto
resource.

**Machinery.** `R/helpers.R` (`qwebr_calc_card()` without `goal`/`rerun`),
`js/qwebr-calculator.js`, calculator CSS and the hand-written `.aon-*` CSS in
`style.css`. The vendored `quarto-webr` extension is loaded by **all 13
chapters** (`filters: webr` in each header). **No `tryit` library exists here**;
the home copy is in the sibling `../ProcessEngineering` (`R/tryit.R`,
`js/tryit.js`, `.tryit-*` CSS, `goal`/`goal_test`/`rerun` on the card). No
`CLAUDE.md`; the README documents the build only. Existing quizzes use IDs of
the form `MGMT-3105-CH06-1`.

**Chapter shape.** Learning objectives, a "before we begin" reveal, case-study
box, worked example (usually a calculator card), "Try it yourself" cells,
Key Takeaways, a Meridian R/C case study, 3 to 4 Practice Problems (nested
`<details>`, solution inside), videos.

| Ch | Topic | Calc cards | Bare webR cells | Reveal blocks* | Practice problems | Checked exercises |
|---|---|---|---|---|---|---|
| 1 | Sustainability | 3 | 1 | 16 | 4 | 0 |
| 2 | Intro & communication | 4 | 0 | 10 | 3 | 0 |
| 3 | Scope & org. structures | 3 | 1 | 9 | 3 | 0 |
| 4 | Leadership | 1 | 3 | 7 | 3 | 0 |
| 5 | WBS | 2 | 2 | 7 | 3 | 0 |
| 6 | Network diagrams / AON | 2 | 2 | 9 | 3 | **1** (hand-written HTML + inline script, ~250 lines) |
| 7 | Risk | 4 | 0 | 9 | 3 | 0 |
| 8 | Scheduling | 2 | 1 | 8 | 3 | 0 |
| 9 | Cost & budgeting | 4 | 0 | 13 | 4 | 0 |
| 10 | Negotiation & conflict | 2 | 1 | 8 | 3 | 0 |
| 11 | Resources | 1 | 2 | 6 | 3 | 0 |
| 12 | Project control (EVM) | 2 | 0 | 8 | 3 | 0 |
| 13 | Closeout | 3 | 0 | 7 | 3 | 0 |
| **Total** | | **33** | **13** | ~118 | 41 | **1** |

\*Reveal blocks excluding the 33 collapsed calculator-source blocks.

Findings:

1. Everything interactive is "change an input, watch the output", except the
   single AON node-fill exercise in ch 6.
2. Practice Problems are reveal-only; the cheapest path is to open and nod.
3. No chapter is without webR, so the "plain JS, no webR" rule is a loading-speed
   and reliability choice here, not a necessity.
4. The 13 bare cells are "edit your own data" cells (skipped on purpose when the
   cards were made); they stay as they are.

---

## 2. Widget types

Seven types cover every idea below. The first five already exist in the home
library under these names; nothing is built from scratch except the two small
extensions marked **new**.

| Type | Helper | Used for in this book |
|---|---|---|
| check-number | `tryit_number()` | EMV, NPV, channels, ZOPA, EVM, cancel/continue |
| fill-grid | `tryit_grid()` | PERT table, NPV table, risk register, S-curve, EVM table, weighted scoring, histogram |
| fill-diagram | `tryit_diagram()` | AON node boxes (ch 6), WBS roll-up tree (ch 5) |
| sort-bins | `tryit_sort()` | about 20 classification ideas (the book is full of them) |
| order-steps | `tryit_order()` | closeout elements, decision hierarchy, cheapest-first crashing |
| challenge | `goal` / `goal_test` on `qwebr_calc_card()` | 6 cards |
| sandbox | `rerun` on a card | 1 Monte Carlo schedule simulation (ch 8) |

Dropped: **label-figure** (no chapter needs it; figure reading is done by
numeric answers off a seeded R figure) and **scorer** as a separate type (a
lookup-table method is `tryit_number()` with one answer per step; used for the
FMEA ratings in ch 7). `tryit_balance()` and `tryit_layout()` are not needed.

Two small extensions, both optional with a fallback:

- **new: `choice` columns in `tryit_grid()`** (dropdown instead of a number).
  Needed for ch 9's multi-label cost classification (each item gets a label
  from each of 3 dichotomies). Fallback: three small sorters.
- **new: derived cell and node-marking in `tryit_diagram()`** (float fills
  itself from ES and LS; click nodes to mark the critical path). Needed for
  parity with the existing hand-written AON exercise. Fallback: float as an
  ordinary blank, critical path as a separate sorter.

Both would be tell-you-so changes to carry back to the Process Engineering book.

Loading: copy `R/tryit.R`, `js/tryit.js`, the `.tryit-*` block of `style.css`,
and the `goal`/`goal_test`/`rerun` changes to `qwebr_calc_card()` and
`js/qwebr-calculator.js`. Add `options(tryit.course = "MGMT-3105")` and
`source("R/tryit.R")` at the end of `R/helpers.R` (chapters already source it).
`jsonlite` and `htmltools` arrive with rmarkdown, so CI needs no new packages.
Because `freeze: auto` is on, Brightspace files are regenerated whenever a
chapter is re-executed, not on a cached render.

---

## 3. Ideas by chapter

"Build" = the 3 to 4 I would build (all marked ★ or listed in order of value).
Anything extra is optional.

### 01 Sustainability
| Idea | Type | Mode | Effort |
|---|---|---|---|
| ★ Material-reduction by hand: new part (62 g to 54 g bottle, 300 000 units) to kg, $, MJ, CO2e (LO5) | check-number, twin | S | S |
| Whole-life-cost crossover: make the cheap version cheaper to own (finds the `ceiling()` step, horizon about 4 yr) (LO6) | challenge | S, C | S |
| Checklist sorter: 10 actions to procurement / design / operations / governance (LO7) | sort | S, C | S |
| Recycling-code sorter: 8 products to easy / hard to recycle (LO3) | sort | S | S |
| Circular-economy loops ordered tightest to widest | order | S | S |

### 02 Introduction and communication
| Idea | Type | Mode | Effort |
|---|---|---|---|
| ★ Channels and a merger: before/after channels and % growth for fresh team sizes (LO6) | check-number, twin | S | S |
| Which report? Stakeholder questions to status / progress / trend / forecast / variance / EV (LO8) | sort | S, C | S |
| Pick the method: 8 messages to formal/informal x written/verbal (LO5) | sort | S, C | S |
| Triple-constraint crossover: find the defect-escape probability at which skipping a test stops being cheapest (about 21 %) (LO2) | challenge | S | S |
| Decision hierarchy ordering (LO4) | order | S | S |

### 03 Scope, charter, structures
| Idea | Type | Mode | Effort |
|---|---|---|---|
| ★ NPV table by hand: discount factor, PV, cumulative PV for a fresh project, then NPV and discounted payback (LO1) | fill-grid + answers, twin | S | M |
| Raise the hurdle rate until NPV goes negative (finds the IRR, about 22 %) (LO1) | challenge | S, C | S |
| Power-interest grid: stakeholders with scores to quadrants (LO4) | sort | S, C | S |
| Structure sorter: scenarios to functional / projectized / weak / balanced / strong matrix (LO7) | sort | S, C | S |
| Charter or scope statement? (fresh items) (LO2, LO5) | sort | S | S |

### 04 Leadership
| Idea | Type | Mode | Effort |
|---|---|---|---|
| ★ Style matcher: situations to the five styles (LO3) | sort | S, C | S |
| Tuckman: statements to forming / storming / norming / performing / adjourning (LO5) | sort | S | S |
| Hygiene or motivator? fresh complaints (LO6) | sort | S, C | S |
| Expectancy by hand: E x I x V for three people, then the weakest factor (LO6) | check-number | S | S |

### 05 Work breakdown structures
| Idea | Type | Mode | Effort |
|---|---|---|---|
| ★ WBS roll-up tree: leaf hours given, fill every parent up to Level 1 (LO6) | fill-diagram (down, no arrows), twin | S | M |
| Right size? Work packages (hours stated) to ok / too big / too small (LO4) | sort | S, C | S |
| Outcome or action? WBS wordings (LO3) | sort | S | S |
| 100 % rule: fragments to gap / overlap / out-of-scope / ok (LO3) | sort | S, C | S |

### 06 Network diagrams and AON
| Idea | Type | Mode | Effort |
|---|---|---|---|
| ★ Re-express the existing node-fill exercise as `tryit_diagram()` and add a second 9-activity network with merges and bursts, team-seeded durations (LO3 to LO5) | fill-diagram, twin | S, C | M |
| PERT table: te, SD for 5 fresh activities (LO6) | fill-grid, twin | S | S |
| Valid network? Fragments to valid / loop / two starts / missing predecessor (LO2) | sort | S, C | S |
| Crash challenge on the shift explorer: finish the sub-project in 31 days or fewer (needs B <= 3 and B + E <= 6; crashing E alone does not work) (LO7) | challenge | S, C | S |
| Gantt read-off: start day, finish day, gap = float | check-number | S | S |

### 07 Risk management
| Idea | Type | Mode | Effort |
|---|---|---|---|
| ★ Risk register by hand: probability and impact for 5 fresh risks to EMV, total EMV as contingency, top risk (LO4, LO6) | fill-grid + answers, twin | S | M |
| Response strategy: scenarios to accept / minimize / share / transfer / reserve (LO5) | sort | S, C | S |
| P-I zones: risks with 1 to 5 scores to green / yellow / red (cut-offs 6 and 12 from the chapter figure) (LO3) | sort | S, C | S |
| FMEA RPN: S, O, D given, fill RPN, rank, flag S >= 8 (LO7) | fill-grid, twin | S | M |
| Mitigation stops paying: find the cost above which it is not worth it (about $82 000) (LO4) | challenge | S | S |

### 08 Project scheduling
| Idea | Type | Mode | Effort |
|---|---|---|---|
| ★ Probability of finishing: te and variance per activity (fresh o/m/p), mu, sigma, z, P(on time), 90 % date (LO3, LO4) | fill-grid + answers, twin | S | M |
| Monte Carlo schedule: simulate the same 5-activity path; find the earliest target day hit in at least 90 % of runs; run number = team number (LO4) | sandbox + challenge | C | M |
| Crash slopes: fill slope and max crash for 4 activities, then least cost for N weeks (LO5) | fill-grid + answers, twin | S | M |
| FS / FF / SS / SF: scenarios to relationship type (LO2) | sort | S, C | S |

### 09 Cost estimation and budgeting
| Idea | Type | Mode | Effort |
|---|---|---|---|
| ★ Cost-type labels: 10 items, three dropdowns each (direct/indirect, fixed/variable, normal/expedited) (LO1) | fill-grid with choice columns (new), twin | S, C | M |
| Which estimating method, and what band around a fresh estimate (LO3) | sort + check-number | S | S |
| Time-phased budget: fill monthly totals and the cumulative baseline for 5 activities (LO6) | fill-grid + answers | S | M |
| Fully-burdened cost and variance with fresh figures (LO2, LO5) | check-number, twin | S | S |
| Budget under the ceiling card challenge | challenge | S | S, optional (goal needs constraints; see open decisions) |

### 10 Negotiation and conflict
| Idea | Type | Mode | Effort |
|---|---|---|---|
| ★ ZOPA by hand: BATNA and costs to reservation points, width, midpoint; a second scenario with no ZOPA, give the gap (LO2, LO4) | check-number, twin | S | S |
| Resolution method: situations to confronting / compromising / withdrawal / smoothing / forcing (LO6) | sort | S, C | S |
| Weighted supplier score: weights x scores, three suppliers (LO7) | fill-grid, twin | S | M |
| Conflict type and cause: statements to goal / administrative / interpersonal (LO5) | sort | S, C | S |
| Strong BATNA: find the alternative's price at which the ZOPA disappears (below $122 000) (LO2) | challenge | S, C | S |

### 11 Resource management
| Idea | Type | Mode | Effort |
|---|---|---|---|
| ★ Histogram by hand: tasks with start/duration/people to daily demand, peak day, days over limit (LO2) | fill-grid + answers, twin | S | M |
| Which task moves first? Order 5 candidates by the chapter's heuristic list (LO3) | order | S, C | S |
| Multitasking: effective hours and % productive for fresh figures (LO7) | check-number, twin | S | S |
| Priority rule for shared resources: scenarios to rule (LO6) | sort | S | S |

### 12 Project control
| Idea | Type | Mode | Effort |
|---|---|---|---|
| ★ EVM by work package: BAC, % planned, % complete, AC given; fill PV, EV, SV, CV, then project CPI, SPI, EAC (LO3, LO4) | fill-grid + answers, twin | S, C | M |
| Which EAC formula? scenarios to BAC/CPI, AC+(BAC-EV), CPI x SPI (LO4) | sort | S, C | S |
| Status quadrant: SPI/CPI pairs to behind-and-over, ahead-but-over, etc., incl. watermelon (LO6) | sort | S, C | S |
| TCPI challenge: find the actual cost at which BAC is still achievable (AC <= EV = $186 000) (LO4) | challenge | S | S |

### 13 Closeout
| Idea | Type | Mode | Effort |
|---|---|---|---|
| ★ Continue or cancel with a sunk-cost distractor: net from here, break-even benefit (LO5) | check-number, twin | S, C | S |
| Seven closeout elements in order (LO2) | order | S | S |
| Termination types: scenarios to extinction / addition / integration / starvation (LO1) | sort | S, C | S |
| Relevant or sunk? cost items to "counts in the decision" / "ignore" (LO5) | sort | S, C | S |

### Across all chapters
| Idea | Type | Effort |
|---|---|---|
| Add an answer box to numeric Practice Problems (ch 2 P1, 3 P1, 6 P1-2, 7 P2, 8 P1-2, 9 P1/P3, 10 P2, 12 P1-2, 13 P1) with the existing solution unlocking after a check | check-number | S each; **uses the book's own numbers**, so no Brightspace twin |

Totals if all builds are done: about 52 exercises (23 sorters, 22 numeric or grid,
2 diagrams, 3 orderings), 6 challenges, 1 sandbox.

---

## 4. Build order

| Phase | Scope | Visible result |
|---|---|---|
| **3 Pilot** | Copy library; **chapter 6**: migrate the AON exercise to `tryit_diagram()` plus second network, PERT grid, rules sorter, crash challenge. Brightspace export for it. | Rendered ch 6 with 4 widgets; hand-written widget gone |
| 4a Classification pass | All sorters and orderings in ch 1 to 5, 7, 10, 12, 13 | Every chapter has at least one exercise |
| 4b Calculation pass | Number/grid exercises: ch 1, 2, 3, 5, 7, 8, 9, 10, 11, 12, 13 | Numeric practice with twins |
| 4c Challenges and sandbox | 5 remaining challenges, ch 8 Monte Carlo | Cards with goals |
| 4d Optional | Answer boxes on Practice Problems; choice-column and diagram extensions if not already needed | |

One branch, one commit per chapter, files staged by name, no push.
Checks listed in the brief (answer-key round-trip headless, challenge goals in
plain R over seeds, one real browser run per new card kind, recomputation of
checked questions, print render once per phase) run after every chapter; a
reusable test script goes in the scratchpad, not the repo.

---

## 5. Decisions (answered)

Answers: (1) ch 6 pilot; (2) replace the hand-written AON exercise with `tryit_diagram()`; (3) copy the library whole; (4) add dropdown columns (not yet built; needed from ch 9); (5) course code `MGMT-3105`; (6) four team data sets; four exercises per chapter. The original questions follow.


1. **Pilot chapter.** I recommend **ch 6**: it contains the hand-written
   exercise you want replaced and exercises the hardest widget. Cheaper
   alternative: ch 12 (EVM), which needs only grid, sorter and a challenge.
2. **Replace the hand-written AON exercise?** The plan does it (same data kept,
   plus a new network). Needs the derived-cell/node-marking extension, or accept
   the fallback (float as a blank, critical path as a separate sorter).
3. **Copy the whole library or only the types used?** Copying both files whole
   keeps them identical to the home copy and easy to carry back; unused types
   just come along.
4. **Choice columns** (ch 9) as a library extension, or three small sorters.
5. **Course code for twins**: I plan `MGMT-3105`, giving IDs like
   `MGMT-3105-TRYIT-<ID>-01`, next to your existing `MGMT-3105-CH06-1` style.
6. **Team seeds** (ch 6, 8, 11, 12): a seed/run-number argument on the R side so
   each team gets different data. Fine with that?
7. **Scope:** keep to 4 per chapter as above, or trim to 3.

---

## 6. Content issues noticed (all fixed in Phase 3)

1. **Ch 6 case-study table, activity G:** LS = 51 and LF = 56. With I's LS of 61
   the correct values are **LS 56, LF 61** (float 7 is right; the printed LS/LF
   would give 2).
2. **Ch 9 Practice Problem 3:** says total planned $63 250 and "$2 150 (3.4 %)
   over". The ABC table actually totals **$38 500** (4 000 + 8 000 + 4 000 +
   7 500 + 10 000 + 5 000), so the same $2 150 is **5.6 %**, which is what the
   code prints. 3.4 % matches 63 250.
3. **Ch 9 S-curve figure** totals $43 000 and its per-activity amounts differ
   from the ABC table (Design 13 000 vs 8 000, Plumb & wire 2 000 vs 5 000, ...)
   though both are described as the same six-activity project.
4. **Ch 3 NPV card:** defaults use uneven cash flows (180, 180, 180, 120, 90 k),
   giving NPV about **$109 660**, but the text just above says the flat-cash-flow
   NPV of **$198 860** is "exactly the project's NPV" for the same outlay and 12 %.
   The two numbers answer different cash flows.
5. **Ch 10 Practice Problem 2:** the buyer "will pay at most $95 000" but their
   BATNA is $98 000; by the chapter's own definition the reservation price is the
   BATNA ($98 000). The conclusion (no ZOPA, vendor floor $102 000) holds either way.
6. **Ch 13:** "Closing out the RC-vehicle project" says termination **by
   addition**; the Week 13 case study says "by integration, **not addition**" for
   the same project, and Problem 2 item 1 treats that scenario as addition.
7. **Ch 12 / 13 case study:** EAC is $797 901 (not "about $798 000"), so the margin
   under $800 000 is about $2 100, not the "$2 300" quoted in ch 13.
8. **Ch 4 situational-leadership card:** low competence with high commitment maps
   to "Coaching" and low/low to "Directing"; the usual Hersey-Blanchard mapping is
   the reverse for the enthusiastic beginner (Directing). It does match the Week 4
   case study, so it may be intentional.

Also verified while reading: ch 6 solved network (38 days, A-B-C-E-G-I-J), ch 6
Problem 1 (25 days), ch 8 worked example (mu 83.0, sigma 2.42), ch 9 Week 9 case
arithmetic ($761 300), ch 11 Week 11 weekly demand (mean 42.4), ch 12 Problem 1.

All eight were fixed on the branch, one commit per chapter. How:

1. Ch 6 case table: G row now LS 56, LF 61.
2. Ch 9 Problem 3: total planned $38 500, overrun 5.6 %.
3. Ch 9 S-curve: re-phased over Jan to Jun so it totals the ABC table's $38 500 per activity.
4. Ch 3 NPV card: cash flows now flat $180 000 x 5, so it gives the $198 860 the text quotes.
5. Ch 10 Problem 2: buyer's maximum is the BATNA ($98 000); gap is $4 000.
6. Ch 13: body and Problem 2 now say integration for the RC-vehicle team (as the case does); Problem 2 item 1 is a generic automaker example of addition.
7. Ch 13 case: margin "about $2 100".
8. Ch 4 situational card: low competence + high commitment is now Directing; low + low is Coaching (the standard readiness mapping). The Owen case reads consistently.

---

## 7. Phase 3: built (pilot, chapter 6)

**Library copied whole** from `../ProcessEngineering`: `R/tryit.R`, `js/tryit.js`,
the `.tryit-*` block of `style.css`, `goal`/`goal_test`/`rerun` in
`qwebr_calc_card()` (`R/helpers.R`, `js/qwebr-calculator.js`). The old `.aon-*`
CSS was removed.

**Additions to carry back to the Process Engineering book:**

- `tryit_diagram()`: `tryit_derived()` read-only cell (float = LS - ES, works
  itself out), `mark` / `mark_ids` (tick box per node, marked on Check), and
  `teams` (alternative data sets over the same edges, picked in the page or by
  `?team=N`). `js/tryit.js` was extended to match.
- `R/tryit_aon.R` (book-specific): `tryit_cpm()`, `tryit_vary()`,
  `tryit_aon()`: one declaration makes a complete AON exercise from a
  precedence table.
- CSS: `.tryit-team`, `.tryit-node-tick`, `.tryit-derived`.

**Chapter 6** now has four additions (the AON widget is replaced, not added to):

| Exercise | Type | Twin (different numbers) |
|---|---|---|
| Valid network or which rule it breaks (8 cards) | sort | yes, Matching |
| Forward/backward pass, renovation network, 4 data sets (set 3 moves the critical path) + critical-path ticks | fill-diagram | yes, product-launch network, Written Response with key |
| PERT t_e and SD by hand + chain total | fill-grid | yes, 2 Written Response/Short Answer |
| Crash challenge on the shift explorer: finish in 31 days or fewer | challenge | no (not a single answer) |

Notes: the planned "second network" became the four data sets (same network,
different durations); the Brightspace file is
`quizzes/tryit_06-Network-Diagrams-and-AON.csv` (gitignored, not yet imported).

**Verified:** headless Edge on the rendered page, every widget at each of the
4 data sets: exact key, rounded key, one wrong answer flagged, Reset clean,
console clean (`tryit_test.js`, kept in the session scratchpad). Challenge goal
in plain R: unmet at the defaults, met at B = 3, E = 3. Challenge card driven in a
real browser with webR: "Not yet" then "Reached". PDF render: worksheet and
solution, no raw HTML. Screenshots at 1300 px and 390 px.

**Not verified:** the Brightspace CSV has not been imported; the visual check of
a real student's flow is yours. The diagram is wide: on a 1300 px desktop the
last column needs a sideways scroll (the page says so), as in the home book.

**Rendering a PDF re-executes every chapter** and rewrites `_freeze/*/tex.json`
and figure PDFs; those changes were discarded, not committed.

---

## 8. Phase 4: built (chapters 1 to 13)

One commit per chapter on `interactive-exercises`. "Teams" = four data sets
(picker or `?team=N`). Every number/grid exercise and the AON/WBS diagrams
have a hidden twin with different numbers; every sorter and ordering has a
twin with different cards. Brightspace files: `quizzes/tryit_<chapter>.csv`
(gitignored; 6 to 10 questions each).

| Ch | Exercises (type; teams) | Challenge / sim |
|---|---|---|
| 1 | Material reduction by hand (number, teams); resin-code sorter; sustainability-checklist sorter | Whole-life cost: make "cheap" cheaper to own |
| 2 | Channels after a merger (number, teams); communication-method sorter; report-type sorter | Triple constraint: crossover defect probability |
| 3 | Discounted cash flow table (grid, teams); stakeholder-quadrant sorter; organizational-structure sorter | NPV below zero (finds the IRR) |
| 4 | Leadership-style sorter; Tuckman sorter; Herzberg sorter; expectancy by hand (number, teams) | |
| 5 | WBS roll-up tree (diagram, teams); outcome-or-action sorter; 100 % rule sorter; package-size sorter | |
| 6 | AON node boxes (diagram, teams; replaced hand-written widget); PERT by hand (grid); network-rules sorter | Crash to 31 days |
| 7 | Risk register EMV (grid, teams); response-strategy sorter; P-I zone sorter; FMEA rank with dropdown flag (grid, teams) | |
| 8 | Probability of finishing (grid + answers, teams); crash slopes (grid, teams); precedence-type sorter | Schedule Monte Carlo (simulation, run number = team) |
| 9 | Cost and variance by hand (number, teams); three-way cost labels (grid, dropdowns); estimating-method sorter; time-phased S-curve (grid, teams) | |
| 10 | ZOPA by hand (number, teams); resolution-method sorter; conflict-type sorter; weighted supplier scoring (grid, teams) | |
| 11 | Resource histogram (grid with dropdown, teams); leveling-order (ordering); priority-rule sorter; multitasking capacity (number, teams) | |
| 12 | Earned value by work package (grid, teams); EAC-formula sorter; status-quadrant sorter | TCPI: find the AC at which BAC is achievable |
| 13 | Termination-type sorter; closeout-elements ordering; sunk-or-relevant sorter; continue-or-cancel with uncertain benefit (number, teams) | |

Dropped from the proposal: ch 7 mitigation challenge, ch 9 budget challenge and
band numbers, ch 10 BATNA challenge and ch 13 reconciliation challenge (each
chapter was already at four exercises), and the Practice-Problem answer boxes
(phase 4d). The ch 6 "second network" became the four data sets. The ch 9
"which method / what band" was kept as the sorter only.

**Library additions this phase (carry back to Process Engineering):**

- `tryit_number()`: `given` and `teams` (the givens live in the card because
  they differ per team).
- `tryit_grid()`: `teams` (alternative data frames) and `choice` (dropdown
  columns; the cell holds the correct string).
- `js/tryit.js`: `choiceField()` and the given-values list; the data-set
  picker works for any builder.
- `.tryit-given`, `.tryit-cell select` CSS.

**Verified:**

- Headless Edge on every rendered chapter, at every data set: exact key,
  rounded key, a wrong answer flagged, Reset clean, console clean.
- Challenge goals run in plain R (default unmet, one solution met): ch 1, 2, 3,
  6, 8, 12. The ch 8 simulation over run numbers 1 to 12 with target day 88:
  met on 12 of 12, never met at the default.
- Cards driven in a real browser with webR: ch 6 crash challenge and the ch 8
  simulation ("Run again" changes the result; the goal flips to Reached).
- Every number quoted in the worked solutions recomputed from the givens
  (`verify.R` in the session scratchpad): all agree.
- Full-book PDF render: worksheets with blank cells and dropdown options, no raw
  HTML or script in the LaTeX.

**Not verified / yours:**

- The Brightspace CSVs have not been imported.
- No visual review beyond screenshots of the ch 5 and ch 6 diagrams.
- Wide diagrams (ch 5 tree, ch 6 network) need a sideways scroll on narrower
  screens; the page says so.
- Numbers in twins were checked against the same R functions as the on-page
  versions but not by a second person.

**Open:** whether to add the Practice-Problem answer boxes (phase 4d); whether
to keep the sorters' "why" text visible only after a correct card (as built).

---

## 9. Ch 6 AON exercise reverted

At the author's request the ch 6 node-box exercise is back to the original
hand-written widget (same HTML, inline script and `.aon-*` CSS as before this
work). The new ch 6 PERT grid, network-rules sorter and crash challenge stay.
`tryit_aon()` / the diagram extensions remain in the library, unused on the
page except for the hidden Brightspace twin (`quizzes/tryit_06-...csv`), which
is unchanged. The other chapters' diagram exercises (ch 5 WBS tree) are
unaffected.
