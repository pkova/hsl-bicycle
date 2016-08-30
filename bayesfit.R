library(MASS)

be = matrix(c(2,3),2,1)
x=matrix(rexp(200, rate=.1),20,2)
y=x%*%be+rnorm(20,0,1)

out <- bayesReg(x,y)

bayesReg <- function(x, y, burn = 300,
				      rounds = 500,
				      thin = 10,
				      nu = 3,
				      allwt,
				      prior) {
					

numparams <- ncol(x)
numsamples <- nrow(x)

numpar <- 1 + numparams + numsamples

if (missing(allwt)) {
	allwt <- matrix(c(1,rnorm(numpar-1,0,1)), numpar,1)
}

if (missing(prior)) {
  prior <- diag(1, numparams,numparams)
}

wt <- allwt[2:(numpar+1)]

for (n in 1:burn){
	allwt <- bayesSample(allwt,wt,x,y,nu,prior)
}

weights <- matrix(0,numparams,rounds)
hyper <- matrix(0,1,rounds)

for (i in 1:rounds) {
	for (j in 1:thin){
		allwt <- bayesSample(allwt,wt,x,y,nu,prior)
	}
  	weights[,i] <- allwt[2:(numparams+1)]
  	hyper[,i] <- allwt[1]
}
output=list(weights,hyper)
return(output)
}

repmat <- function(X,m,n) {
	mx <- dim(X)[1]
  	nx <- dim(X)[2]
  	return(matrix(t(matrix(X,mx,nx*n)),mx*m,nx*n,byrow=T))
}

bayesSample = function(allwt, wt, x, y, nu, prior) {
  numpar <- ncol(x)
  numsamp <- nrow(x)
  beta <- allwt[1]
  wt <- allwt[2:(numpar+1)]
  w <-  allwt[(numpar+2):nrow(allwt)]
  
  
  resid=(y-x%*%wt)
  a=beta
  w=rgamma(numsamp,(nu+1)/2,1)*(1/((nu+a*(resid*resid)/2)))
  beta = rgamma(1,numsamp/2,1)*(2/t(resid)%*%(w*resid))
  
  a=beta[1,1]
  W=repmat(w,1,numpar)
  covmat=a*t(x)%*%(W*x)+diag(1,numpar,numpar)
  
  icv=ginv(covmat)
  meanvec=a*icv%*%t(x)%*%(w*y)
  
  icv=icv+diag(1/100000,numpar,numpar)
  icv=icv+1/2*(t(icv)-icv)
  
  wt=mvrnorm(1,meanvec,icv)
  
  alpha=allwt[1:numpar]
  allwt[1]=beta
  allwt[2:(numpar+1)]=wt
  allwt[(numpar+2):nrow(allwt)]=w
  return(allwt)
}
