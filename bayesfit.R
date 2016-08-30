library(MASS)
library(dplyr)
library(tidyr)

bikedata <- read.table('C:/Users/Pekka Autere/Documents/Analytics/HSL data/hsl_train.csv', 
                       header = T, sep = ',', stringsAsFactors = F)

str(bikedata)

data<-preprocess(bikedata)
x<-createX(data)
y<-createY(data)

mod<-lm(y~x)

preprocess <- function(bikedata){

bikedata<-bikedata[bikedata$month>4,]

bikedata$Mon <- ifelse(data$dayofweek == "Maanantai", 1, 0)
bikedata$Tue <- ifelse(data$dayofweek == "Tiistai", 1, 0)
bikedata$Wed <- ifelse(data$dayofweek == "Keskiviikko", 1, 0)
bikedata$Thu <- ifelse(data$dayofweek == "Torstai", 1, 0)
bikedata$Fri <- ifelse(data$dayofweek == "Perjantai", 1, 0)
bikedata$Sat <- ifelse(data$dayofweek == "Lauantai", 1, 0)

bikedata$May <- ifelse(data$dayofweek == 5, 1, 0)
bikedata$Jun <- ifelse(data$dayofweek == 6, 1, 0)
bikedata$Jul <- ifelse(data$dayofweek == 7, 1, 0)

bikedata$hour0_3<- ifelse(0=data$hour <= 3,1, 0)
bikedata$hour4_7 <- ifelse(4<=data$hour <= 7, 1, 0)
bikedata$hour8_11 <- ifelse(8<=data$hour <= 11, 1, 0)
bikedata$hour12_15 <- ifelse(12<=data$hour <= 15, 1, 0)
bikedata$hour16_19 <- ifelse(16<=data$hour <= 19, 1, 0)
bikedata$hour20_23 <- ifelse(20<=data$hour <= 23, 1, 0)

bikedata <- na.omit(bikedata)
return(bikedata)
}

createY <- function(data,station){
  
  stationdata<-bikedata[bikedata$station=="A01",]
  rows=nrow(stationdata)
  cols=1
  y<-matrix(stationdata$max_availability,rows,cols)
  return(y)
}

createX <- function(data,station){
  
  stationdata<-bikedata[bikedata$station=="A01",]
  rows=nrow(stationdata)
  cols=16
  x<-matrix(c(rep(1,rows),
              bikedata$Mon,
              bikedata$Tue,
              bikedata$Wed,
              bikedata$Thu,
              bikedata$Fri,
              bikedata$Sat,
              bikedata$May,
              bikedata$Jun,
              bikedata$Jul,
              bikedata$hour0_3,
              bikedata$hour4_7,
              bikedata$hour8_11,
              bikedata$hour12_15,
              bikedata$hour16_19,
              bikedata$hour20_23),rows,cols)
  return(x)
}

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
