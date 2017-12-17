library(twitteR)
library(ROAuth)

# twitter auth vars
CONSUMER_KEY="n0VQmi2OXrFQxoPvYvx2FIknI"
CONSUMER_SECRET="hTkHfzJrIzQvpwAJLZAQYoyz3iryEEbX8gBlJloQedr51pNlRw"
TOKEN="871919779426308099-Yn40D6rcq7zcC2qJowKB8aUvgSLpZVt"
TOKEN_SECRET="aOBkoIl6wJXYcHMgstf9BuK3OapE5DNKMyr0sfycr3tQE"

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

Search_Twitter <- function(key_word, n=2000, since=NULL, until=NULL) {
  # contructing the search clause
  search_term <- paste0('@', key_word, ' OR ', key_word, ' OR ', '#', key_word)
  
  # print
  print(paste0("searching: ", search_term))
  
  # search twitter
  twtList <- searchTwitter(search_term, n=n, lang="en", retryOnRateLimit=1, since=since, until=until)
  #twtList <- strip_retweets(twtList, strip_manual = TRUE, strip_mt = TRUE)
  
  # convert to a dataframe and return
  return (twListToDF(twtList))
}

# Call the functions
Authentication()

tweets_16 <- Search_Twitter("uber", since='2017-12-15', until='2017-12-16')
tweets_15 <- Search_Twitter("uber", since='2017-12-14', until='2017-12-15')
tweets_14 <- Search_Twitter("uber", since='2017-12-13', until='2017-12-14')
tweets_13 <- Search_Twitter("uber", since='2017-12-12', until='2017-12-13')
tweets_12 <- Search_Twitter("uber", since='2017-12-11', until='2017-12-12')
tweets_11 <- Search_Twitter("uber", since='2017-12-10', until='2017-12-11') #
tweets_10 <- Search_Twitter("uber", since='2017-12-9', until='2017-12-10')
tweets_9 <- Search_Twitter("uber", since='2017-12-8', until='2017-12-9')

merged4 <- bind_rows(tweets_16, tweets_15, tweets_14,
                     tweets_13, tweets_12, tweets_11,
                     tweets_10, tweets_9)

write.csv(merged4, file="./tweetsDB.csv", row.names=FALSE)
