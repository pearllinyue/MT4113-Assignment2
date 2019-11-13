library(mixtools)
test.algorithm <- function() {
  # Purpose: simulate 999 data sets and run teamEM on each of those datasets.
  #         Tests if correct mu and sigma was found 95% of the time
  # Parameters: NA
  # Returns: NA
  
  #  create the initial properties
  properties <-
    list(
      n = c(200, 300, 400),
      mu = c(10, 40, 60),
      sigma = c(4, 5, 2),
      remove = 4
    )
  data <-
    simulate.dataset(
      n = properties$n,
      mu = properties$mu,
      sigma = properties$sigma,
      remove = properties$remove
    )
  
  # create matrix to store estimates
  dev_mus <- matrix(ncol = 3, nrow = 999)
  dev_sigmas <- matrix(ncol = 3, nrow = 999)
  
  # generate data and implement EM algorithm 999 times
  for (i in 1:999) {
    data <-
      simulate.dataset(
        n = properties$n,
        mu = properties$mu,
        sigma = properties$sigma,
        remove = properties$remove
      )
    results <- teamEM(data)
    dev_mus[i, ] <- results$estimates$mu
    dev_sigmas[i, ] <- results$estimates$sigma
  }
  
  # find quantiles and compare them with the initial properties of the distributions
  for (i in 1:3) {
    mu.quantiles <- quantile(dev_mus[, i], c(0.025, 0.975))
    mu.lower <- mu.quantiles[1]
    mu.upper <- mu.quantiles[2]
    # check if initial value is in the interval
    print(paste(
      "Mu in range: ",
      mu.lower < properties$mu[i] && mu.upper > properties$mu[i]
    ))
    
    sigma.quantiles <- quantile(dev_sigmas[, i], c(0.025, 0.975))
    sigma.lower <- sigma.quantiles[1]
    sigma.upper <- sigma.quantiles[2]
    # check if initial value is in the interval
    print(
      paste(
        "Sigma in range: ",
        sigma.lower < properties$sigma[i] &&
          sigma.upper > properties$sigma[i]
      )
    )
  }
}

comparison.R.function <- function(x){
  # Purpose function compares teamEM with the R function normalmixEM.
  # Output: a mark out of three comparing results
  # Parameter: 
  #       x - the data in a data frame
  data <- x$Length
  mod <- teamEM(x, epsilon = 1e-08, maxit = 1000)
  mixmod <- normalmixEM(x$Length, mu = mod$inits$mu,
                        sigma = mod$inits$sigma,
                        lambda = mod$inits$lambda,
                        epsilon = 1e-08, maxit = 1000)
  mark <- 0
  mark <- mark + (max(abs(mod$estimates$mu - mixmod$mu)) < 0.2)
  mark <- mark + (nrow(mod$posterior) == length(data))
  mark <- mark + (max(abs(mod$likelihood[length(mod$likelihood)] - mixmod$loglik)) < 0.01)
  print(paste("mark",mark))
}
