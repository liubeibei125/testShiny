
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)
library(wordcloud2)
library(ropencc)
library(rvest)
library(REmap)
library(RbaiduLBS)
library(qcc)
library(quantmod)




shinyServer(function(input, output) {
  sliderValues <- reactive({
    aa<-switch(input$dist,
               a=1,
               b=2,
               c=3,
               1)
    
  })
  
  sliderValues1 <- reactive({
    aa<-sliderValues()
    if(aa==1){
      inFile <- input$file1
      if (is.null(inFile))
        return(NULL)
      zzz<-scan(inFile$datapath,sep="\n",what = "",encoding = "UTF-8")
      
    }else if(aa==2){
      zzz<-scan("./zzz.txt",sep="\n",what = "",encoding = "UTF-8")
    }else{
      zzz<-scan("./mei.txt",sep="\n",what = "",encoding = "UTF-8")
    }
    
  })
  
  df <- eventReactive(input$updata, {
    aa<-sliderValues()
    zzz<-sliderValues1()
    if(aa==1){
      x<-sample(1:length(zzz),1,replace = FALSE)
    }else if(aa==2){
      x<-sample(1:1000,1,replace = FALSE)
    }else{
      x<-sample(1:339,1,replace = FALSE)
    }
  })
  
  
  output$moreControls <- renderUI({
    df<-df()
    zzz<-sliderValues1()
    
    pre<-zzz[[df]]
    tags$img(src=pre)
  })
  ###table1
  xh<-reactive({
    if(input$dist1){
      inFile <- input$file1
      if (is.null(inFile))
        return(NULL)
      xh<-scan(inFile$datapath,sep="\n",what = "",encoding = "UTF-8")
    }else{
      xh<-scan("./xiaohua.txt",sep="\n",what = "",encoding = "UTF-8")
    }
  })
  
  
  df1<- eventReactive(input$next1, {
    x<-sample(1:997,1,replace = FALSE)
  })
  
  output$text<-renderTable({
    xh<-xh()
    df1<-df1()
    y<-input$num
    xh[df1:(df1+y-1)]
    
  })
  ###table2
  ###navbar1
  
  na21<- eventReactive(input$gofan,{
    inFile <- input$file2
    if (is.null(inFile))
      return(NULL)
    fan<-scan(inFile$datapath,sep="\n",what = "",encoding = "UTF-8")
  })
  
  na22<- eventReactive(input$view, {
    na22<-input$wenben
  })
  
  output$text1<-renderTable({
    fan<-na21()
    converter(S2T)[fan]
  })
  ##table1
  output$text2<-renderText({
    na22<-na22()
    converter(S2T)[na22]
  })
  ##na2
  
  
  
  ciyun<-eventReactive(input$ciyun, {
    name<-input$name
    cipin<-c(rep("happy",10),rep("miss",12),rep("love",14),rep("you",10),rep("like",12),
             rep("sweet",10),rep("hourse",12),rep("surprise",13),rep("dream",12),rep("free",12),
             rep("with you",14),rep("life",13),rep(" together",13),rep("eternity",12),rep("destiny",6),rep("cherish",5),
             rep("sunflower",10),rep("galaxy",5),rep("moment",14),rep("bubble",3),rep("smile",7),rep("lollipop",8),rep("umbrella",8))
    cipin1<-c(cipin,rep(name,15))
    citab<-table(cipin1)
  })
  
  output$yyy<-renderText({
    input$name
  })
  
  
  output$image<-renderWordcloud2({
    citab<-ciyun()
    wordcloud2(citab,size = 0.5,color = 'random-dark',backgroundColor = "snow",shape="diamond")
  })
  ##na3
  
  
  zaixian1<- eventReactive(input$zaixian1, {
    url<-paste("http://www.budejie.com/pic/",input$num2,sep="")
    web<-read_html(url,encoding = "UTF-8")
    x<-web%>%html_nodes("div.j-r-list-tool-ct-fx")%>%html_nodes("div")%>%html_attr("data-text")
    y<-web%>%html_nodes("div.j-r-list-c-img")%>%html_nodes("img")%>%html_attr("data-original")
    re<-list()
    for(i in 1:20){
      re[[x[i]]]<-y[i]
    }
    re
  })
  
  zaixi2<- eventReactive(input$zaixi2, {
    sample(c(1,6,11,16),1)
  })
  
  
  
  output$pic33<-renderTable({
    re25<-zaixian1()
    paste(1:length(names(re25)),names(re25),sep=",")
  })
  
  output$vire22 <- renderUI({
    re25<-zaixian1()
    re26<-zaixi2()
    ree25<-re25[[re26]]
    ree26<-re25[[re26+1]]
    ree27<-re25[[re26+2]]
    ree28<-re25[[re26+3]]
    ree29<-re25[[re26+4]]
    vire1<-names(re25[re26])
    vire2<-names(re25[re26+1])
    vire3<-names(re25[re26+2])
    vire4<-names(re25[re26+3])
    vire5<-names(re25[re26+4])
    tabsetPanel(
      tabPanel(
        tags$h6(vire1),
        tags$img(src =ree25),
        tags$h6(vire2),
        tags$img(src =ree26),
        tags$h6(vire3),
        tags$img(src =ree27),
        tags$h6(vire4),
        tags$img(src =ree28),
        tags$h6(vire5),
        tags$img(src =ree29)
        
      )
    )
    
  })
  
  
  ###na4
  
  
  
  tianqieve<-eventReactive(input$tianqi,{
    web11<-read_html("http://www.weather.com.cn/textFC/henan.shtml",encoding="UTF-8")
    web12<-web11%>%html_nodes("div.conMidtab3")
    y<-web12%>%html_nodes("td.rowsPan")%>%html_text()
    y<-y[1:18]
    i<-which(y==input$sql)
    i<-as.numeric(i)
    x<-web12[[i]]%>%html_text()
    x<-strsplit(x,split = "详情")
    x<-unlist(x)
    x<-gsub("\n{1,2}"," ",x)
    x<-strsplit(x,split = " ")
    x<-do.call(cbind,x)
    x<-as.data.frame(x,stringsAsFactors=F)
    x<-x[-1,]
    x<-x[,-dim(x)[2]]
    colnames(x)<-x[1,]
    x[[1]]<-c(x[[1]][-1],NA)
    x<-x[-dim(x)[1],]
    rownames(x)<-c("城市","天气现象-白天","风向-白天","风力-白天","气温-白天","天气现象-夜间","风向-夜间","风力-夜间","气温-夜间")
    z<-x[,input$sql1,drop=F]
  })
  
  output$tianqi<-renderTable({
    z<-tianqieve()
    t(z)
  })
  
  ###na5
  kb1<-reactive({
    urlkb<-paste("http://heibaimanhua.com/weimanhua/kbmh/page/",input$kbnum,sep="")
    webkb<-read_html(urlkb,encoding = "UTF-8")
    kbx<-webkb%>%html_nodes("article.excerpt.excerpt-one")%>%html_nodes("a")%>%html_attr("title")
    kby<-webkb%>%html_nodes("article.excerpt.excerpt-one")%>%html_nodes("a")%>%html_attr("href")
    kbkb<-list()
    for(i in 1:length(kbx)){
      kbkb[[kbx[i]]]<-kby[i]
    }
    kbkb
  })
  
  output$kbkbtext<-renderTable({
    kb1<-kb1()
    paste(1:length(names(kb1)),names(kb1),sep=",")
  })
  
  kb2<-eventReactive(input$kb2,{
    kb1<-kb1()
    kbnum1<-input$kbnum1
    urlkb1<-kb1[[kbnum1]]
    webkb1<-read_html(urlkb1,encoding = "UTF-8")
    kbjie<-webkb1%>%html_nodes("article.article-content")%>%html_nodes("img")%>%html_attr("src")
  })
  
  output$kbui<-renderUI({
    kb2<-kb2()
    tabsetPanel(
      tabPanel("目录",
               
               tableOutput("kbkbtext")
               
      ),
      tabPanel("在线漫画",
               tags$img(src=kb2[1]),
               tags$img(src=kb2[2]),
               tags$img(src=kb2[3]),
               tags$img(src=kb2[4]),
               tags$img(src=kb2[5]),
               tags$img(src=kb2[6]),
               tags$img(src=kb2[7]),
               tags$img(src=kb2[8]),
               tags$img(src=kb2[9]),
               tags$img(src=kb2[10]),
               tags$img(src=kb2[11]),
               tags$img(src=kb2[12]),
               tags$img(src=kb2[13]),
               tags$img(src=kb2[14]),
               tags$img(src=kb2[15]),
               tags$img(src=kb2[16]),
               tags$img(src=kb2[17])
               
               
      ))
  })
  ##na6
  
  audiozaixian<- eventReactive(input$audiozaixian, {
    url<-paste("http://www.budejie.com/audio/",input$audio2,sep="")
    webaudio<-read_html(url,encoding = "UTF-8")
    xaudio<-webaudio%>%html_nodes("div.j-r-list-c-desc")%>%html_text()
    yaudio<-webaudio%>%html_nodes("div.j-audio")%>%html_attr("data-mp3")
    audioz<-list()
    for(i in 1:length(xaudio)){
      audioz[[xaudio[i]]]<-yaudio[i]
    }
    audioz
  })
  
  output$audio11 <- renderTable({
    re<-audiozaixian()
    names(re[input$audio1])
  })
  
  output$audio33<-renderTable({
    re<-audiozaixian()
    paste(1:length(names(re)),names(re),sep=",")
  })
  
  output$audio22 <- renderUI({
    re<-audiozaixian()
    ree<-re[[input$audio1]]
    tags$audio(src =ree, type = "audio/mp3", autoplay = NA, controls = NA)
  })
  ##na7 
  youdao<-eventReactive(input$engan,{
    if(input$youyyy){
      web<-read_html(paste("http://fanyi.youdao.com/openapi.do?keyfrom=blog125&key=21376174&type=data&doctype=json&version=1.1&q=",input$eng,sep=""),encoding = "UTF-8")
      web<-as.character(web)
      rules<-gregexpr("explains.{10,100}}",web)
      y<-regmatches(web,rules)
      rules<-gregexpr("[a-z]{1,5}.{1,20}\"",y)
      y<-do.call(cbind,regmatches(y,rules))
      y[,1]<-gsub("\"","",y[,1])
      y<-y[-1,]}else{
        inFile <- input$fileyou
        if (is.null(inFile))
          return(NULL)
        dan<-scan(inFile$datapath,sep="\n",what = "",encoding = "UTF-8")
        yy<-list()
        for(i in 1:length(dan)){
          web<-read_html(paste("http://fanyi.youdao.com/openapi.do?keyfrom=blog125&key=21376174&type=data&doctype=json&version=1.1&q=",dan[i],sep=""),encoding = "UTF-8")
          web<-as.character(web)
          rules<-gregexpr("explains.{10,100}}",web)
          y<-regmatches(web,rules)
          rules<-gregexpr("[a-z]{1,5}.{1,20}\"",y)
          y<-do.call(cbind,regmatches(y,rules))
          y[,1]<-gsub("\"","",y[,1])
          y<-y[-1,]
          yy[[dan[i]]]<-y
        }
        yy<-do.call(cbind,yy)
        yy<-as.data.frame(yy)
      }
  })
  
  output$eng<-renderTable({
    youdao()
  })
  ##na7
  
  zaixianvi1<- eventReactive(input$zaixianvi1, {
    url<-paste("http://www.budejie.com/video/",input$vi1,sep="")
    web<-read_html(url,encoding = "UTF-8")
    x<-web%>%html_nodes("div.j-r-list-c-desc")%>%html_text()
    y<-web%>%html_nodes("div.j-video")%>%html_attr("data-mp4")
    
    re25<-list()
    for(i in 1:20){
      re25[[x[i]]]<-y[i]
    }
    re25
  })
  
  output$re111 <- renderTable({
    re<-zaixianvi1()
    names(re[input$num11])
  })
  
  output$vipic33<-renderTable({
    re<-zaixianvi1()
    paste(1:length(names(re)),names(re),sep=",")
  })
  
  output$vire2 <- renderUI({
    re<-zaixianvi1()
    ree<-re[[input$num11]]
    tags$video(src=ree, type = "video/mp4", autoplay = NA, controls = NA)
  })
  
  ###
  
  mapdata1<-eventReactive(input$laia,{
    
      x<-getGeocoding(address = input$dituaddress1, city =input$ditucity1, ak = 'YSnlpsVi6Gi49a8A4Hmr8w2qxxsXWUS2')
      x<-x[1:4]
      x$city<-paste(x$city,x$address,sep="")
      x<-x[-2]
      x<-x[c(3,2,1)]
      colnames(x)<-c("lon","lat","city")
      x<-as.data.frame(x)
   
  })
  
  output$tabdi<-renderTable({
    x<-mapdata1()
  })
  
  ####
  
  didisliderValues <- reactive({
    inFile <- input$didifile1
    
    if (is.null(inFile))
      return(NULL)
    
    x<-read.csv(inFile$datapath)
    names(x)<-c("a","b")
    x[(length(x$b)-input$dididate):length(x$b),2]
  })
  
  output$didicontents <- renderTable({
    inFile <- input$didifile1
    
    if (is.null(inFile))
      return(NULL)
    
    read.csv(inFile$datapath)
  })
  
  output$didicontents1 <- renderTable({
    y<-didisliderValues()
    head(y,100)
  })
  
  output$didiplot<-renderPlot({
    y<-didisliderValues()
    
    qcc(y,type = "xbar.one")
  })
  output$didiplot1<-renderPlot({
    
    y<-didisliderValues()
    
    hist(y,freq = FALSE)
    rug(y)
    lines(density(y))
  })
  
  output$didiplot2<-renderPlot({
    y<-didisliderValues()
    qqnorm(y)
    qqline(y)
  })
  #####
 
  

  
})