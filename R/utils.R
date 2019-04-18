
selectInList <- function(l,strs){
  str <- strs[1]
  ll <- NULL
  try({ll <- l[[str]]},silent=TRUE)
  #message(str(ll))
  if(is.null(ll)) return(strs)
  if(is.list(ll)){
    strs <- strs[-1]
    return(selectInList(ll,strs))
  }else{
    return(ll)
  }
}


`%||%` <- function (x, y)
{
  if (is.empty(x))
    return(y)
  else if (is.null(x) || is.na(x))
    return(y)
  else if (class(x) == "character" && nchar(x) == 0)
    return(y)
  else x
}

is.empty <- function (x){
  !as.logical(length(x))
}
