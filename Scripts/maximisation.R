maximise.parameters <- function(inits, lengths,maxit,epsilon){
  # Purpose: Updates the given parameters through categorising the data given.
  # Iterates through the data and stops once parameters are sufficiently converged
  # Parameters:
  #     inits - the
  #     data - the data in a dataframe
  #     maxit - the maximum number of iterations
  #     epsilon - desired level on convergence
  # Prints the number of iterations
  # Returns: a list with the maximised parameters, boolean converged and initial estimates
  
  estimates <- inits
  i <- 1
  likelihood <- numeric()
  converged = FALSE
  
  # repreats the maximasation until epsilon is bigger than difference
  # or maximum number of iterations is reached
  repeat{
    probability.matrix <- obtain.expectation(lengths,estimates)
    estimates <- update.parameters(probabilities = probability.matrix[,2:4],estimates,lengths)
    likelihood[i] <- likelihood.evaluation(estimates,lengths)

    if(i>1&& abs(likelihood[i]-likelihood[i-1])<epsilon){
      converged=TRUE
      break
    }
    
    if(i==maxit){
      break
    }
    i <- i+1
  }
  
  print(paste("Number of iterations=",i)) #check number of interations
  return(list(estimates=estimates,inits=inits,converged=converged,
          likelihood=likelihood,posterior=data.frame(probability.matrix[,2:4])))
  
}
