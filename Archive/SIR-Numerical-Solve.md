## ACKNOWLEDGEMENT

## WHAT IS IT?

This is a mathematical model that simulates the spread of infectious diseases using ordinary differential equations. Starting with a fixed number of infectious individuals, the disease will spread across a susceptible population until all infected individuals recover. In this model, we will only consider deterministic models of disease spread. The model is an example of a compartmental model and is useful for understanding the basic properties of infectious disease dynamics.

## HOW IT WORKS

Compartmental models can be used to simplify the mathematical modeling of infectious disease spread. In a compartmental model, individuals are assigned a compartment with labels and progress between the compartments. In this model, we use three compartments--Susceptible (S), Infectious (I) or Recovered (R). The SIR model is one of the simplest versions of an epidemiological compartmental model. 

Each individual in a population is assigned one of these three labels. When a susceptible individual comes into contact with an infectious individual, there is a certain probability that the susceptible individual catches the disease from the infectious individual. This probability is captured in the parameter β, the average number of contacts per person per time. Infectious individuals are able to infect susceptible individuals. After a certain period of time, an infectious individual is recovered from the disease and becomes a recovered individual. Recovered individuals are immune and unable to become infected again. The parameter mu, the recovery rate, governs the time period between Infectious and Recovered individuals. 

Starting with at least a single infectious contact, the model simulates the spread of the disease until all infected individuals are recovered. 

## HOW TO USE IT

Select a population size using the POPULATION slider. Select the number of initial infected individuals using the INITIAL-INFECTED slider. Select the number of initial recovered individuals using the INITIAL-RECOVERED slider. The minimum number of initial infected individuals is one. Select the value for β using the BETA slider. Select the value for mu using the MU slider. Press the GO button to run the model. 

## THINGS TO NOTICE

Starting at the initial time step, the number of infected individuals continues to increase until it reaches an inflection point and diminishes to zero. The time when there is the maximum number of infected individuals is typically called the peak of the outbreak. The timing of the peak is governed by beta, mu and the number of initial infected individuals. Since the model uses deterministic equations, the number of infected walkers can be fractional. More realistic simulations can be achieved via a stochastic model that allows beta and mu to fluctuate randomly.

## THINGS TO TRY

Try running the model and varying beta and mu. How does that impact the trajectory and timing of the outbreak? Are the values for beta and mu that cause the outbreak to not occur? The Reproductive number of an outbreak (R0) can be estimated by dividing beta by mu. What happens when R0<1? What happens at R0=1? What happens at R0>1? Similarly, try changing the number of initial infected and recovered individuals. How does that impact the trajectory and timing of the outbreak?

## EXTENDING THE MODEL

A more realistic simulation can be done using the stochastic version of the model where beta and mu are generated from a binomial distribution. This would more accurately simulate the random processes involved with disease outbreaks. Also, extending this model to propagate across a network would also increase its realism.

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