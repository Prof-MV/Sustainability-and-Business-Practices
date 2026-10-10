# Activity-on-node exercises for tryit_diagram() (chapter 6).
#
# Book-specific, so it lives beside R/tryit.R rather than inside it: R/tryit.R
# stays identical to the Process Engineering copy.
#
#   tryit_cpm()   forward and backward pass over a precedence table
#   tryit_aon()   one declaration: fill in ES, EF, LS, LF on every node of a
#                 pre-drawn network, then tick the critical path

# Forward and backward pass. `acts` needs `id`, `dur` and `pred` (comma
# separated predecessor ids, "" for none), listed with predecessors first.
tryit_cpm <- function(acts) {
  ids <- acts$id
  preds <- strsplit(acts$pred, ",")
  preds <- lapply(preds, function(p) trimws(p[nzchar(trimws(p))]))
  n <- nrow(acts)
  ES <- EF <- LS <- LF <- stats::setNames(rep(NA_real_, n), ids)
  depth <- stats::setNames(rep(1, n), ids)
  for (i in seq_len(n)) {
    p <- preds[[i]]
    ES[i] <- if (length(p) == 0) 0 else max(EF[p])
    EF[i] <- ES[i] + acts$dur[i]
    if (length(p) > 0) depth[i] <- max(depth[p]) + 1
  }
  finish <- max(EF)
  for (i in rev(seq_len(n))) {
    succ <- ids[vapply(preds, function(p) ids[i] %in% p, logical(1))]
    LF[i] <- if (length(succ) == 0) finish else min(LS[succ])
    LS[i] <- LF[i] - acts$dur[i]
  }
  data.frame(id = ids, dur = acts$dur, ES = unname(ES), EF = unname(EF),
             LS = unname(LS), LF = unname(LF), float = unname(LS - ES),
             layer = unname(depth), stringsAsFactors = FALSE)
}

# A variant of `dur` for team `team` (1 = the durations as given). Each
# duration moves by -1, 0, +1 or +2 days, never below 1. Deterministic, and
# leaves the chapter's random-number stream alone.
tryit_vary <- function(dur, team, seed = 6) {
  if (team <= 1) return(dur)
  old <- if (exists(".Random.seed", envir = globalenv())) get(".Random.seed", envir = globalenv()) else NULL
  on.exit(if (!is.null(old)) assign(".Random.seed", old, envir = globalenv()))
  set.seed(1000 * seed + team)
  repeat {
    out <- pmax(1, dur + sample(c(-1, 0, 0, 1, 2), length(dur), replace = TRUE))
    if (any(out != dur)) return(out)
  }
}

# ES/EF/LS/LF nodes for a precedence table.
tryit_aon_nodes <- function(acts, unit = "d") {
  solved <- tryit_cpm(acts)
  ans <- function(label, value) tryit_answer(label, value, tol = 0, digits = 0)
  nodes <- lapply(seq_len(nrow(acts)), function(i) {
    tryit_node(
      acts$id[i], acts$id[i], solved$layer[i],
      sub = if ("desc" %in% names(acts)) acts$desc[i] else NULL,
      given = c(Duration = sprintf("%g %s", acts$dur[i], unit)),
      blank = list(ans("ES", solved$ES[i]), ans("EF", solved$EF[i]),
                   ans("LS", solved$LS[i]), ans("LF", solved$LF[i])),
      derived = list(tryit_derived("Float", "LS", "ES")))
  })
  list(nodes = nodes, critical = solved$id[solved$float == 0], finish = max(solved$EF))
}

#' An AON node-box exercise
#'
#' @param acts Precedence table: `id`, `dur`, `pred`, and optionally `desc`.
#' @param teams Number of data sets offered (set 1 is `acts` as given; the
#'   others change the durations, same network).
#' @param alt_dur Optional list of duration vectors for data sets 2, 3, ...
#'   (overrides `teams`). Use it to make sure one set moves the critical path.
#' @param seed Changes which variations the other data sets get.
#' @param question,show As for `tryit_diagram()`; a twin should be declared
#'   separately, with `show = FALSE` and a different table.
tryit_aon <- function(id, title, acts, teams = 4, seed = 6, intro = NULL,
                      question = NULL, show = TRUE, unit = "d", alt_dur = NULL) {
  stopifnot(all(c("id", "dur", "pred") %in% names(acts)))
  main <- tryit_aon_nodes(acts, unit)
  edges <- unlist(lapply(seq_len(nrow(acts)), function(i) {
    p <- trimws(strsplit(acts$pred[i], ",")[[1]])
    lapply(p[nzchar(p)], function(from) c(from, acts$id[i]))
  }), recursive = FALSE)

  if (!is.null(alt_dur)) teams <- length(alt_dur) + 1
  variants <- if (teams > 1) lapply(2:teams, function(t) {
    varied <- acts
    varied$dur <- if (is.null(alt_dur)) tryit_vary(acts$dur, t, seed) else alt_dur[[t - 1]]
    v <- tryit_aon_nodes(varied, unit)
    list(nodes = v$nodes, mark_ids = v$critical)
  })

  tryit_diagram(
    id, title, main$nodes, edges, direction = "right", arrows = TRUE,
    mark = "On the critical path", mark_ids = main$critical, teams = variants,
    intro = intro, question = question, show = show)
}
