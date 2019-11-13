source("Scripts/best_guess.R")
source("Scripts/likelihood.R")
source("Scripts/obtain_expectation.R")
source("Scripts/parameter_update.R")
source("Scripts/maximisation.R")
source("Scripts/Input Checks.R")

# The function
teamEM <- function(data,
                   epsilon = 1e-8,
                   maxit = 1000,
                   classcol = "Age",
                   datacol = "Length",
                   ID="FishID"){
  # Purpose: Use an expectation maximization algorithm to find estimates for unassigned data
  # Parameters:
  #     data - the data in a data frame
  #     epsilon - the distance of convergance
  #     maxit - the maximum iterations
  # Return: a list with estimates (data frame), inits(data frame), 
  # converged (boolean), posterior (data frame), likelihood (vector)
  
  arg.check(data,classcol,datacol,ID)
  # rename the columns to allow other column names
  if (classcol != "Age") {
    colnames(data)[colnames(data) == classcol] <- "Age"
  }
  if (datacol != "Length") {
    colnames(data)[colnames(data) == datacol] <- "Length"
  }
  # initialise the algorithm
  best.guess <- best.guess(data)
  # do M -the maximisation of the algorithm, given paramenters for the different components
  results <-
    maximise.parameters(
      inits = best.guess$inits,
      lengths = best.guess$data$Length,
      maxit = maxit,
      epsilon =  epsilon
    )
  # return list with all relevant information
  return(results)
}


