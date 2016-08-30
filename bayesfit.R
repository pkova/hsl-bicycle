library(MASS)

params=2
samples=20
be=matrix(c(2,3),2,1)
x=matrix(rexp(200, rate=.1),samples,params)
y=x%*%be+rnorm(20,0,1)
wt=matrix(runif(params*1), params,1)

numpar=1+params+samples
allwt=matrix(runif(numpar*1), numpar, 1)

burn=300
rounds=500
thin=10

for (n in 1:burn){
allwt=bayesSample(allwt,wt,x,y)
}

weights=matrix(0,params,rounds)
hyper=matrix(0,1,rounds)
for (i in 1:rounds){
for (j in 1:thin){
allwt = bayesSample(allwt,param,x,y)
}
  weights[,i]=allwt[2:(params+1)]
  hyper[,i]=allwt[1]
}

repmat = function(X,m,n)
  {
  ##R equivalent of repmat (matlab)
  mx = dim(X)[1]
  nx = dim(X)[2]
  matrix(t(matrix(X,mx,nx*n)),mx*m,nx*n,byrow=T)
}


bayesSample = function(allwt,wt,x,y)
{
  nu = 3
  numpar=ncol(x)
  numsamp=nrow(x)
  beta=allwt[1]
  wt=allwt[2:(numpar+1)]
  w = allwt[(numpar+2):nrow(allwt)]
  
  
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
