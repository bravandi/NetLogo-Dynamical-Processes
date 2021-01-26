## ACKNOWLEDGEMENT

## WHAT IS IT?

This model demonstrates a deterministic simulation of a simple random walk process. Individuals move from one node to another depending on a fixed diffusion probability. This phenomenon also depends on the degree of the neighboring nodes.
This model may be useful in understanding the basic properties of dynamic processes on networks and can be extended to a stochastic version. 

## HOW IT WORKS

For a given random network, a certain number of walkers are placed on a random node. Then temporal recursive equations are used compute the number of walkers at every node in the graph. There are two components of the random walk for a given node. The OUT component considers some walkers move out of a node with a fixed predefined probability. The IN component adds up all the walkers coming from the neighboring nodes. Walkers move out of the neighboring nodes with the same diffusion probability and gets distributed uniformly across all the links connected to it.
In the visualization, size of a node at each time stamp is proportional to the number of walkers on it. 

At t time step, the number of walkers on node i is derived using the following equation:

![Equation 1](https://github.com/bravandi/NetLogo-Dynamical-Processes/blob/master/Images/Equation_1.PNG)

where,
p = diffusion probability, and
A = Adjacency matrix

The diagrams below show the NetLogo frontend at the beginning and at the end of the random walk process:

Below we have a BA graph with 180 nodes. 600 walkers are placed across 8 nodes, which are larger in size in the intiial layout below. 

![Initial Circular Layout](https://github.com/bravandi/NetLogo-Dynamical-Processes/blob/master/Images/Initial_circular_layout.PNG)

After the completion of the random walk process, the walkers spread across different degree nodes. The higher degree nodes get more walkers, as we see that the blue colored nodes (higher degree bin) are larger in size.

!Equillibrium Circular Layout](https://github.com/bravandi/NetLogo-Dynamical-Processes/blob/master/Images/Equilibrium_circular_layout.PNG)

## HOW TO USE IT

Choose the size of network that you want to model using the NODE-COUNT slider. Choose the expected density of links in the network using the LINK-COUNT slider.
To create the Erdős–Rényi network with these properties, press SETUP.
The TOTAL-WALKERS slider controls how many walkers needs to be placed on a random node to begin the process. 
Press the GO button to run the model.
The number of walkers for a given input degree node is also visualized over time. 

## THINGS TO NOTICE

Over time, the number of walkers on each node saturates. The final steady-state value of walkers depends on the degree of a node. 
Irrespective of whether the initial walkers are concentrated on a single node or distributed across multiple nodes, same steady state is achieved for all the nodes. 

Colorirng of the nodes is based on their degrees. There are three coloring schemes in this models:

a. random: Nodes are colored randomly irrespective of their degrees.

b. degree single-gradient: Different shades of the same color (here it is blue) is used to distinguish between high and low degree nodes. 

c. degree bin multi-gradient: The nodes have been divided into 5 bins based on their degrees. Blue nodes have the highest degrees, whereas the pink nodes correspond to the lowest degree group (hierarchy of the colors is: Blue> Green > Yellow > Brown > Pink). Within each bin, gradients represent degree variations.  

Color of a node represents its degree, whereas its size corresponds to the number of walkers on it.  

Since this model uses deterministic equations, the number of walkers can be fractional. More realistic simulation can be achieved via the stochastic model.

### Nodes Color Coding

Node colors are determined based on the degree quartile they belong to within the network's degree distribution. 
The higher degree a node has, the darker it color is. 

![Figure nodes color code](https://github.com/bravandi/NetLogo-Dynamical-Processes/blob/master/Images/Color_Code_for_Node_Degree.png)

## THINGS TO TRY

Try running the model with a fixed number of nodes and links. Observe the plots for different degree nodes. Try increasing the number of nodes and links and observe when the number of walkers on a node starts saturating. Try the simulations by placing all the walkers on a single node and distributing the walkers across multiple nodes initially.

## EXTENDING THE MODEL

A more realistic simulation can be done using the stochastic version of the random walk model. Instead of multiplying the diffusion probability to get the number of walkers diffusing from a node at a given instance, an integer number is chosen based on multinomial distributions. This shows similar temporal behavior of the number of walkers across all the nodes with noise added on the trend seen in the deterministic model.

## RELATED MODELS

Stochastic Random Walk

## NETLOGO FEATURES

This model can be simulated on different network architectures beyond the Erdős–Rényi graphs. Integration of this deterministic model with small world and Barabási–Albert network models shall allow the users to study the effects of network architecture and degree distribution on the random walk process.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

TBD (2020). NetLogo Models for studying Dynamical Processes on Complex Networks, Northeastern University, Boston, MA.

Please cite the NetLogo software as:

Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 2008 Uri Wilensky.
