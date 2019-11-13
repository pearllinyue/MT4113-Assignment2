library(testthat)
source("Scripts/teamEM.R")
source("Scripts/dataset_simulation.R")

test_that("teamEM: Correct Return Columns", {
  # Purpose: Tests that all desired elements are part of the results dataframe from teamEM
  #         Note that this function just checks for existance of the correct columns
  maxit <- 2
  data_set <- simulate.dataset()
  results <- teamEM(data_set, maxit = maxit)
  list.names <- names(results)
  attach(results)

  # checks return type and existance of all the columns
  expect_that(results, is_a("list"))
  expect_true(is.element("estimates", list.names))
  expect_true(is.element("inits", list.names))
  expect_true(is.element("converged", list.names))
  expect_true(is.element("likelihood", list.names))
  expect_true(is.element("posterior", list.names))
  
  # checks that objects in list have the right attributes
  expect_that(estimates, is_a("data.frame"))
  expect_true(setequal(rownames(estimates), c("Age1", "Age2", "Age3")))
  expect_that(inits, is_a("data.frame"))
  expect_true(setequal(rownames(inits), c("Age1", "Age2", "Age3")))
  expect_that(converged, is_a("logical"))
  expect_that(posterior, is_a("data.frame"))
  expect_true(ncol(posterior) == 3)
  expect_that(likelihood, is_a("numeric"))
  
  # checks a low value of maxit is not exceeded and doesn't converge
  expect_true(length(likelihood) == maxit  )
  expect_false(converged)
  detach(results)
})

test_that("best_guess: check function", {
  # Purpose: Tests the output of best.guess function with a
  # simple data set.
  # Output: Nothing if tests pass, error messages if they fail
  
  observation <-
    data.frame(Age = c(1, 1,NA,NA, 2, 2,NA,NA, 3, 3,NA,NA),
               Length = c(10, 15,12,11, 20,25,22, 22, 330, 335,332,330))
  
  best_guess <- best.guess(observation)
  
  # check that mu is correct and only uses the values for NA
  expect_true(best_guess$inits$mu[1] == mean(c(11,12)))
  expect_true(best_guess$inits$mu[2] == mean(c(22,22)))
  expect_true(best_guess$inits$mu[3] == mean(c(332,330)))
  # check that sigma contains the sd
  expect_true(best_guess$inits$sigma[1] == sd(c(11,12)))
  expect_true(best_guess$inits$sigma[2] == sd(c(22,22)))
  expect_true(best_guess$inits$sigma[3] == sd(c(332,330)))
  # check that lambda contains correct value (1/3)
  expect_true(best_guess$inits$lambda[1] == 1 / 3)
  expect_true(best_guess$inits$lambda[2] == 1 / 3)
  expect_true(best_guess$inits$lambda[3] == 1 / 3)
  # checks that the column names are correct
  col.names <- colnames(best_guess$inits)
  expect_true("mu" %in% col.names)
  expect_true("sigma" %in% col.names)
  expect_true("lambda" %in% col.names)
  # checks that rownames are correct
  row.names <- rownames(best_guess$inits)
  expect_true("Age1" %in% row.names)
  expect_true("Age2" %in% row.names)
  expect_true("Age3" %in% row.names)
})

test_that("obtain_expectation: check function", {
  # Purpose: Tests the output of best.guess function with a
  # simple data set.
  # Output: Nothing if tests pass, error messages if they fail
  
  initial.values <-
    data.frame(
      mu = c(10, 20, 30),
      sigma = c(1, 2, 3),
      lambda = c(0.4, 0.4, 0.2)
    )
  observation <- c(11, 10, 20, 22, 30)
  prop.matrix <- obtain.expectation(observation, initial.values)
  # check that initial values are untouched but in matrix
  expect_true(setequal(prop.matrix[, 1], observation))
  # test that rest of entries are probabilities summing to one (or very close to it)
  expect_true(prop.matrix[, 2:4] > 0 && prop.matrix[, 2:4] < 1)
  expect_true(all(rowSums(prop.matrix[, 2:4]) > 0.99999) &&
                all(rowSums(prop.matrix[, 2:4]) < 1.000001))
})

test_that("obtain_expectation: check function", {
  # Purpose: update parameters
  # Output: Nothing if tests pass, error messages if they fail
  
  initial.values <-
    data.frame(mu = c(10, 20, 30), sigma = c(.8, 1.5, 0.8),
               lambda = c(0.4, 0.4, 0.2))
  observation <- c(11, 10, 20, 22, 30)
  prop.matrix <- obtain.expectation(observation, initial.values)
  # obtain parameters from test set
  parameters <-
    update.parameters(prop.matrix[, 2:4], initial.values, observation)
  
  # check that update brings it close to the true mean
  expect_true(mean(c(10, 11)) - 0.2 < parameters$mu[1] &&
                mean(c(10, 11)) + 0.2 > parameters$mu[1])
  expect_true(mean(c(20, 22)) - 0.2 < parameters$mu[2] &&
                mean(c(20, 22)) + 0.2 > parameters$mu[2])
  expect_true(mean(c(30)) - 0.2 < parameters$mu[3] &&
                mean(c(30)) + 0.2 > parameters$mu[3])
  
  # check that it is close to the true mean
  # sd produces sample sd
  expect_true(sd(c(10, 11)) * (sqrt((length(
    c(10, 11)) - 1) / length(c(10, 11)))) - 0.02 < parameters$sigma[1] &&
    sd(c(10, 11)) * (sqrt((length(c(10, 11)) - 1) / length(c(10, 11)))) 
    + 0.02 > parameters$sigma[1])
  
  expect_true(sd(c(20, 22)) * (sqrt((length(c(20, 22)) - 1) / 
                              length(c(20, 22)))) - 0.02 < parameters$sigma[2] &&
  sd(c(20, 22)) * (sqrt((length(c(20, 22)) - 1) / length(c(20, 22)))) +
    0.02 > parameters$sigma[2])
  # last population only size 1
  expect_true(0 - 0.02 < parameters$sigma[3] &&
                0 + 0.02 > parameters$sigma[3])
  
  # check that it is close to the true lambda
  expect_true(0.4 - 0.01 < parameters$lambda[1] &&
                0.4 + 0.01 > parameters$lambda[1])
  expect_true(0.4 - 0.01 < parameters$lambda[2] &&
                0.4 + 0.01 > parameters$lambda[2])
  expect_true(0.2 - 0.01 < parameters$lambda[3] &&
                0.4 + 0.01 > parameters$lambda[3])
  
})

test_that("likelihood evaluation: check function", {
  # Purpose: update parameters
  # Output: Nothing if tests pass, error messages if they fail
  
  data_set <- simulate.dataset()
  results <- teamEM(data_set)
  
  # likelihood should change and become slightly bigger every time
  for (i in 1:(length(results) - 1)) {
    expect_true(results$likelihood[i + 1] - results$likelihood[i] > 0)
  }
})

