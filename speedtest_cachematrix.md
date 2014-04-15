# Caching the Inverse of a Matrix

**Gauden Galea**  
https://github.com/ggData/ProgrammingAssignment2  
_15 April 2014_

## Setting up

First we `source` the script called `cachematrix.R`. This brings two functions into the current environment:

- `makeCacheMatrix()` receives a square matrix and returns a modified form of that matrix that is able to store its own inverse once it is calculated. This function is based on a [script by Roger Peng](https://github.com/rdpeng/ProgrammingAssignment2/blob/master/README.md) with [changes by Patrick Gillen and Lenka Vyslouzilova](https://class.coursera.org/rprog-002/forum/thread?thread_id=370#comment-953).
- `cacheSolve()` takes a modified matrix created by `makeCacheMatrix()` and returns the cached inverse if it is already stored. The inverse will thus need to be only calculated once per matrix.

Neither function checks whether the matrix passed in indeed has an inverse, so fatal errors are possible.

The code chunk also creates two key objects:

- `x` is a simple 3 by 3 matrix which is known to have an inverse
- `cm_x` is a caching matrix of the type described above


```r
source("cachematrix.R")

vec <- c(1, 2, 3, 0, 1, 4, 5, 6, 0)
x <- matrix(vec, nrow = 3, ncol = 3)
cm_x <- makeCacheMatrix(x)
```


## Tests

### Correctness

The following two lines check:

1. That a call to `solve()` and a call to `cachesolve()` produce identical results, i.e. our modification to the solving function does not alter the result, and
2. That repeated calls to `cachesolve()` return the same result.


```r
identical(cacheSolve(cm_x), solve(x))
```

```
## [1] TRUE
```

```r
identical(cacheSolve(cm_x), cacheSolve(cm_x))
```

```
## [1] TRUE
```


### Speed

The following chunk sets up two test functions to time the standard `solve()` function versus `cacheslve()`. This is done simply by running the functions a million times over the same objects created above and reporting the time it takes.


```r
test_inverse = function(x, r = 1e+06) {
    m <- matrix(x, nrow = 3, ncol = 3)
    for (i in 1:r) {
        solve(m)
    }
}

test_cache_inverse = function(x, r = 1e+06) {
    y = makeCacheMatrix(matrix(x, nrow = 3, ncol = 3))
    for (i in 1:r) {
        cacheSolve(y)
    }
}
```


Next we run the tests and compare the times:


```r
vec <- c(1, 2, 3, 0, 1, 4, 5, 6, 0)

system.time(test_inverse(vec))
system.time(test_cache_inverse(vec))
```


### Results

Below are the results from a single run of the speed test (actual runs will vary from machine to machine and between runs on the same machine).

```
> system.time(test_inverse(vec))
   user  system elapsed 
  35.61    0.02   35.64 

> system.time(test_cache_inverse(vec))
   user  system elapsed 
   3.71    0.00    3.70 
```

The cached version was almost ten times faster than the standard version of `solve()`. 

## Errors

Neither of the functions performs any error checking. If a matrix is passed in that does not have an inverse, a fatal error results. 


```r
vec <- c(4, 6, -6, -9)
x <- matrix(vec, nrow = 2, ncol = 2)
cacheSolve(makeCacheMatrix(x))
```

```
## Error: Lapack routine dgesv: system is exactly singular: U[2,2] = 0
```


This will also happen if the object passed in is not a matrix.


```r
vec <- c(1, 2, 3, 0, 1, 4, 5, 6, 0)
cacheSolve(vec)
```

```
## Error: $ operator is invalid for atomic vectors
```


The changes to the functions to catch and resolve these conditions gracefully would be a natural addition to the code but is specifically excluded from the scope of the Coursera assignment.

