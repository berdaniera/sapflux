sapflux
=======

An R package for generating predictions of whole tree sap flow based on sap flux density observations.

Installation
------------

Installing the function for testing in R is easy:

```R
# install.packages("devtools")
devtools::install_github("berdaniera/sapflux")
```

Usage
-----

Usage is equally easy. Once installed, for an example, try:

```R
library(sapflux)
# Example raw data
# sap flux density observations (g/m^2/s) from 0-2 cm in xylem
# for a ring-porous tree over 13 days.
plot(egtree,type="b",ylab="Sap flux density (g/m^2/s")
egpred <- qtot(egtree, 0, 0.02, "Ring-porous", FALSE, 1, 0.255, NULL)
plot(egpred,type="l",ylab="Sap flow (g/s)")
```

The function for generating an estimate of whole-tree water use rates is `qtot`:

```R
qtot(v, a=0, b, woodType=c("Tracheid","Diffuse-porous","Ring-porous"), uncertainty=FALSE, nboot=5000, treeRadius, sapRadius=NULL)
```

Here `v` is the observed sap flux density observation, `a` and `b` are the start and end depths of the sap flux probe (in `m`), `woodType` is the xylem anatomy, `uncertainty` specifies whether to generate uncertainty estimates, `nboot` is the number of bootstrapped estimates for the uncertainty estimates, `treeRadius` is the radius of the tree (in `m`) and `sapRadius` is an optional depth of the sapwood (in `m`).


Uncertainty
-----------

Predictions with uncertainty are based on parameter uncertainty from the model fit to observations. In the 'qtot' function, assign 'uncertainty=TRUE'. This option takes samples from the multivariate posterior distribution for the shape parameters of the radial profile function (instead of using the posterior median). The resulting matrix has a column for each sample, which can be aggregated for calculating intervals:

```R
egpred_uncertainty <- qtot(egtree, 0, 0.02, "Ring-porous", TRUE, 1000, 0.255, NULL)
egpred_interval <- apply(egpred_uncertainty, 1, quantile, c(0.025,0.5,0.975))
plot(egpred_interval[3,], type="l", col="darkgrey", ylab="Sap flow (g/s)")
lines(egpred_interval[1,], col="darkgrey")
lines(egpred_interval[2,])
```

### About

- Author: Aaron Berdanier (aaron.berdanier@gmail.com)
