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


#df <- Search_Twitter("uber",n=5000)
#write.csv(df, file="./tweetsDF.csv", row.names=FALSE)

tweets_16 <- Search_Twitter("uber", since='2017-12-15', until='2017-12-16')
tweets_15 <- Search_Twitter("uber", since='2017-12-14', until='2017-12-15')
tweets_14 <- Search_Twitter("uber", since='2017-12-13', until='2017-12-14')
tweets_13 <- Search_Twitter("uber", since='2017-12-12', until='2017-12-13')
tweets_12 <- Search_Twitter("uber", since='2017-12-11', until='2017-12-12')
tweets_11 <- Search_Twitter("uber", since='2017-12-10', until='2017-12-11') #
tweets_10 <- Search_Twitter("uber", since='2017-12-9', until='2017-12-10')
tweets_9 <- Search_Twitter("uber", since='2017-12-8', until='2017-12-9')

df6 <- tweets_16[with(tweets_16, order(-nchar(text))),]
df5 <- tweets_15[with(tweets_15, order(-nchar(text))),]
df4 <- tweets_14[with(tweets_14, order(-nchar(text))),]
df3 <- tweets_13[with(tweets_13, order(-nchar(text))),]
df2 <- tweets_12[with(tweets_12, order(-nchar(text))),]
df1 <- tweets_11[with(tweets_11, order(-nchar(text))),]
df0 <- tweets_10[with(tweets_10, order(-nchar(text))),]
df00 <- tweets_9[with(tweets_9, order(-nchar(text))),]

df6 <- df6[0:1000,]
df5 <- df5[0:1000,]
df4 <- df4[0:1000,]
df3 <- df3[0:1000,]
df2 <- df2[0:1000,]
df1 <- df1[0:1000,]
df0 <- df0[0:1000,]
df00 <- df00[0:1000,]

merged3 <- bind_rows(df6, df5, df4, df3, df2, df1, df0, df00)



write.csv(merged3, file="./merged_tweets_2.csv", row.names=FALSE)

#==============================================Geo Random Generator========================================



#===============================================RANDOM==================================================




df2 <- Search_Twitter("uber", since='2017-12-16', until='2017-12-16')

#searchTwitter('charlie sheen', since='2011-03-01', until='2011-03-02')

print(dim(df))

write.csv(df2, file="./tweetsDF.csv", row.names=FALSE)
df = read.csv("out.csv", header=TRUE)

s <- wordcloud2(GetFrequencyTable(cleaned), color = brewer.pal(8,"Dark2"))
saveWidget(s,"tmp.html",selfcontained = F)
webshot("tmp.html","haha.png", delay =5, vwidth = 480, vheight=480)

brand <- "uber"

########################################## searches 
uber <- getUser(brand)

# get friends and followers of Uber's acocunt
uber.friends <- user$getFriends()
uber.followers <- user$getFollowers()
uber.network <- union(userFollowers, userFriends) # combine!

save_path = paste0("~/", "tweetsDF", ".RData")
save(df, file = save_path)


df2 <- Search_Twitter("uber",n=2000, geocode="35.18713, -117.88536,100mi")

write.csv(df2, file="./uber_tweets.csv", row.names=FALSE)




#syuzhet_vector <- get_sentiment(cleaned_tweets, method="syuzhet")

#dct_values <- get_dct_transform(
#       syuzhet_vector, 
#       low_pass_size = 5, 
#       x_reverse_len = 100,
#       scale_vals = F,
#       scale_range = T
#       )
# 
# plot(
#   dct_values, 
#   type ="l", main ="Joyce's Portrait using Transformed Values", 
#   xlab = "Narrative Time", 
#   ylab = "Emotional Valence", 
#   col = "red"
#   )
