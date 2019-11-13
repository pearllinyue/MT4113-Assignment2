arg.check <- function(data,classcol,datacol,ID) {
  #Purpose: Test the data that is provided to make sure that the information 
  #needed is provided
  #Inputs: 
  # data - data from the dataframe
  # classcol - the column with the ages from the data
  # datacol - the column with the length values from the data
  
  #Negate in %in% function so we want to check if x is not in y
  '%ni%' <- function(x,y)!('%in%'(x,y))
  
  #check if we have at least 3 columns in the data Eg at least FishID, Length and Age
  if (ncol(data) < 3){
    stop("Invalid Arguments")
  }
  
  #check if the namesof the columns in the data correspond to the informatio needed
  if ((ID %ni% colnames(data)) | (datacol %ni% colnames(data)) | (classcol %ni% colnames(data))) {
    stop("Invalid Arguments, make sure data is accurate")
  }

  if(length(unique(data[!is.na(data[,classcol]),classcol]))!=3){
    stop("Not 3 Classes")
  }
  
  #check that the information in the dataframe is numeric
  if (isFALSE(all(sapply(data, is.numeric)))) {
    stop("Non-numeric data present")
  }
  
  #removes any rows where the information in any column apart from Age/classcol is NA
  if (isTRUE(anyNA(c(data[,ID], data[,datacol])))) {
    stop("Invalid information in data")
  }
}
