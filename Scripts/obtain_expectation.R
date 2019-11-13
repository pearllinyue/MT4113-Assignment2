obtain.expectation <- function(observation,component){
  # Purpose: calculates the expecatation that observation belongs to component
  # Parameters:
  #     observation - the observation as a vector
  #     component - the different classes 
  # Returns: A matrix with rows for each length observation and columns for each age class
  
  probability.matrix <-  cbind(as.matrix(observation),get_bayes(observation,component))
  return(probability.matrix)
}

get_bayes <- function(observation, component){
  # Purpose: calculates the probability that the fish length is part of the obversation class
  # Parameters:
  #     component - the distribution parameters in a data fram
  #     fish.length - the fish lengths for which the probability is calculates 
  # Returns: A matrix with rows for each length observation and columns for each age class
  # calculates the density for each of the observations
  
  mu <- component$mu
  sigma <- component$sigma
  lambda <- component$lambda
  
  g1 <- dnorm(observation,mu[1],sigma[1])*lambda[1]
  g2 <- dnorm(observation,mu[2],sigma[2])*lambda[2]
  g3 <- dnorm(observation,mu[3],sigma[3])*lambda[3]
  
  # standardize
  
  g <- g1+g2+g3
  p1 <- g1/g
  p2 <- g2/g
  p3 <- g3/g
  
  return(matrix(c(p1,p2,p3),ncol = 3))
}
