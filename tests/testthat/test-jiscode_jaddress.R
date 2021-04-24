test_that("Test if the correct JIS code returns the name of the prefecture, city, and town.", {
  expect_equal(jiscode_jaddress("39201"),
               "\u9ad8\u77e5\u770c\u9ad8\u77e5\u5e02")
  expect_equal(jiscode_jaddress("20413"),
               "\u9577\u91ce\u770c\u5929\u9f8d\u6751")
  expect_equal(jiscode_jaddress("20413", jis = "city"),
               "\u5929\u9f8d\u6751")
  expect_equal(jiscode_jaddress("20413", jis = "pref"),
               "\u9577\u91ce\u770c")
  expect_equal(jiscode_jaddress("20"),
               "\u9577\u91ce\u770c")
  expect_equal(jiscode_jaddress("20", jis = "city"),
               as.character(NA))
})

test_that("Test the return of a warning message when an incorrect JIS code is entered.", {
  expect_warning(jiscode_jaddress("1"),
                 "Please enter the JIS code as a 2-digit, 5-digit, or 6-digit value.")
  expect_warning(jiscode_jaddress("\uff10\uff11"),
                 "JIS codes are only accepted if they consist of only half-width numbers.")
})
