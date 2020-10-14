#
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


# ui setup ----

ui <- dashboardPage(title = "Finbot",
                    
                    dashboardHeader(title = span(width=12,
                      # title formatted to include 'data science' logo
                      img(src = "ESFA Data Science Logo Teal and White.png",
                          height = "100%", style = "padding-bottom: 3px; padding-right: 15px"),
                      "Finbot"
                    ), titleWidth = "13cm"),
                    dashboardSidebar(disable = TRUE
                 
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
                          .content {
                          margin-top: 50px;
                          }
                          *{
                          font-family: Verdana;
                          }
                          .answer{
                          font-size: 20px
                          }
                          #buttons {
                          display: flex;
                          justify-content: center;
                          align-items: center;
                          
                          }
                         
                          "
      ))
                        ),
      
      
        
        # README tab ----
        
        tabItem("Summary",useShinyjs(),
                fluidRow(
                  box(width = 12, 
                      status = "primary",
                      column(width = 8,
                      h3("Finbot overview"),
                      p("FinBot seeks to answer all your frequently asked questions about finance, including queries about business cases, VAT and other general finance queries. So if you want to find out how to pay an invoice or who your FBP is, simply input your question and press 'Submit'."),
                      p("We hope FinBot will help you with your query, but if it doesn't, please let us know by selecting whether the answer was helpful or not.  That way, we can update FinBot and improve it for everyone at DfE. We would love to hear any other feedback you have so please let us know at"),
                      a(href="mailto:Financial.ASSURANCE@education.gov.uk", "Financial.ASSURANCE@education.gov.uk")),
                     
                     
                    
                    column(width = 4, img(src = "DfE Finance Sign.jpg", style = "width: 70%; padding-top: 30px; align: center")),
                    
                    column(width = 12, 
                        h3("How to use the search tool"),
                        tags$ol(
                          tags$li("Enter your question in the left panel."),
                          tags$li("Press submit."),
                          tags$li("The answer will appear in the bottom panel."),
                          tags$li("Please utilise the feedback options to the right of the answer to help us improve this app."))
                        
                    )
                      )
                    ),
                
                fluidRow(
                  box(width = 12,  height = "220px", 
                      status = "primary",
                      column(width= 8,
                             h3("Please enter your question."),
                             textInput("question", ""),
                             #p(" "),
                             actionButton("button", "Submit"))
                             ),
                  box(width = 7,  height = 240,
                      status = "primary",
                      column(width = 12, id = "answer",
                             h3("Answer:", align = "center"),
                             p("")),
                      column(width = 12, htmlOutput("answer"))
                      
                  ),
                  box(width = 5, height = 240,
                      status = "primary",
                      column(width = 12, id = "feedback",
                             status = "primary",
                             h3("Was this answer helpful?", align = "center"),
                             column(width= 12, id="buttons",
                                    actionButton("btn_Yes", "Yes"),
                                    actionButton("btn_No", "No"))),
                      column(width = 12, id = "Answer_feedback",
                             status = "primary",
                             h3("Please select your reason as to why you didn't find the answer helpful. Once your reason is chosen please press Send"),
                             selectInput("select", label = "", choices = mylist),
                             actionButton("btn_send", "Send")),
                      column(width = 12, id = "Thanks_yes",
                             status = "primary",
                             h3("Response:", align = "center"),
                             p("That's great that we answered your question. We would love to hear any other feedback you have so please let us know at", a(href="mailto:Financial.ASSURANCE@education.gov.uk", "Financial.ASSURANCE@education.gov.uk"), ".")),
                      column(width = 12, id = "Thanks_no",
                             status = "primary",
                             h3("Response:", align = "center"),
                             p("Sorry that we were not able to answer your question this time. Please email", a(href="mailto:Financial.ASSURANCE@education.gov.uk", "Financial.ASSURANCE@education.gov.uk"), "and we will investigate your question further."))
                      )),

                fluidRow(
                  box(width = 12, id = "History",  
                      status = "primary",
                      h3("History:", align = "center"),
                     

                      
                      
                      
                      
                      
                     
                
                      DT::dataTableOutput("Q_A")))
                ))
)
