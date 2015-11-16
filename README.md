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
# Example raw data, sap flux density observations (g/m^2/s) from 0-2 cm in xylem, for a ring-porous tree over 13 days.
plot(egtree,type="b",ylab="Sap flux density (g/m^2/s")
egpred <- qtot(egtree, 0, 0.2, "Ring-porous", FALSE, 1, 0.255, NULL)
plot(egpred,type="l",ylab="Sap flow (g/s)")
```

### About

- Author: Aaron Berdanier (aaron.berdanier@gmail.com)
