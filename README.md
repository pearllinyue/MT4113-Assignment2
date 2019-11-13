# Assignment 2
# Team D

## Team Members
+ Hendrik Walter, 150001088
+ Isabel Price, 140010552
+ Toluwa Rotibi, 160013082
+ Linyue (Pearl) Li, 180025784

## Task 1: Data exploration

![Fig1](https://github.com/pearllinyue/MT4113-Assignment2/blob/master/Figures/Age_length.png) 

![Fig2](https://github.com/pearllinyue/MT4113-Assignment2/blob/master/Figures/Frequency.png) 

Important points:

Many middle length fish, older (and longer) fish might have died already, there are fewer short and fewer long fish.
The range of all lengths is 14.35 and 89.96. 
The sample mean of the ages are initially: 21.44,42.11,67.01 and lambda 0.2 (age 1), 0.46 (age 2), 0.34 (age 3).
There are 100 data points with age classes and 900 without.
It seems that age 2 and age 3 are interleaved and more spread out than the lengths of age class 1. 

Exploring the data set, regarding the data availability, the range of lengths in the whole 
data with 1000 data points is (14.35, 89.96), however, the range for the measurements of known ages with 100 data
points are (14.35,86.97). Therefore, the range of known ages almost covers the whole range of lengths.
The previously mentioned means and lambda for each age class indicates that most fish are of age class 2 and from the histogram we can deduce that most lengths seem to be around the mean of age class 2. 
The Age vs Length plot suggests that age 2 and age 3 have a higher standard deviation, while age 1 is slightly more compact. Age 2 and 3 seem to be stronger interleaved. There appears to be one outlier to the top for every age class. For example, maximum length of an observed fish, age 1 is 31cm which is greater the minimum length of an observed fish of age 2 = 28.9cm



## Task 2: Methods description

The diagram starts from inputting the dataset of lengths of 1000 fish of which 100 has known age labels. These 100 rows of data were discussed in Task 1. Based on these 100 data points, we make an indicative estimation on the initial μ0, λ0 and σ0 of the three age distributions, which represents mean, variance and the proportion of observations of each group. This indicative estimation is also called E-Step and the implementation in the diagram is described as best.guess function.

Once these estimations are obtained, the algorithm proceeds into M-Step. M-Step contains three steps, including expectation, maximisation and likelihood evaluation in iterations until the estimation not changing.

The obtain.expectation function accepts the parameters from E-Step and computes the probability by using the Bayes Rule for each class k. Then in the maximise.parameters function, the new parameters μk, λk and σk are recalculated on the basis of the posterior probabilities above. Also, the likelihood.evaluation function computes the likelihood of new parameters. Finally, the log-likelihood obtained for these new parameters and stored for later comparison. In this step, the function also checks if the parameters meet any exit conditions are met. If not, this always returns to the obtain.expectation function; If so, the conditions can either be the number of iterations or a change in the likelihood smaller than the user defined epsilon. Once one of these conditions is met, the finalised parameters are returned to teamEM and finally returned to the user.

![Diagram](https://github.com/pearllinyue/MT4113-Assignment2/blob/master/Figures/flowchart1.png)



## Task 3: Algorithm implementation
This script contains the teamEM wrapper function. 

- [Code for implementing the EM algorithm](https://github.com/pearllinyue/MT4113-Assignment2/blob/master/Scripts/teamEM.R)

The set up, including best guesses, are in this file.

- [Set up](https://github.com/pearllinyue/MT4113-Assignment2/blob/master/Scripts/best_guess.R)

This script contains the maximisation function. 

- [Maximisation Function](https://github.com/pearllinyue/MT4113-Assignment2/blob/master/Scripts/maximisation.R)

The expecatation based on Bayes Theorem is calculated in this script.

- [Expectation](https://github.com/pearllinyue/MT4113-Assignment2/blob/master/Scripts/obtain_expectation.R)

The code to update the parameters of the normal distributions are contained in this script.

- [Parameter update](https://github.com/pearllinyue/MT4113-Assignment2/blob/master/Scripts/parameter_update.R)

This script contains one function to calculate the log likelihood.

- [Likelihood Calculation](https://github.com/pearllinyue/MT4113-Assignment2/blob/master/Scripts/likelihood.R)

And finally, all tests are included in this script.

- [Tests](https://github.com/pearllinyue/MT4113-Assignment2/blob/master/Scripts/tests.R)

Enhancements: allow user to specify which column contains the classes and the data. This enables the user to pass in a dataframe which contains other columns names.



## Task 4: Function testing
The simulation for datasets can be found below.

- [Simulation](https://github.com/pearllinyue/MT4113-Assignment2/blob/master/Scripts/dataset_simulation.R)

The testing function below creates a dataset 999 times with predefined parameters and checks if the results returned fall into the 95% interval.
- [Test](https://github.com/pearllinyue/MT4113-Assignment2/blob/master/Scripts/test_algorithm.R)



## Task 5: Results reporting

- The estimates returned by `teamEM()` 

| Parameter |   mu     |  sigma    | lambda     |
|-----------|----------|---------- |------------|
| Age 1     | 23.11271 | 3.852847  | 0.2019192  |
| Age 2     | 41.80995 | 5.629878  | 0.4526787  | 
| Age 3     | 66.86062 | 8.356780  | 0.3454021  | 

- The original data with the densities of the mixture components superimposed.  

![Hist_final](https://github.com/pearllinyue/MT4113-Assignment2/blob/master/Figures/hist_final.png) 



## Task 6: Work attribution

I confirm that this repository is the work of our team, except where clearly indicated in the text.
Due to issues with the lab computers much of our earlier work we worked on together but was uploaded to GitHub via Hendrik's computer, however, we feel the work load was spread equally to our abilities. 

Hendrik wrote the maximisation function, parameter update and best guess funciton along with the related documentation.  Linyue wrote the data simulation, the obtain expectation function and drew up our flow charts.  Isabel wrote the likelihood calculation function and the test file with related documentation.  Toluwa coded our plots, added input checking where needed and wrote up the reports.
We worked together closely throughout the project to create a consistent coding style throughout.

