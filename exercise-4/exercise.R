### Exercise 4 ###
library("httr")
library("jsonlite")
library("dplyr")

# Use `source()` to load your API key variable.
# Make sure you've set your working directory!
source("apikey.R")

# Define a function that takes in the name of a movie as an argument and returns
# a list of information about that movie. The steps for this algorithm are below:


# The resource is `reviews/search.json`
# See the interactive console for more detail:
#   https://developer.nytimes.com/movie_reviews_v2.json#/Console/GET/reviews/search.json
# You should use YOUR api key (as the `api-key` parameter)







# From the most recent review, store the headline, short summary, and link to
# the full article, each in their own variables


# Return an list of the three pieces of information from above


InfoAboutMovie <- function(movie) {
  
  # Send the HTTP Request to download the data
  # Extract the content and convert it from JSON
  my.query <- list(query = movie, "api-key" = my.api.key)
  
  # Construct an HTTP request to search for reviews for the given movie.
  # The base URI is `https://api.nytimes.com/svc/movies/v2/`
  response <- GET("https://api.nytimes.com/svc/movies/v2/reviews/search.json", query = my.query)
  
  # What kind of data structure did this return?
  # a data frame
  
  # Manually inspect the returned data and identify what content you wish to work with
  # Flatten that content into a data structure called `reviews`
  body <- fromJSON(content(response, "text"))
  reviews <- flatten(body$results)
  reviews <- filter(reviews, display_title == movie)
  
  mpaa.rating <- reviews$mpaa_rating
  headline <- reviews$headline
  short.summary <- reviews$summary_short
  full.article <- reviews$link.url
  
  results <- list(mpaa.rating, headline, short.summary, full.article, stringsAsFactors = FALSE)
}

# Test that your function works with a movie of your choice
print(InfoAboutMovie("The Martian"))


