test_that("Test whether the correct JIS code code is returned when an address is entered.", {
  expect_equal(jaddress_jiscode("\u6771\u4eac\u90fd\u65b0\u5bbf\u533a\u897f\u65b0\u5bbf\uff12\u4e01\u76ee\uff18\u2212\uff11"),
               "13104")
  expect_equal(jaddress_jiscode("\u6771\u4eac\u90fd\u65b0\u5bbf\u533a\u897f\u65b0\u5bbf\uff12\u4e01\u76ee\uff18\u2212\uff11", jis = "pref"),
               "13")
  expect_equal(jaddress_jiscode("\u5317\u6d77\u9053\u6a3a\u6238\u90e1\u6708\u5f62\u753a1219\u756a\u5730"),
               "01430")
  expect_equal(jaddress_jiscode("\u79cb\u7530\u770c\u79cb\u7530\u5e02"),
               "05201")
  expect_equal(jaddress_jiscode("\u9ce5\u53d6\u5e02"),
               "31201")
  expect_equal(jaddress_jiscode("\u57fc\u7389\u770c"),
               "11000")
  expect_equal(jaddress_jiscode("\u57fc\u7389\u770c", jis = "pref"),
               "11")
  expect_equal(jaddress_jiscode("\u6c96\u7e04\u770c\u90a3\u8987\u5e02", check.digit = TRUE),
               "472018")
})

test_that("Testing the handling of unacceptable input.", {
  expect_warning(jaddress_jiscode("\u7f8e\u91cc\u753a"),
                 "It seems that the address was not narrowed down to a single jis code or was not in a searchable format.")
  expect_warning(jaddress_jiscode("\u6771\u4eac\u65b0\u5bbf"),
                 "The address is not in a searchable form for jis codes.")
  expect_warning(jaddress_jiscode("\u6c96\u7e04\u770c\u5449\u5e02"),
                 "It seems that the address was not narrowed down to a single jis code or was not in a searchable format.")
})
