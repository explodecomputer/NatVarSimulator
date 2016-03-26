# Natural genetic variation simulator

## To run

In R simply type:

```r
shiny::runGitHub("explodecomputer/NatVarSimulator")
```

and it should open up in a browser.

### Dependencies

You may first need to get required packages:

```r
package_list <- c("shiny", "googleVis", "ggplot2", "reshape2")
required_packages <- package_list[!(package_list %in% installed.packages()[,"Package"])]
if(length(required_packages)) install.packages(required_packages)
```



## Background

This is a simple simulation of how natural genetic variation can arise in populations. A base population is generated with a specified number if individuals who have genomes of some number of unlinked markers. 

The simulator then introduces mutations at a specified mutation rate, and based on the effect of each marker on the fitness of the individual will create new generations through stochastic sampling.

The trajectory of allele frequencies over the course of generations can then be tracked.