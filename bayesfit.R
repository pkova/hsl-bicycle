library(MASS)
library(dplyr)
library(tidyr)

bikedata <- read.table('C:/Users/Pekka Autere/Documents/Analytics/HSL data/hsl_train.csv', 
                       header = T, sep = ',', stringsAsFactors = F)

str(bikedata)

station="A02"
data<-preprocess(bikedata)
ox<-createX2(data,station)
x<-ox[[1]]
stationdata<-ox[[2]]
y<-createY(data,station)

mod<-lm(y~x)
be = matrix(c(2,3),2,1)
x=matrix(rexp(200, rate=.1),20,2)
y=x%*%be+rnorm(20,0,1)

out <- bayesReg(x,y)
param=out[[1]]
hyper=out[[2]]
ye=x%*%param
yem=rowMeans(ye)

plot(stationdata$hour,yem)
plot(stationdata$dayofweeknum,yem)
plot(stationdata$dayofweeknum,y)
plot(stationdata$hour,y)

createTanhKernel<-function(x,minx,maxx,numtanh)
  {

w <- 1.5 * (maxx - minx) / (numtanh - 1)

n<-length(x)

  out<-matrix(0,n,numtanh)
  a<-seq(minx,maxx,length=numtanh)
  for (i in 1:numtanh){
    out[,i]=tanh((x - a[i])/w)
  }

#remove mean scale(out, scale = FALSE)
  return(out)
}

createLinearKernel<-function(x,minx,maxx)
{
me<-(maxx+minx)/2
mul<-max(abs(maxx-me),abs(minx-me))
out<-(x-me)/mul
return(out)
}

createTanhKernel<-function(x,minx,maxx,numtanh)
{
  
  w <- 1.5 * (maxx - minx) / (numtanh - 1)
  
  n<-length(x)
  
  out<-matrix(0,n,numtanh)
  a<-seq(minx,maxx,length=numtanh)
  for (i in 1:numtanh){
    out[,i]=tanh((x - a[i])/w)
  }
  
  #remove mean scale(out, scale = FALSE)
  return(out)
}

preprocess <- function(bikedata){
  
  bikedata<-bikedata[bikedata$month>4,]
  
  bikedata$dayofweeknum[bikedata$dayofweek == "Maanantai"]<- 1
  bikedata$dayofweeknum[bikedata$dayofweek == "Tiistai"]<-2
  bikedata$dayofweeknum[bikedata$dayofweek == "Keskiviikko"]<-3
  bikedata$dayofweeknum[bikedata$dayofweek == "Torstai"]<- 4
  bikedata$dayofweeknum[bikedata$dayofweek == "Perjantai"]<- 5
  bikedata$dayofweeknum[bikedata$dayofweek == "Lauantai"]<-6
  bikedata$dayofweeknum[bikedata$dayofweek == "Sunnuntai"]<- 7
  
  
  bikedata$Mon <- ifelse(bikedata$dayofweek == "Maanantai", 1, 0)
  bikedata$Tue <- ifelse(bikedata$dayofweek == "Tiistai", 1, 0)
  bikedata$Wed <- ifelse(bikedata$dayofweek == "Keskiviikko", 1, 0)
  bikedata$Thu <- ifelse(bikedata$dayofweek == "Torstai", 1, 0)
  bikedata$Fri <- ifelse(bikedata$dayofweek == "Perjantai", 1, 0)
  bikedata$Sat <- ifelse(bikedata$dayofweek == "Lauantai", 1, 0)
  bikedata$Sun <- ifelse(bikedata$dayofweek == "Sunnuntai", 1, 0)
  
  bikedata$May <- ifelse(bikedata$month == 5, 1, 0)
  bikedata$Jun <- ifelse(bikedata$month == 6, 1, 0)
  bikedata$Jul <- ifelse(bikedata$month == 7, 1, 0)
  bikedata$Aug <- ifelse(bikedata$month == 8, 1, 0)
  
  bikedata$hour0 <- ifelse(bikedata$hour == 0, 1, 0)
  bikedata$hour1 <- ifelse(bikedata$hour == 1, 1, 0)
  bikedata$hour2 <- ifelse(bikedata$hour == 2, 1, 0)
  bikedata$hour3 <- ifelse(bikedata$hour == 3, 1, 0)
  bikedata$hour4 <- ifelse(bikedata$hour == 4, 1, 0)
  bikedata$hour5 <- ifelse(bikedata$hour == 5, 1, 0)
  bikedata$hour6 <- ifelse(bikedata$hour == 6, 1, 0)
  bikedata$hour7 <- ifelse(bikedata$hour == 7, 1, 0)
  bikedata$hour8 <- ifelse(bikedata$hour == 8, 1, 0)
  bikedata$hour9 <- ifelse(bikedata$hour == 9, 1, 0)
  bikedata$hour10 <- ifelse(bikedata$hour == 10, 1, 0)
  bikedata$hour11 <- ifelse(bikedata$hour == 11, 1, 0)
  bikedata$hour12 <- ifelse(bikedata$hour == 12, 1, 0)
  bikedata$hour13 <- ifelse(bikedata$hour == 13, 1, 0)
  bikedata$hour14 <- ifelse(bikedata$hour == 14, 1, 0)
  bikedata$hour15 <- ifelse(bikedata$hour == 15, 1, 0)
  bikedata$hour16 <- ifelse(bikedata$hour == 16, 1, 0)
  bikedata$hour17 <- ifelse(bikedata$hour == 17, 1, 0)
  bikedata$hour18 <- ifelse(bikedata$hour == 18, 1, 0)
  bikedata$hour19 <- ifelse(bikedata$hour == 19, 1, 0)
  bikedata$hour20 <- ifelse(bikedata$hour == 20, 1, 0)
  bikedata$hour21 <- ifelse(bikedata$hour == 21, 1, 0)
  bikedata$hour22 <- ifelse(bikedata$hour == 22, 1, 0)
  bikedata$hour23 <- ifelse(bikedata$hour == 23, 1, 0)
  
  bikedata <- na.omit(bikedata)
  return(bikedata)
}



createY <- function(data,station){
  
  stationdata<-data[data$station==station,]
  rows=nrow(stationdata)
  cols=1
  y<-matrix(stationdata$max_availability,rows,cols)
  return(y)
}

createX2 <- function(data,station){
  
  stationdata<-data[data$station==station,]
  rows=nrow(stationdata)
  x1<-rep(1,rows)
  x2<-createTanhKernel(stationdata$hour,0,23,10)
  x3<-createTanhKernel(stationdata$dayofweeknum,1,7,5)
  x4<-createTanhKernel(stationdata$dayofmonth,1,31,5)
  x5<-createLinearKernel(stationdata$month,1,12)
  x<-cbind(x1,x2,x3,x4,x5
           ,stationdata$Mon
           ,stationdata$Tue
           ,stationdata$Wed
           ,stationdata$Thu
           ,stationdata$Fri
           ,stationdata$Sat
           ,stationdata$Sun)
  
  output=list(x,stationdata)
  return(output)
}

createX <- function(data,station){
  
  stationdata<-data[data$station=="A01",]
  rows=nrow(stationdata)
  cols=18
  x<-matrix(c(rep(1,rows),
              stationdata$Mon,
              stationdata$Tue,
              stationdata$Wed,
              stationdata$Thu,
              stationdata$Fri,
              stationdata$Sat,
              stationdata$Sun,
              stationdata$May,
              stationdata$Jun,
              stationdata$Jul,
              stationdata$Aug,
              stationdata$hour0,
              stationdata$hour1,
              stationdata$hour2,
              stationdata$hour3,
              stationdata$hour4,
              stationdata$hour5,
              stationdata$hour6,
              stationdata$hour7,
              stationdata$hour8,
              stationdata$hour9,
              stationdata$hour10,
              stationdata$hour11,
              stationdata$hour12,
              stationdata$hour13,
              stationdata$hour14,
              stationdata$hour15,
              stationdata$hour16,
              stationdata$hour17,
              stationdata$hour18,
              stationdata$hour19,
              stationdata$hour20,
              stationdata$hour21,
              stationdata$hour22,
              stationdata$hour23),rows,cols)
  return(x)
}


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
    prior <- diag(10, numparams,numparams)
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
