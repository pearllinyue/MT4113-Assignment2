###############################################
#### Testing functions - Task 4 ###############
###############################################
simulate.dataset <- function(n=c(200,300,400),mu=c(10,40,60),sigma=c(4,5,2),remove=4){
  # Purpose: simulates a dataset with three different age classes, different lengths based on three different distributions for the
  # purpose of testing the accuracy of the teamEM function to find the true parameters
  # Parameters:
  #     n - vector of length three specifying how many samples for each sample should be created
  #     mu - vecotr of length three, specifying the different mus
  #     sigma - vector of length three, specifying the different sigma values
  #     remove - lambda of the datasets to replce, 4 mus 1/4 of the values are replaced with NA
  # Returns: a data set originating from three different distributions with some Age values set to NA

  dataset1 <- data.frame(FishID = seq(1, n[1], by = 1), Length=rnorm(n[1], mu[1], sigma[1]), Age=1)
  dataset2 <- data.frame(FishID = seq(n[1] + 1, sum(n[1:2]), by = 1), Length=rnorm(n[2], mu[2], sigma[2]), Age=2)
  dataset3 <- data.frame(FishID = seq(sum(n[1:2]) + 1, sum(n), by = 1), Length=rnorm(n[3], mu[3], sigma[3]), Age=3)
  dataset1$Age[1:ceiling(n[1]/remove)] <- NA
  dataset2$Age[1:ceiling(n[2]/remove)] <- NA
  dataset3$Age[1:ceiling(n[3]/remove)] <- NA
  
  return(rbind(rbind(dataset1,dataset2),dataset3))
}
