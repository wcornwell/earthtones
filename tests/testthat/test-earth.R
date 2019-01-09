context("earthtones")

## Need to do something nice here with testing?
test_that("returns normal", {
  if(packageDescription("ggmap")$Version == "2.7.900"){
  if(ggmap::has_goog_key()){
  expect_is(get_earthtones(),"palette")
  expect_is(get_earthtones(method="kmeans"),"palette")
  expect_null(print(get_earthtones()))
  expect_is(get_earthtones(include.map=FALSE),"character")
  expect_message(get_earthtones(sampleRate = 250))
  }
  }
})

test_that("test stop() errors", {
  expect_error(earthtones::get_earthtones(method="42"), message = "hello method.*")
  expect_error(if (!requireNamespace("cluster",quietly=TRUE)) {
    earthtones::get_earthtones(method="pam")
    } else {
      stop("method")
    },
    message = "method.*")
})
