## MA415 Final Project: Twitter Analytics
Use R to acquire, explore, clean and organize data. Use R packages to manipulate and analyze data. Present results with tables, plots, and interactive graphics. Produce documents, presentations, and web pages

## Structure:
- Shiny App:
	- An interactive locally-hosted app that allows you to search twitter and generates: bargraph of words and their frequencies, word cloud, and a sentimental analysis. You can use this tool to explore what tweets are about on a certain subject of your interest!
	- Files: server.R, ui.R

- Report:
	- Includes step-by-step process of collecting data/tweets, cleaning them up, and analyzing them.
	- Files: analysis.Rmd, analysis.html (must be html for the map to work), tweets.R (tweets collection)

- Presentation:
	- A summary of the analysis done in the report
	- Files: presentaion.Rmd, presentaion.html

- Datasets:
	- I collected 16000 tweets over the span of 8 days (Dec 9-15, 2017, each is 2000 tweets).
	- Files: tweetsDB.csv

- Assets:
	- Saved graphs, tables, and images for the analysis and presentaion
	- Files: multiple .png and .jpeg images, and csv tables.

## Prerequisites:
- Twitter Tokens
	- Generate your Twitter tokens to be able to search twitter. Follow the intstructions here: http://thinktostart.com/twitter-authentification-with-r/

- Packages
	- The packages below will be installed automatically when you run the shiny app or knit the markdown
	- twitteR, ROAuth, ggplot2, tm, plyr, leaflet, maps, tmap, syuzhet, Hmisc, stringr, dplyr

# How to run Shiny app:
- Shiny App: open server.R and ui.R and `run` either. It will load required packages and authenticate twitter access. I couldn't publish the app since I am doing the twitter authentication through the shiny app server.

