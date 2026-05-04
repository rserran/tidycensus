test_that("variables_from_table_decennial matches underscore tables for 2020 special files", {
  local_mocked_bindings(
    load_variables = function(year, dataset, cache) {
      data.frame(
        name = c("T03001_001N", "T03001_002N", "T03001001"),
        label = NA_character_,
        concept = NA_character_
      )
    }
  )

  expect_equal(
    variables_from_table_decennial("T03001", 2020, "ddhcb", TRUE),
    c("T03001_001N", "T03001_002N")
  )

  expect_equal(
    variables_from_table_decennial("T03001", 2020, "sdhc", TRUE),
    c("T03001_001N", "T03001_002N")
  )
})
