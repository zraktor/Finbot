# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#



library(shiny)
library(shinydashboard)
library(shinyjs)
library(readxl)
library(dplyr)

# ui setup ----

ui <- dashboardPage(title = "Finbot version 2",
                    
                    dashboardHeader(title = span(
                      # title formatted to include 'data science' logo
                      img(src = "ESFA Data Science Logo Teal and White.png",
                          height = "50%", style = "padding-bottom: 3px; padding-right: 15px"),
                      "Finbot version 2"
                    ), titleWidth = "13cm"),
                    
                    dashboardSidebar(
                      
                      sidebarMenu(id ="tabs",
                                  menuItem("main", tabName = "main")
                               
                                  
                      )
                    ),
                    
                    dashboardBody(
                      
                      tags$head(
                        tags$style(HTML(
                          ".main-header{
                          position: fixed;
                          width: 100%;
                          }
                          .main-header .logo{
                          text-align: left;
                          padding-left: 5px;
                          }
                          .sidebar{
                          position: fixed;
                          width: 230px;
                          }
                          .sidebar-collapse .main-sidebar {
                          display:none;
                          }
                          .content {
                          margin-top: 50px;
                          }
                          *{
                          font-family: Verdana;
                          }"
                        ))
                      ), 
                      
                      
                      
                      # README tab ----
                      tabItems(
                        
                      
                      # Staff Costs and Benefits tab ----
                      tabItem("main",
                              
                              
                              fluidRow(
                                box(width = 12, style = "margin-top: 25px;",
                                    status = "primary",
                                    column(width = 8,
                                           h2("Finbot version 2"),
                                           p("description text
                                 "),
                                           ),
                                    
                                    column(width = 4, img(src = "ai_logo.jpg", height="20%", width="20%", align="right"))
                                )),
                              
                              
                              fluidRow(box(width = 10,
                                           
                                           htmlOutput("chatbox")
                                           
                                           
                                           ),
                              
                              
                         
                                
                                box(width= 10,
                                    
                                    textInput("message_field", "Your message"),
                                    actionButton("send", "Send")
                                    
                                    )
                                
                              )
                              
                              
                        
                                    
                               
                      )
                              
                              
                              #close bracket for tab items                           
                      )
                      
                      #close bracket for dashboard body
                    )
                    
                    #close bracket for dashboard page
)