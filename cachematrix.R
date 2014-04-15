## Submission by Gauden Galea 15 April 2014 
## https://github.com/ggData/ProgrammingAssignment2/blob/master/cachematrix.R

## Calculating the inverse of a matrix can be expensive. 
## Two functions are presented here that create a matrix-like
## object able to store its own value, as well as its inverse.
## Thus, once the inverse is found, repeated calls to solve
## its inverse will simply return the stored value.
##
## Neither of these functions does any error checking. Its is up
## to the user to only pass in a matrix with a valid inverse
## 
## A test page for these functions is presented at:
## https://github.com/ggData/ProgrammingAssignment2/blob/master/speedtest_cachematrix.md
## It illustrates how these functions can be used and the
## dramatic speed improvement that results.

# `makeCacheMatrix()` receives a square matrix and returns 
# a modified form of that matrix that is able to store its 
# own inverse once it is calculated. This function is based 
# on a script by Roger Peng.

makeCacheMatrix <- function(x = matrix()) {
    # initialise by creating two internal objects:
    x <- x         # stores the original matrix
    x.inv <- NULL  # stores the calculated value of the inverse
    
    # when x is set to a new value, 
    # clear any stored value in x.inv
    set <- function(y) {
        x <<- y
        x.inv <<- NULL
    }
    
    # returns the original matrix
    get <- function() x
    
    # stores and retrieves the inverse
    setinverse <- function(inverse) x.inv <<- inverse
    getinverse <- function() x.inv
    
    # return a list of four functions to set and get
    # the orginal matrix or its inverse
    list(set = set, get = get,
         setinverse = setinverse,
         getinverse = getinverse)
}


# `cacheSolve()` takes a modified matrix created by `makeCacheMatrix()` 
# and returns the cached inverse if it is already stored. 
# The inverse will thus need to be only calculated once per matrix.

cacheSolve <- function(x, ...) {
    ## Return a matrix that is the inverse of 'x'
    x.inv <- x$getinverse()
    if(!is.null(x.inv)) {
        # Uncomment the next line in order to see a
        # message on the console every time a cached
        # value is accessed:
        
        # message("getting cached data")
        return(x.inv)
    }
    
    # retrieve the original matrix from the caching object
    data <- x$get()
    
    # use the solve function in base R to get the matrix
    x.inv <- solve(data, ...)
    
    # store the calculated inverse so we will not need
    # to recalculate next time
    x$setinverse(x.inv)
    
    # return the value of the inverse
    x.inv
}

