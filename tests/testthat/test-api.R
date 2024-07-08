test_that("basic GET functions works", {
  # 1. Ich erwarte dass es eine Tabelle ist (i.e. as dataframe)
  expect_equal(class(get_recorders()), "data.frame")

  # 2. ich erwarte dass die Tabelle inhalt hat (mehr als 0 row)
  expect_gt(nrow(get_recorders()),0)

  # 3. im Fall von get_recorders() erwarte ich mindestens, dass eine colname recorder_name ist
  expect_gt(sum(stringr::str_count(names(get_recorders()), "recorder_name")), 0) # sehr umstaendlich geloest (aber funktioniert)
})
#> Test passed

# hier auch wieder das problem wenn sich was aendert, also zb es den Rekorder nicht mehr gibt. Prob ich kann nicht einfach irgeinen rekorder nehmen
# vlt doch: vlt get_recorders()$recorder_name[1]
# zusaetzlich das prob, dass funktion ja daten updated und ich das eig beim testing nicht moechte, kommt hier mocking ins Spiel?
test_that("basic PATCH functions works", {
  dummy_recorder= get_recorders()$recorder_name[1]
  dummy_patch <- patch_recorders(recorder_name = dummy_recorder, description= "test")

  # 1. Erwartung: dass es auch wirklich ein PATCH ist
  expect_equal(dummy_patch$method, "PATCH")

  # 2. Erwartung: dass PATCH erfolgreich, i.e. status_code == 200
  expect_equal(dummy_patch$status_code, 200)
})
#> Test passed
