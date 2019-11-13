likelihood.evaluation <- function(parameters, observation){
  # evaulates the likelihood across all parameters
  # Parameters: 
  #     parameters - a dataframe containing mu, sigma and lambda, representing 
  #     the different classes
  #     observation - the observation of the data to evaluate the parameters on
  # Returns: log likelihood across all parameters and age classes
  #     returns a vector of length n1. How to change that?
  
  temp <- 0
  for(i in 1:length(parameters$lambda)){
    temp <- temp+parameters$lambda[i]*dnorm(observation,parameters$mu[i],parameters$sigma[i])
  }
  return(sum(log(temp)))
}
