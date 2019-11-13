library(ggplot2)

create.plots <- function(x){
  # Purpose function creates plots and prints results for the different aspects of the assignment.
  # Output: Plot Age vs Length
  #         Plot Histogram
  #         Plot Histogram with densities superimposed
  # Parameter: 
  #       x - the data in a data frame
  
  ggplot(data=x, aes(x$Length)) + geom_histogram()
  
  # Task 1 plots
  # Plot 1
  
  known <- x$Age[!is.na(x$Age)]
  knownl <- x$Length[!is.na(x$Age)]
  a <- mean(x$Length[x$Age == 1], na.rm = TRUE)
  b <- mean(x$Length[x$Age == 2], na.rm = TRUE)
  c <- mean(x$Length[x$Age == 3], na.rm = TRUE)
  q <- qplot(known, knownl, xlab="Age",ylab="Length in cm", main = "Age Vs Length")
  q + geom_segment(aes(x = 0.75, xend = 1.25, y = a, yend = a, col = "Mean Length")) +
    geom_segment(aes(x = 1.75, xend = 2.25, y = b, yend = b, col = "Mean Length")) +
    geom_segment(aes(x = 2.75, xend = 3.25, y = c, yend = c, col = "Mean Length"))
  
  # Plot 2
  ggplot(data=x, aes(x$Length)) + geom_histogram(aes(y =..density..),
                                                      breaks=seq(min(x$Length), max(x$Length), by = 2),alpha=0.8, col="black")+ 
    geom_density(aes(x=x$Length,col="Density")) + scale_colour_manual("", breaks = c("Density"),
                                                                      values = c("blue")) + labs(title="Density") + labs(x="Length in cm", y="Density") 
  # Plot 3
  ggplot(data=x, aes(x$Length)) + geom_histogram(breaks=seq(min(x$Length),
  max(x$Length), by = 2),alpha=0.8, col="black") + labs(title="Histogram for Length") +
    labs(x="Length in cm", y="Frequency") 

  
  
  # Task 5 plot
  x_axis <- seq(min(x$Length),max(x$Length),length=1000)
  y1 <- dnorm(x_axis, mean=mod$estimates$mu[1], sd=mod$estimates$sigma[1])
  y2 <- dnorm(x_axis, mean=mod$estimates$mu[2], sd=mod$estimates$sigma[2])
  y3 <- dnorm(x_axis, mean=mod$estimates$mu[3], sd=mod$estimates$sigma[3])
  ggplot(data=x, aes(x$Length)) + geom_histogram(aes(y =..density..),breaks=seq(min(x$Length), max(x$Length), by = 2), alpha=0.8, col="black")+ geom_line(aes(x=x_axis,y=y1, colour="Age 1"))+ geom_line(aes(x=x_axis,y=y2, colour="Age 2"))+ geom_line(aes(x=x_axis,y=y3, colour="Age 3"))+scale_colour_manual("", breaks = c("Age 1","Age 2","Age 3"),values = c("blue","red","green")) + labs(title="Histogram for Length") + labs(x="Length in cm", y="Count")
    
} 
