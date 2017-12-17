# uncomment this line to supress warnings
#options(warn=-1)

# Installing package if not already installed (Stanton 2013)
GetPackage<-function(x) {x <- as.character(x)
 if (!require(x,character.only=TRUE))
 {
   install.packages(pkgs=x,repos="http://cran.r-project.org")
   require(x,character.only=TRUE)
 }
}

# installs (if necessary) and loads the needed packages
PrepareLibraries<-function() {
  GetPackage("twitteR")
  GetPackage("ROAuth")
  GetPackage("ggplot2")
  GetPackage("tm")
  GetPackage("wordcloud2")
  GetPackage("plyr")
  GetPackage("RColorBrewer")
  GetPackage("syuzhet")
}

# Call the function
PrepareLibraries()

# Sets up twitter authentication
Authentication<-function() {
  
  # twitter auth vars
  CONSUMER_KEY="n0VQmi2OXrFQxoPvYvx2FIknI"
  CONSUMER_SECRET="hTkHfzJrIzQvpwAJLZAQYoyz3iryEEbX8gBlJloQedr51pNlRw"
  TOKEN="871919779426308099-Yn40D6rcq7zcC2qJowKB8aUvgSLpZVt"
  TOKEN_SECRET="aOBkoIl6wJXYcHMgstf9BuK3OapE5DNKMyr0sfycr3tQE"
  
  # twitter auth set-up
  setup_twitter_oauth(consumer_key=CONSUMER_KEY,
                      consumer_secret=CONSUMER_SECRET,
                      access_token=TOKEN,
                      access_secret=TOKEN_SECRET)
}

# Call the function
Authentication()

shinyServer(function(input, output) {

  ############################################################### Tweets Collection and Cleaning
  # takes a dataframe of tweet objects then extracts and cleans text
  CleanTweets <- function(df) {
      # extract text
      clean_text = df$text
      
      #removes emoticons #ref: (Hicks , 2014)
      clean_text <- sapply(clean_text,function(row) iconv(row, "latin1", "ASCII", sub=""))
      clean_text = gsub("&amp", "", clean_text)       # & sign
      clean_text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", clean_text)  #retweets
      clean_text = gsub("@\\w+", "", clean_text)        # @'s
      clean_text = gsub("[[:punct:]]", "", clean_text)  # punctuation
      clean_text = gsub("[[:digit:]]", "", clean_text)  # digits
      clean_text = gsub("http\\w+", "", clean_text)     # urls
      clean_text = gsub("[ \t]{2,}", "", clean_text)    # brakets curly and sq
      clean_text = gsub("^\\s+|\\s+$", "", clean_text)  # spaces
      
      # remove common words 
      # collected common words in english
      common_words <- c('the', 'and', 'that', 'it', 'not', 'he', 'as', 'you',
                        'this', 'but', 'his', 'they', 'her', 'she', 'or', 'an', 'will',
                        'my', 'one', 'all', 'would', 'there', 'the', 'to', 'of', 'in',
                        'for', 'on', 'with', 'at', 'by', 'from', 'about', 'into',
                        'over', 'after')
      for (word in common_words) {
        clean_text = gsub(word, "", clean_text)
      }
      
      # also the search term!
      clean_text = gsub(tolower(input$searchTerm), "", clean_text)
      clean_text = gsub(toupper(input$searchTerm), "", clean_text)
      
      return (clean_text)
  }
  
  # searched twitter and converts tweets to a dataframe
	GetTweets <- reactive({
	  # prepare the search term: logic combination
	  search_term <- 
	    paste0('@', input$searchTerm, ' OR ', input$searchTerm, ' OR ', '#', input$searchTerm)
	  
	  # search twitter and remove retweets and mentions
	  twtList <- searchTwitter(search_term, n=input$maxTweets, lang="en", retryOnRateLimit=120)
	  twtList <- strip_retweets(twtList, strip_manual = TRUE, strip_mt = TRUE)
	  
	  return (twListToDF(twtList))
	})
	
	# calls GetTweets() and CleanTweets(), returns cleaned tweets
	tweets <- reactive({ tweets <- CleanTweets(GetTweets()) })
	
	############################################################### Frequency Function
	GetFrequencyTable <- function(twts) {
	  mach_corpus = Corpus(VectorSource(twts))
	  
	  # create document term matrix applying some transformations
	  tdm = TermDocumentMatrix(mach_corpus,
	                           control = list(removePunctuation = TRUE,
	                                          removeNumbers = TRUE,
	                                          stopwords = TRUE,
	                                          wordLengths=c(3,Inf),
	                                          tolower = TRUE))
	  m = as.matrix(tdm)
	  
	  # get word counts in decreasing order
	  word_freqs = sort(rowSums(m), decreasing=TRUE) 
	  
	  # create a data frame with words and their frequencies
	  dm = data.frame(words=names(word_freqs), freq=word_freqs, ordered = TRUE)
	  return (dm)
	}
	
	############################################################### Freq Bars
	output$tabledata <- renderPlot({
	  # get frequency table
	  twts <- GetFrequencyTable(tweets())
	  
	  # order the rows by the frequencies column
	  twts = within(twts, freq <- factor(freq, levels=names(sort(table(freq), decreasing=TRUE))))
	  twts <- head(twts, n=15)

	  # generate colors for the bars! 
	  qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
	  col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
	  
	  # plot!
	  print(ggplot(twts, aes(x=words, y=freq)) + geom_bar(alpha = 0.8, stat = "identity", fill=sample(col_vector, 15)) +
	    xlab("Terms") + ylab("Count") + theme(text = element_text(size=20),
	               axis.text.x = element_text(angle=90, hjust=1)) + coord_flip())
	  })

	############################################################### Word Cloud
	output$word<-renderWordcloud2({ 
	  wordcloud2(GetFrequencyTable(tweets()), color = brewer.pal(8,"Dark2"))
	  })

	############################################################### Sentimental Analysis
	
	GetSentimentalTable <- reactive({
	  # get tweets
	  twts_txt <- tweets()
	  
	  # analyze with the library
	  ext_sentiment <- get_nrc_sentiment(twts_txt)
	  
	  # aggregate sentiments into a new object
	  sentimentTotals <- data.frame(colSums(ext_sentiment))
	  
	  # give column names
	  names(sentimentTotals) <- "count"
	  sentimentTotals <- cbind("sentiment" = rownames(sentimentTotals), sentimentTotals)
	  rownames(sentimentTotals) <- NULL
	  
	  return (sentimentTotals)
	})
	
	plotSentiment <- function(sentiment_dataframe) {
	  print(ggplot(sentiment_dataframe, aes(x = sentiment, y = count)) +
	          geom_bar(aes(fill = sentiment), stat = "identity") +
	          theme(legend.position = "none") +
	          xlab("Sentiment") + ylab("Total Count") + ggtitle("Sentiment Graph"))
	}
	
	output$sentiment <-renderPlot({
	  sentiment_dataframe <- GetSentimentalTable()
	  plotSentiment(sentiment_dataframe)
	})

})

