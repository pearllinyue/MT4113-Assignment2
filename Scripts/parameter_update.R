update.parameters <- function(probabilities, parameters,observation){
  # Purpose: Updates the initially given parameters 
  # Parameters:
  #     probabilities - the probabilities of an observation belonging to component i
  #     parameters - the parameters to be updated
  #     observation - the observations of the sample
  # Returns: Updated parameters
  # solution and exentsion to the whole probelm: pass vector with name of category
  # classes and then we can factor out 
  
  for(i in 1:length(parameters$mu)){
    parameters$mu[i] <- mu.formula.update(probabilities[,i],observation)
    parameters$sigma[i] <-  sigma.formula.update(probabilities[,i],parameters$mu[i],observation)
    parameters$lambda[i] <- lambda.formula.update(probabilities[,i])
  }
  return(parameters)
}

mu.formula.update <- function(probability, observation){
  # returns a new estimate for a mu
  return(sum(probability*observation)/sum(probability))
}

sigma.formula.update <- function(probability, mu, observation){
  # returns a new estimate for a sigma based on mu
  numerator <- sum(probability*(observation-mu)**2)
  demoninator <- sum(probability)
  return(sqrt(numerator/demoninator))
}

lambda.formula.update <- function(probability){
  # returns a new estimate for the lambda of a class from all observations given the probabilities
  lambda <- sum(probability)
  return(lambda/length(probability))
}
