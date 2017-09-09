
# This is the user-interface definition of a Shiny web application.
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

shinyUI(dashboardPage(skin = "green",
  dashboardHeader(title = "多功能shiny 测试",
                  dropdownMenu(type = "messages",
                               messageItem(
                                 from = "shiny admin",
                                 message = "欢迎使用",
                                 time =Sys.Date()
                               ))),
  
  dashboardSidebar(sidebarMenu(
    menuItem("离线内容",tabName = "widgets1",icon = icon("cloud-download")),
    
    menuItem("在线娱乐",
             menuItem("在线图片",tabName = "widgets4",icon = icon("area-chart")),
             menuItem("在线声音",tabName = "widgets7",icon = icon("music")),
             menuItem("在线视频", icon = icon("video-camera"), tabName = "widgets9")
             ,icon = icon("list")),
    
    menuItem("在线工具",
             menuItem("简体转繁体",tabName = "widgets2",icon = icon("check-circle-o")),
             menuItem("词云-love",tabName = "widgets3",icon = icon("cloud")),
             menuItem("在线翻译",tabName = "widgets8",icon = icon("sort-alpha-desc")),
             menuItem("经纬度获取",tabName = "widgets10",icon = icon("university")),
             
             icon = icon("list")),
    
    
    
    menuItem("河南天气系统",tabName = "widgets5",icon = icon("snowflake-o")),
    menuItem("恐怖漫画",tabName = "widgets6",icon = icon("info-circle")),
    
    
    
    menuItem("qcc控制图",tabName = "widgets11",icon = icon("line-chart")),
    menuItem("我的博客", icon = icon("file-code-o"), 
             href = "http://www.datafxs.xyz/")
    
  )),
  
  dashboardBody(
    tabItems(
      # First tab content第一个标签内容
      tabItem(tabName = "widgets1",
              fluidRow(
                column(width = 4,
               
                box(title="选择控件",width = NULL,collapsible=TRUE,status = "info",background = "black",
                    "要求的文件格式，txt文件，\n回车键
                     作为分割，里面保存的是图片的url",
                    fileInput('file1', '图片url文件'),
                   
                    radioButtons("dist", "按照你的需求选择:",
                                 list("我自己上传文件" ="a",
                                      "使用内置图片文件1"="b",
                                      "使用内置图片文件2"="c"
                                 )),
                    
                    actionButton("updata", "下一张")),
                
                box(title="选择控件",width = NULL,collapsible=TRUE,status = "info",background = "blue",
                    "要求的文件格式，txt文件，\n回车键作为分割，里面保存的是文字",
                    fileInput('file', '文字文件'),
                    
                    radioButtons("dist1", "按照你的需求选择:",
                                 list("我自己上传文件" =TRUE,
                                      "使用内置文字文件"=FALSE
                                 )),
                    numericInput("num", "选择显示个数:",5),
                    actionButton("next1", "下一条"))
              ),
              column(width=8,
                     tabBox(
                       title = "内容",
                       # The id lets us use input$tabset1 on the server to find the current tab
                       id = "tabset1", 
                       tabPanel("图片", h4("案列图片来自爬虫爬取"),
                                uiOutput("moreControls")),
                       tabPanel("文字", h4("案列文字来自爬虫爬取"),
                                tableOutput(
                                  "text"
                                ))
                     ))
              
              )
              
      ),
 
  ###na2
  tabItem(tabName = "widgets2",
          fluidRow(
            box(title="选择控件",width=4,collapsible=TRUE,status = "info",background = "black",
                  fileInput('file2', '请上传txt文件'),
                  actionButton("gofan", "输出繁体"),
                  tags$br(),
                  tags$br(),
                  textInput("wenben","请输入简体文字：","你好,世界"),
                  actionButton("view", "输出繁体"))
          ,
          tabBox(title="内容",
                 tabPanel("上传文件转换",
                          h4("结果展示"),
                          tableOutput("text1")),
                 tabPanel("输入文本转换",
                          h4("结果展示"),
                          textOutput("text2"))
              )
          )),
  
  ##na3
  tabItem(tabName = "widgets3",
          fluidRow(
            box(title="选择控件",width=4,collapsible=TRUE,status = "info",background = "lime",
                textInput("name","请输入名字:","you name"),
                actionButton("ciyun", "生成词云图"),
                helpText("你好，输入姓名点击按钮自动生成词云图，该功能暂时不完善")
  ),tabBox(title="内容",
           tabPanel("词云-love",
                    h4("词云-love"),
                    wordcloud2Output("image", width = "100%", height = "400px")),
           tabPanel("词云-用户输入",
                    h4("词云-用户输入"),
                    textOutput("yyy"))
  ))),
  
  ##na4
  tabItem(tabName = "widgets4",
          fluidRow(
            box(title="选择控件",width=4,collapsible=TRUE,status = "info",background = "yellow",
                numericInput("num2", label = "1~50之间", value = 1),
                actionButton("zaixian1", "更新页面"),
                actionButton("zaixi2", "随机选取5个"),
                tags$br(),
                helpText("服务器由shinyapps.io免费提供，所以速度较慢")
            ),
            tabBox(title="内容",
                   tabPanel("内容展示",
                            uiOutput("vire22")),
                   tabPanel("目录",
                            tableOutput("pic33"))
            ))),
  
  ##na5
  tabItem(tabName = "widgets5",
          fluidRow(
            box(title="选择控件",width=4,collapsible=TRUE,status = "info",background = "navy",
                textInput("sql","市级:","郑州"),
                textInput("sql1","县级:","郑州"),
                actionButton("tianqi", "更新页面"),
                helpText("请分别输入市县，如洛阳-伊川，信息实时来自于中国天气网"),
                tags$br(),
                helpText("服务器由shinyapps.io免费提供，所以速度较慢")   
            ),
            tabBox(title="内容",
                   tabPanel("天气查询",
                            h4("信息来自中国天气网"),
                            tableOutput("tianqi"))
            ))),
  
  ##na6
  tabItem(tabName = "widgets6",
          fluidRow(
            box(title="选择控件",width=4,collapsible=TRUE,status = "info",background = "olive",
                numericInput("kbnum", label = "1~25之间", value = 1),
                numericInput("kbnum1", label = "按照需求选择", value = 1),
                actionButton("kb2", "更新页面"),
                helpText("服务器由shinyapps.io免费提供，所以速度较慢")
            ),
            tabBox(title="内容",
                   tabPanel(uiOutput("kbui"))
                  
            ))),
  
  ##na7
  
  tabItem(tabName = "widgets7",
          fluidRow(
            box(title="选择控件",width=4,collapsible=TRUE,status = "info",background = "purple",
                numericInput("audio2", label = "1~50之间", value = 1),
                numericInput("audio1", label = "1~20之间", value = 1),
                actionButton("audiozaixian", "更新页面"),
                helpText("你好，请选择1~50代表页码，1~20代表第几页的第几个内容，请不要超过这两个数字大小"),
                tags$br(),
                helpText("服务器由shinyapps.io免费提供，所以速度较慢")
            ),
            tabBox(title="内容",
                   tabPanel("在线爬虫",
                            h4("内容来自百思不得姐声音区"),
                            tableOutput("audio11"),
                            uiOutput("audio22")),
                   tabPanel("目录",
                            h4("内容来自百思不得姐声音区"),
                            tableOutput("audio33"))
            ))),
  
  ##na8
  
  tabItem(tabName = "widgets8",
          fluidRow(
            box(title="选择控件",width=4,collapsible=TRUE,status = "info",background = "maroon",
                textInput("eng","输入英语单词:","good"),
                radioButtons("youyyy", "按照你的需求选择:",
                             list("单个查询" =TRUE,
                                  "上传文件批量查询"=FALSE
                             )),
                fileInput('fileyou', '文字文件'),
                actionButton("engan", "翻译"),
                helpText("代码原创，思想为调用有道api，rvest读取翻译返回json内容，正则表达式提取"),
                helpText("批量查询要求数据格式为hello回车good回车的txt文件"),
                helpText("暂时不支持中文转英文，后续会补充")
            ),
            tabBox(title="内容",
                   tabPanel(uiOutput("eng"))
            ))),
  
  ##na9
  tabItem(tabName = "widgets9",
          fluidRow(
            box(title="选择控件",width=4,collapsible=TRUE,status = "info",background = "black",
                numericInput("vi1", label = "1~50之间", value = 1),
                numericInput("num11", label = "1~20之间", value = 1),
                actionButton("zaixianvi1", "更新页码"),
                
                helpText("你好，请选择1~50代表页码"),
                tags$br(),
                helpText("服务器由shinyapps.io免费提供，所以速度较慢")
            ),
            tabBox(title="内容",
                   tabPanel("内容展示",tableOutput("re111"),
                     uiOutput("vire2")),
                   tabPanel("目录",
                            tableOutput("vipic33"))
            ))),
            
  ###na10
  tabItem(tabName = "widgets10",
          fluidRow(
            box(title="选择控件",width=4,collapsible=TRUE,status = "info",background = "black",   
                textInput("ditucity1","输入城市","郑州"),
                textInput("dituaddress1","输入地址","锦艺城购物中心"),
                actionButton("laia", "更新页码")
                ),
            box(title="坐标点展示",collapsible=TRUE,status = "info",background = "black", 
                       tableOutput("tabdi"))
              
            )),
  
  ##na11
  tabItem(tabName = "widgets11",
          fluidRow(
            box(title="选择控件",width=4,collapsible=TRUE,status = "info",background = "black",
                fileInput('didifile1', '请选择一个csv文件'),
                  radioButtons("dididist", "Distribution type:",
                               list("个人成功下单控制图" = "norm",
                                    "成功下单控制图" = "unif",
                                    "商家成功下单控制图" = "lnorm",
                                    "每日活跃配送员控制图" = "exp")),
                  
                  sliderInput("dididate", "距今多少天？:", 
                              min=0, max=200, value=50)
            ),
            tabBox(
              tabPanel("原始数据", tableOutput("didicontents")),
              tabPanel("作图数据", tableOutput("didicontents1")),
              tabPanel("qcc控制图", plotOutput("didiplot")),
              
              tabPanel("直方图", plotOutput("didiplot1")),
              tabPanel("正态q-q图", plotOutput("didiplot2")),
              tabPanel("日线图", textOutput("nicai"))
              
            )))
  ####

          
          
  
            
  
  
    )
  )  
  
))



