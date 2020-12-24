## ACKNOWLEDGEMENT

## WHAT IS IT?

This model demonstrates a stochastic simulation of a compartment model Susceptible (S) -Infected (I)-Recover (R) model. Starting with a fixed number of infectious individuals, the disease will spread across a susceptible population until all infected individuals recover. The number of susceptible individuals eventually infected by an infectious individual was from a binomial distribution. The rate of getting infected for each individual at each time step was dependent on the total number of infectious people at that time step.
This model may be useful in understanding how diseases spread in a population. 

## HOW IT WORKS

Each individual in a population is assigned one of these three labels. When a susceptible individual comes into contact with an infectious individual, the probability that the susceptible individual catches the disease from the infectious individual varies with a binomial distribution. The rate at which an infectious individual is recovered from the disease also varies in a binomial distribution. The parameter beta governs the average probability of a susceptible catching the disease from the infectious population. Recovered individuals are immune and unable to become infected again. The parameter mu governs the average time period for an infectious individual to recover. The pandemic ends when there is no infectious individual in the population.
 

## HOW TO USE IT

Select a population size using the POPULATION slider. Select the number of initial infected individuals using the INITIAL-INFECTED slider. Select the number of initial recovered individuals using the INITIAL-RECOVERED slider. The minimum number of initial infected individuals is one. Select the value for β using the BETA slider. Select the value for mu using the MU slider. Press the GO button to run the model. 


## THINGS TO NOTICE

Starting at the initial time step, the number of infected individuals continues to increase until it reaches an inflection point and diminishes to zero. The time when there is the maximum number of infected individuals is typically called the peak of the outbreak. The timing of the peak is governed by beta, 

In general the stochastic SIR model follows the trends of the deterministic SIR model but with more fluctuations. 

Sometimes, the pandemic will not take off. Take a look at the ratio of beta/mu. When the ratio of beta/mu is smaller than 1, the pandemic is unlikely to reach a large portion of the population and dies out pretty fast. 



## THINGS TO TRY

Try running the model with 100 or 500 simulations, observe the plots of Susceptible, Infected, Recover population change with time, and also observe the plots of number of simulations with at least R number of recovered individuals against the R. 
Try running the model with different beta and mu values. Observe the plots of percentage of infectious individuals with time T.


## EXTENDING THE MODEL

Extend the model on networks and splitting the compartments for example splitting the Infectious compartment into Exposed-Infectious model. 


## RELATED MODELS

Stochastic Simulation of SIR Model

## NETLOGO FEATURES

[FIXME: Not sure what to add here]

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

Ravandi B et al. (2021). NetLogo Models for studying Dynamical Processes on Complex Networks, Northeastern University, Boston, MA.

Please cite the NetLogo software as:

Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 2008 Uri Wilensky.