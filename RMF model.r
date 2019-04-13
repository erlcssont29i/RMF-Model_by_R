#因為沒有真實資料，所以先創建raw_data, 5個人(1:5)重複抽取20次（當作為20個購買紀錄)
sales<-data.frame(
id=sample(1:5,replace=T,size=20),spend=abs(round(rnorm(n=20,mean=500,sd=300))),
date=as.Date("2017/1/1")+300*sort(stats::runif(20))
)


#以上為創建raw_data，接著要處理/增加一欄為消費日距今天數
date_gap<-round(as.numeric(difftime(Sys.Date(),sales[,3],day))) 


#把這一欄跟raw_data合併在一起 
sales<-cbind(sales,date_gap)

#---求R、M、F，把raw_data中 以人(id) 為分類加總

salesM<-aggregate(sales[,2], by=list(sales$id),FUN=sum)  #總消費
salesF<-aggregate(sales[,2], by=list(sales$id),FUN=length) #消費次數(th 不是ht 常常拼錯)
salesR<-aggregate(sales[,4], by=list(sales$id),FUN=max) #距離今天最近的天數

#重新取名
names(salesM)<-c("id","M")
names(salesF)<-c("id","F")
names(salesR)<-c("id","R")

#將它們組合成一個data_frame
salesRMF<-merge(salesM,merge(salesF,salesR)) 


# Creating RMF Model，Levels分125類並計算權重計分

salesRMF$rank_r<-cut(salesRMF$R,5,label=F)#labels=F:返回在第幾個區間，否則會顯示具體的區間
salesRMF$rank_m<-cut(salesRMF$M,5,label=F)
salesRMF$rank_f<-cut(salesRMF$F,5,label=F)
salesRMF$rank_RMF<-0.5*(salesRMF$rank_r)+0.2*(salesRMF$rank_m)+0.3*(salesRMF$rank_f)


