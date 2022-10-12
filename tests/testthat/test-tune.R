set.seed(2332)

folds <- rsample::vfold_cv(mtcars, v = 5, repeats = 2)

spec <-
  parsnip::decision_tree(cost_complexity = tune::tune(), min_n = tune::tune()) %>%
  parsnip::set_engine("rpart") %>%
  parsnip::set_mode("regression")

wflow <-
  workflows::workflow() %>%
  workflows::add_model(spec) %>%
  workflows::add_formula(mpg ~ .)

grid <- expand.grid(cost_complexity = c(0.001, 0.01), min_n = c(2:5))

prm <-
  workflows::extract_parameter_set_dials(wflow) %>%
  update(min_n = dials::min_n(c(2, 20)))

test_that("deprecated extract function (tune_race_win_loss)", {
  get_mod <- function(x) workflows::pull_workflow_fit(x)

  wl_rec <-
    finetune::tune_race_win_loss(
      wflow,
      folds,
      grid = 4,
      param_info = prm,
      control = finetune::control_race(extract = get_mod)
    )

  expect_true(inherits(wl_rec, "tune_results"))
})

test_that("deprecated extract function (tune_grid)", {
  get_mod <- function(x) workflows::pull_workflow_fit(x)

  wl_rec <-
    tune::tune_grid(
      wflow,
      folds,
      grid = 4,
      param_info = prm,
      control = finetune::control_race(extract = get_mod)
    )

  expect_true(inherits(wl_rec, "tune_results"))
})

test_that("unexported extract function", {
  get_mod <- function(x) tune::pull_workflow_fit(x)

  wl_rec <-
    finetune::tune_race_win_loss(
      wflow,
      folds,
      grid = 4,
      param_info = prm,
      control = finetune::control_race(extract = get_mod)
    )

  expect_true(inherits(wl_rec, "tune_results"))
})

test_that("well-defined extract function", {
  get_mod <- function(x) workflows::extract_fit_parsnip(x)

  wl_rec <-
    finetune::tune_race_win_loss(
      wflow,
      folds,
      grid = 4,
      param_info = prm,
      control = finetune::control_race(extract = get_mod)
    )

  expect_true(inherits(wl_rec, "tune_results"))
})
