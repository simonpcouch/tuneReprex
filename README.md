
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tuneReprex

A package to help minimally reproduce failures seen on
[tidymodels/finetune#50](https://github.com/tidymodels/finetune/pull/50).

On `devtools::test()`, I see:

    > devtools::test()
    ℹ Testing tuneReprex
    ✔ | F W S  OK | Context
    ✖ | 1 2     3 | tune [16.7s]                                                        
    ────────────────────────────────────────────────────────────────────────────────────
    Warning (test-tune.R:24): deprecated extract function (tune_race_win_loss)
    All models failed. Run `show_notes(.Last.tune.result)` for more information.
    Backtrace:
     1. finetune::tune_race_win_loss(...)
          at test-tune.R:24:2
     6. tune:::tune_grid.workflow(...)
     7. tune:::tune_grid_workflow(...)

    Error (test-tune.R:24): deprecated extract function (tune_race_win_loss)
    Error in `dplyr::filter(., .metric == metric)`: Problem while computing `..1 = .metric == metric`.
    Caused by error in `mask$eval_all_filter()`:
    ! object '.metric' not found
    Backtrace:
      1. finetune::tune_race_win_loss(...)
           at test-tune.R:24:2
      7. dplyr:::filter.data.frame(., .metric == metric)
      8. dplyr:::filter_rows(.data, ..., caller_env = caller_env())
      9. dplyr:::filter_eval(dots, mask = mask, error_call = error_call)
     11. mask$eval_all_filter(dots, env_filter)

    Warning (test-tune.R:39): deprecated extract function (tune_grid)
    All models failed. Run `show_notes(.Last.tune.result)` for more information.
    Backtrace:
     1. tune::tune_grid(wflow, folds, grid = 4, param_info = prm, control = finetune::control_race(extract = get_mod))
          at test-tune.R:39:2
     2. tune:::tune_grid.workflow(...)
     3. tune:::tune_grid_workflow(...)
    ────────────────────────────────────────────────────────────────────────────────────

    ══ Results ═════════════════════════════════════════════════════════════════════════
    Duration: 16.9 s

    [ FAIL 1 | WARN 2 | SKIP 0 | PASS 3 ]

For some reason, in the case of finetune (and seemingly only on some
operating systems), finetunes’s error handling infrastructure is tripped
up by the deprecation warning in:

``` r
get_mod <- function(x) workflows::pull_workflow_fit(x)
```

…but changing that line to something that will error, like:

``` r
get_mod <- function(x) silly_nonexistent_function(x)
```

…fixes the issue. Switching to `tune::tune_grid` fixes the issue, which
gives the usual “All models failed” warning.
