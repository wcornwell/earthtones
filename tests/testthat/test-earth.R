context("earthtone")

## Need to do something nice here with testing?
test_that("returns normal", {
  expect_is(get_earthtones(),"palette")
})
