context("earthtone")

## Need to do something nice here with testing?
test_that("returns normal", {
  expect_is(get_earthtones(),"palette")
})

test_that("test stop() errors", {
  expect_error(expr = earthtones::get_earthtones(method="42"), message = "method.*")
  expect_error(expr = if (!requireNamespace("cluster",quietly=TRUE)) {
    earthtones::get_earthtones(method="pam")
    } else {
      stop("method")
    },
    message = "method.*")
})
