library(shiny)
require(wordcloud2)

shinyUI(
  fluidPage(headerPanel("MA415 Final Project: Twitter Analytics"), sidebarPanel(
    textInput ("searchTerm","Search a keyword",  value=""),
    sliderInput("maxTweets","Number of recent tweets to use for analysis", min=100, max=1000, value=100),
    submitButton(text="Analyze")),
    mainPanel(tabsetPanel(
      
      tabPanel("Frequent Words", HTML
               ("<div><h3>Most used words associated with the keyword and thier frequency in a bar graph</h3></div>"),
               plotOutput("tabledata")),
      
      tabPanel("Word Cloud", HTML("<div><h3>The most frequent words in a word cloud!</h3></div>"),
               wordcloud2Output("word", width = "100%", height = "400px")),
      
      tabPanel("Sentiment Analysis",HTML("<div><h3> Sentiment Analysis of the Tweets! </h3></div>"),
               HTML("<div><h4> In this section we categorize the words in the tweets based on their sentiment on a scale of emotions </h4></div>"), 
               plotOutput("sentiment"))
    )
  )
))