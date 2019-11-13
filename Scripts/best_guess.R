best.guess <- function(data) {
  # Purpose: returns the best guess for mu, sigma and share of total population
  # Parameters:
  #   data - the data in a dataframe with column age and length
  # Returns  a data frame with categories and mu, sigma and share
  initial.values <-
    data.frame(mu = numeric(3),
               sigma = numeric(3),
               lambda = numeric(3))
  class.known <- data[!is.na(data$Age), ]
  
  # get initial parameters from the fish with known length
  attach(class.known)
  for (i in 1:3) {
    initial.values[i, ] <-
      c(mu=mean(Length[Age == i]), sigma=sd(Length[Age == i]),lambda=(length(Age[Age == i])) /
          length(Age))
  }
  detach(class.known)
  
  # get probabilities for membership of class for lengths of unkown lengths
  expectation <- obtain.expectation(data[is.na(data$Age), ]$Length,initial.values)
  assigned.class <- numeric(nrow(expectation))
  posterior <- expectation[,2:4]
  
  # select the highest probability as class membership
  for(i in 1:nrow(expectation)){
    assigned.class[i] <- which(posterior[i,]==max(posterior[i,]))
  }
  
  data_unkown_class <- data.frame(Length=expectation[,1],Age=assigned.class)
  # create data frame with values for mu, sigma and lambda
  attach(data_unkown_class)
  for (i in 1:3) {
    initial.values[i, ] <-
      c(mu=mean(Length[Age == i]), sigma=sd(Length[Age == i]),lambda=(length(Age[Age == i])) /
          length(Age))
  }
  detach(data_unkown_class)
  
  rownames(initial.values) <- c("Age1", "Age2", "Age3")
  
  return(list(inits = initial.values,data = data))
}
