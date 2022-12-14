#' Compute the expected degree of representation for any group in a political body
#'
#' Finds the degree of expected representation for any group in a political body under a random sampling model (Gerring, Jerzak and Oncel, 2022+).
#'
#' @usage
#'
#' ExpectedRepresentation(PopShares, BodyN)
#'
#' @param PopShares A numeric vector containing the group-level population proportions.
#'
#' @param BodyN A positive integer denoting the size of the political body in question.
#'
#' @param a=-0.5,b=1 Parameters controlling the affine transformation for how the representation measure is summarized.
#' More precisely, `a` and `b` control how the expected L1 deviation of the population shares from the body shares
#' are re-weighted (the expected L1 deviation is multiplied by `a`; `b` is as an additive re-scaling term). By default,
#' `a=-0.5` and `b=1` so that the expected Rose Index of Proportionality is returned.
#'
#' @return The expected degree of representation (a scalar).
#' @export
#'
#' @examples
#'
#' ExpectedRep <- ExpectedRepresentation(PopShares = c(1/3, 2/3,1/3),
#'                                       BodyN = 50)
#'
#' print( ExpectedRep )
#'
#' @export
#'
#' @md

ExpectedRepresentation <- function(PopShares, BodyN, a = -1/2, b = 1){
  if(length(PopShares) > 1){
    theoretical_means_log <- log(2) +
      (BodyN - floor(BodyN*PopShares))*log(1 - PopShares) +
      (floor(BodyN*PopShares)+1)*log(PopShares) +
      log(floor(BodyN*PopShares)+1) +
      lchoose(BodyN,floor(BodyN*PopShares)+1)
    theoretical_means <- exp(  theoretical_means_log )
    theoretical_mean <- sum( theoretical_means / BodyN )
  }
  if(length(PopShares) == 1){theoretical_mean <- 0}
  if(abs(max(PopShares) - 1) < 10^(-10)){
    theoretical_means <- 2 * (1 - PopShares)^(BodyN - floor(BodyN*PopShares)) *
      PopShares^(floor(BodyN*PopShares)+1)*
      (floor(BodyN*PopShares)+1)*
      choose(BodyN,floor(BodyN*PopShares)+1)
    theoretical_mean <- sum( theoretical_means / BodyN )
  }
  return( a * theoretical_mean + b )
}
