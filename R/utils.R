
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



nestList <- function(l){
  nosublevel <- Filter(function(e){length(e) == 1}, l)
  names(nosublevel) <- nosublevel
  sublevel <- Filter(function(e){length(e) > 1}, l)
  sublevelsLength <- Map(length, sublevel)
  if(all(sublevelsLength > 1)){
    first_levels <- unique(unlist(Map(function(e){e[[1]]}, sublevel)))
    sub_levels <- Map(function(level){
      #level <- first_levels[[2]]
      with_level <- Filter(function(e){e[[1]] == level}, sublevel)
      level_vals <- Map(function(e) e[-1],with_level)
      sublevel2 <- Filter(function(e){length(e) > 1}, level_vals)
      sublevel2_idx <- Filter(function(i){length(level_vals[[i]]) > 1}, seq_along(level_vals))
      names(sublevel2) <- level_vals[sublevel2_idx]
      nosublevel2 <- Filter(function(e){length(e) == 1}, level_vals)
      nosublevel2_idx <- Filter(function(i){length(level_vals[[i]]) == 1}, seq_along(level_vals))
      names(nosublevel2) <- level_vals[nosublevel2_idx]
      c(nosublevel2, sublevel2)
      #c(nosublevel2, nestList(sublevel2))
    }, first_levels)
    #return(sub_levels)
    return(c(nosublevel, sub_levels))
    #return(c(nestList(sub_levels)))
  }else{
    return(nosublevel)
  }
}
undotList <- function(x){
  l <- strsplit(x, "\\.")
  nestList(l)
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
