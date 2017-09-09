dir.create("E:/image/")
myHttpheader <- c("User-Agent"="Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.6)","Accept"="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8","Accept-Language"="en-us","Connection"="keep-alive","Accept-Charset"="GB2312,utf-8;q=0.7,*;q=0.7")

date<-c("20170425","20170426","20170427","20170428","20170429","20170430","20170501","20170502","20170503","20170504","20170505","20170506","20170507","20170508","20170509")
for(urlname in date){
  dir.create(paste("E:/image/",urlname,"/",sep=""))
  tryCatch({
  url<-paste("http://bcy.net/coser/toppost100?type=week&date=",urlname,sep="")
  web<-getURL(url,httpheader=myHttpheader)
  doc<- htmlTreeParse(web,encoding="UTF-8", error=function(...){}, useInternalNodes = TRUE,trim=TRUE)
  node<-getNodeSet(doc, "//div[@class='work-thumbnail__topBd']/a")
  info=sapply(node,xmlGetAttr,"href")
  },error=function(e){cat("ERROR:",conditionMessage(e),"\n")
    print("los")
  }
  )
  web1<-as.character(web)
  ru<-gregexpr("class=\"cut db fz16 text\".{1,50}</a>",web1)
  text<-regmatches(web1,ru)
  text<-unlist(text)
  rules<-gregexpr("\n.{1,20}</a>",text)
  text1<-regmatches(text,rules)
  text1<-gsub("\n","",text1)
  text1<-gsub("</a>","",text1)
  
  
  x="http://bcy.net"
  info1<-paste(x,info,sep="")
  
  for(i in 1:100){
  url1<-info1[i]
  
  tryCatch({
  web2<-getURL(url1,httpheader=myHttpheader)
  doc2<- htmlTreeParse(web2,encoding="UTF-8", error=function(...){}, useInternalNodes = TRUE,trim=TRUE)
  node2<-getNodeSet(doc2, "//img[@class='detail_std detail_clickable']")
  info2=sapply(node2,xmlGetAttr,"src")
  },error=function(e){cat("ERROR:",conditionMessage(e),"\n")
    print("los")
  }
  )
  
  co<-1
  
  for(inf in info2){
    zhe<-gsub(" ","",text1[i])
    dir.create(paste("E:/image/",urlname,"/",zhe,"/",sep=""))
    y<-paste("E:/image/",urlname,"/",zhe,"/",co,".jpg",sep="")
    tryCatch({
      download.file(inf,y,mode="wb")
      co<-co+1
      
    },error=function(e){cat("ERROR:",conditionMessage(e),"\n")
      print("los")
    }
    )}
  }}


