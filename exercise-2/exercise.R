### Exercise 2 ###

# Load the httr and jsonlite libraries for accessing data
library("dplyr")
library("httr")
library("jsonlite")

# Create a `base.uri` variable that holds the base uri. You wil then paste endpoints to this base.
base.url <- "https://api.spotify.com"


## As you may have noticed, it often takes multiple queries to retrieve the desired information.
## This is a perfect situation in which writing a function will allow you to better structure your
## code, and give a name to a repeated task!

# Define a function `TopTrackSearch` that takes in an artist name as an argument,
# and returns the top 10 tracks (in the US) by that artist
TopTrackSearch <- function(artist) {
  
  # Getting the resource that we want
  resource <- "/v1/search"
  
  # Specifying the URI that we will use
  uri <- paste0(base.url, resource)
  
  # Setting our query parameters to match the required parameters
  query.params <- list(q = artist, type = "artist")
  
  # Getting the artist's id
  response <- GET(uri, query = query.params)
  artist.information <- fromJSON(content(response, "text"))
  artist.id <- artist.information$artists$items$id[1]
  
  # Obtaining the artist's album information
  resource <- paste0("/v1/artists/", artist.id, "/top-tracks")
  uri <- paste0(base.url, resource)
  query.params <- list(country = "US")
  response <- GET(uri, query = query.params)
  top.10.tracks <- fromJSON(content(response, "text"))
  return(top.10.tracks$tracks)
}



# What are the top 10 tracks by Beyonce?
top.queen.b.tracks <- TopTrackSearch("Beyonce")

# Use the `flatten` function to flatten the data.frame -- note what differs!
# It brings out the columns within the data frames that are in the "outer" data frame
top.queen.b.tracks <- flatten(top.queen.b.tracks)

# Use the `save()` function to save the flattened data frame to a file `beyonce.Rdata`
save(top.queen.b.tracks, file = "beyonce.Rdata")

# Use your `dplyr` functions to get the number of the songs that appear on each album
num.songs.on.albums <- top.queen.b.tracks %>%
                       group_by(album.name) %>%
                       summarise(num_songs = n())
num.songs.on.albums


### Bonus ###
# Write a function that allows you to specify a search type (artist, album, etc.), and a string,
# that returns the album/artist/etc. page of interest


# Search albums with the word "Sermon"
