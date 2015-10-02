#' Incomplete gamma function

incgma <- function(a,x) pgamma(x,a)*gamma(a)

#' Radial integral function
#' 
#' This function supports Qtot

Qc <- function(R,S,a,b,alp,bet){
  # no sapwood depth indicated, integrate over entire profile
  if(is.null(S)) Scoef <- ( R*incgma(alp+1,bet*R)/bet - incgma(alp+2,bet*R)/(bet^2) ) 
  # else, integrate over sapwood area
  else Scoef <- ( R*incgma(alp+1,bet*S)/bet - incgma(alp+2,bet*S)/(bet^2) )
  
  Scoef / ( 
    ( R*incgma(alp+1,bet*b)/bet - incgma(alp+2,bet*b)/(bet^2) ) - 
      ( R*incgma(alp+1,bet*a)/bet - incgma(alp+2,bet*a)/(bet^2) )
  )
}

#' Sap flux scaling
#' 
#' This function generates predictions of whole tree sap flow based on sap flux density observations.
#' @param v sap flux density observations \eqn{(g / m^2 / time)}
#' @param a distance from cambium (in \eqn{m}) for outer end of sap flux probe (default = 0)
#' @param b distance from cambium (in \eqn{m}) for inner end of sap flux probe
#' @param woodType xylem type for radial profile selection
#' @param uncertainty estimate with uncertainty (\code{TRUE}) or use mean parameters (\code{FALSE}, default)
#' @param nboot number of draws from posterior distribution to use for prediction
#' @param treeRadius tree radius minus bark (in \eqn{m})
#' @param sapRadius sapwood depth (in \eqn{m}) (optional)
#' @return The integral of sap flux density throughout a tree trunk. Output is a matrix of predictions (number of observations x number of bootstrap samples). If "uncertainty" is \code{FALSE}, returns a vector of mean values.
#' @examples 
#' qtot(egtree, 0, 0.02, "Ring-porous", FALSE, 1, 0.0255, NULL)

qtot <- function(v, a = 0, b, 
                 woodType = c("Tracheid","Diffuse-porous","Ring-porous"), 
                 uncertainty = FALSE, nboot = 5000,
                 treeRadius, sapRadius = NULL){
  
  # check if any sapwood depth estimates are NA
  if(!is.null(sapRadius)) if(any(is.na(sapRadius))) sapRadius[which(is.na(sapRadius))] <- treeRadius[which(is.na(sapRadius))]
  
  wt <- which(rownames(postmu)==woodType)
  if(uncertainty){
    boots <- mvtnorm::rmvnorm(n = nboot, mean = postmu[wt,], sigma = postcov[[wt]]) # draws from posterior distributions    
  }else{
    boots <- t(matrix(postmu[wt,]))
  }
  cfac <- Qc(treeRadius, sapRadius, a, b, boots[,1], boots[,2]) # correction factors
  Ameas <- pi*treeRadius^2 - pi*(treeRadius-b)^2 # measurement area (m^2)
  (v*Ameas)%*%t(cfac) # predicted matrix (nobs x nboot)
}
