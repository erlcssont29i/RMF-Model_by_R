# Practice RMF Model by R

## introduction

This article(http://www.idatacamp.com/1196.html/) reminds me that when I  work in a E-learning internet company 5 years ago,  I also used RMF model to analyze clients in order to choose a good customer for good quality. Let me practice again and explain how each function do.

- Recency – How recently did the customer purchase?


- Frequency – How often do they purchase?


- Monetary Value – How much do they spend?

  ​

## funtions

- **data.frame()** https://blog.csdn.net/panguoyuan/article/details/25542697

- 抽樣**sample()**與分佈**rnorm(), ruifi()**

- 數值處理**round(),abs()**

- 排序相關**sorb(),rank(),order()**:https://blog.csdn.net/sinat_26917383/article/details/51180556

- 時間處理**Sys.Date()**＆**difftime()**&**as.numeric()** :https://blog.csdn.net/xiangyong58/article/details/50458532

- 數據框列變量命名**names()**

- 分類計算**aggregate**():https://www.cnblogs.com/cloudtj/articles/5528903.html

- 数据整合**merge**： <http://rstudio-pubs-static.s3.amazonaws.com/13602_96265a9b3bac4cb1b214340770aa18a1.html>  and https://joe11051105.gitbooks.io/r_basic/content/arrange_data/merge_and_subsetting.html

- 反向使用"$"，對原数据框添加子集数据

- 區間劃分**cut()**

  #### *Good R source-https://yijutseng.github.io/DataScienceRBook/index.html*

  ​

## Steps

1. creating a customer’s order record, including “order id(id)”, “spending” and “date” as a data frame

2. Calculating that how recently did the customer purchase

3. get R M F value(by customer)

4. merging R,M,F to create a new data frame 

5. Creating R,M,F levels and giving each values a weight to Calculate RMF score

   ​

## Coding

### 1. creating a customer’s order recording

因為沒有真實的訂單資料，所以自己創建raw_data，假設有5個人購買20次，消費金額為常態分佈，消費日期為均勻分佈，**另外為了符合訂單數據的記錄方式，消費日期用sorb()進行排序**

```r
sales<-data.frame(
id=sample(1:5,replace=T,size=20),spend=abs(round(rnorm(n=20,mean=500,sd=300))),
date=as.Date("2017/1/1")+300*sort(runif(20))
)
##5個人(1:5)重複抽取20次（當作為20個購買紀錄)
##--也可以設定2個or 3個data_frame，在用cbind合起來
##--可以之後再取命，用函數names(),for exampel :names(sales)=c("id","spend)
##--round()取整數＋abs()取絕對值，一起用則意思為”保證消費金額為正整數“
##--sorb進行排序，讓消費日期是遞增的
##--as.Date的Ｄ一定要大寫，另外用as.Data()讓Ｒ知道這不是本文而是日期
```



### 2.增加一欄為消費日距今天數

從創建的raw_data中，可以計算每一個顧客的總消費金額(M)，總消費次數(F)，但無法得知最近一次消費距今天數(R)，所以先處理一欄數據為--**消費距今天數**，即現在的日期與消費日期有多少天

```r
date_gap<-round(as.numeric(difftime(Sys.Date(),sales[,3],day))) 
#Sys.Date()是取現在日期，difftime()計算時間差
#我們想要的difftime是一個數字，所以要用sa.number(),另外difftime計算到小數點，想要取整數值（所以用round)

#把這一欄跟raw_data合併在一起 
sales<-cbind(sales,date_gap)
```



### 3.以customer(id) 為分類求R,M,F value

計算每一個消費者的總消費金額(M)，總消費次數(F)及最近一次消費距今天數(R)，SQL中group by的概念在Ｒ就是用aggregate()

```r
salesM<-aggregate(sales[,2], by=list(sales$id),FUN=sum)  #總消費
salesF<-aggregate(sales[,2], by=list(sales$id),FUN=length) #消費次數(就是長度length)
salesR<-aggregate(sales[,4], by=list(sales$id),FUN=max) #消費日距離今天最近的天數
#記得by=list()-->by每一個id所以是一個list

#給元素取名
names(salesM)<-c("id","M")
names(salesF)<-c("id","F")
names(salesR)<-c("id","R")
```



### 4.將它們組合成一個data_frame

salesM,salesF,salesR 都以id為共同的欄位，這種狀況的合併用merge(而不是cbind)

```r
salesRMF<-merge(salesM,merge(salesF,salesR)) 
```



### 5.Creating RMF Levels

```r
salesRMF$rank_r<-cut(salesRMF$R,5,label=F)#labels=F:返回在第幾個區間，否則會顯示具體的區間
salesRMF$rank_m<-cut(salesRMF$M,5,label=F)
salesRMF$rank_f<-cut(salesRMF$F,5,label=F)
salesRMF$rank_RMF<-0.5*(salesRMF$rank_r)+0.2*(salesRMF$rank_m)+0.3*(salesRMF$rank_f)

#劃分五等分法，用cut(vector,cuttime,labels=F)
```




