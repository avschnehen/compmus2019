
---
title: "Action vs. Comedy"
author: "Andres von Schnehen"
date: "2019"
output: 
  flexdashboard::flex_dashboard:
    orientation: columns
    vertical_layout: fill
---

```{r setup, include=FALSE}
library(flexdashboard)
library(tidyverse)
library(plotly)
library(spotifyr)
source('spotify.R')
```

Overview
=================================================

### Action vs. Comedy: Comparing Different Styles of Film Music

A film's soundtrack has a profound influence on how we perceive what we see on screen, and it is difficult to imagine movies without any background music. With the exception of musicals, our attention is rarely directed explicitly to the music, and yet our experience changes significantly because of the music.

In blockbuster movies, music is usually created or chosen for every single scene in order to underline what is happening in that scene specifically. But can we find general patterns in the types of music chosen for certain types of movies, that is, certain genres?

More specifically, are there systematic differences between music that is composed or selected for action movies and music that is composed for comedy movies? These two types of films usually entertain their audiences in quite different ways. While action movies use suspense, thrill, and impressive visual effects to excite their audience, comedy movies often provide a way for their viewers to relax, wind down, and get a feeling of happiness and pleasure. Since music is used as a means to achieve these quite different goals, it would make sense that the music composed and chosen for each genre would be quite different as well.


Audio features
==================================================

Column {data-width=650}
-----------------------------------------------------------------------

### Valence-energy map

```{r}
action <- get_playlist_audio_features('1175159882', '71EBCZ27SkMXFqJ45u9Wbi')
comedy <- get_playlist_audio_features('1175159882', '7FMw4QExCSE4bmyMmYwZ7s')
filmgenres <-
  action %>% mutate(playlist = "Action") %>%
  bind_rows(comedy %>% mutate(playlist = "Comedy"))
actioncomedy <-
  filmgenres %>%                   # Start with awards.
  ggplot(                      # Set up the plot.
    aes(
      x = valence,
      y = energy,
      colour = mode,
      label = track_name
    )
  ) +
  geom_point(alpha = 0.5) +               # Scatter plot.
  geom_rug(size = 0.1) +       # Add 'fringes' to show data distribution.
  facet_wrap(~ playlist) +     # Separate charts per playlist.
  scale_x_continuous(          # Fine-tune the x axis.
    limits = c(0, 1),
    breaks = c(0, 0.50, 1),  # Use grid-lines for quadrants only.
    minor_breaks = NULL      # Remove 'minor' grid-lines.
  ) +
  scale_y_continuous(          # Fine-tune the y axis in the same way.
    limits = c(0, 1),
    breaks = c(0, 0.50, 1),
    minor_breaks = NULL
  ) +
  scale_colour_brewer(         # Use the Color Brewer to choose a palette.
    type = "qual",           # Qualitative set.
    palette = "Dark2"       # Name of the palette is 'Paired'.
  ) +
  labs(                        # Make the titles nice.
    x = "Valence",
    y = "Energy",
    colour = "Mode"
  )
ggplotly(actioncomedy)
```

Column {data-width=350}
-----------------------------------------------------------------------

The graph on the left allows for conclusions to be drawn both about the features of film music in general, as well as about how action movie music and comedy movie music differ from each other.

It appears that in both cases, there is a large of cluster of tracks with a very low valence, approaching zero. While this is normally interpreted as sad (in the case of low energy) or angry (in the case of high energy) music, the low valence may also be a result of film music's character of being in the background and merely accompanying the visual scenes.

While valence seems to be low in general among film music, this is less true for comedy music. Compared to action film music, comedy music has especially more tracks falling in the top-right quadrant of the valence-energy map, which is considered the quadrant describing 'happy' music. This make intuitive sense - we expect music in comedy films to be uplifting, funny, happy. 
On the other hand, a lot more action movie tracks than comedy movie tracks seem to fall in the top-left quadrant, usually describing 'angry' music. Again, this is in line with our intuitions about music in action movies: Fast-paced, suspenseful, intense but not usually very happy-sounding.

The graph also seems to suggest that comedy soundtracks contain more major songs compared to action soundtracks, a pattern that will be explored on the next page.


Major-minor songs
============================================

Column {data-width = 700}
-------------------------------------------------------

```{r}
ost_action <- get_playlist_audio_features('1175159882', '71EBCZ27SkMXFqJ45u9Wbi')
ost_comedy <- get_playlist_audio_features('1175159882', '7FMw4QExCSE4bmyMmYwZ7s')

action_mode <- data.frame(pull(ost_action, var = mode), "action")
comedy_mode <- data.frame(pull(ost_comedy, var = mode), "comedy")

colnames(action_mode)[1] <- "mode"
colnames(action_mode)[2] <- "genre"
colnames(comedy_mode)[1] <- "mode"
colnames(comedy_mode)[2] <- "genre"

mode <- add_row(action_mode, mode = comedy_mode$mode, genre = comedy_mode$genre)

majorminorplot <- ggplot(mode, aes(x= mode, fill = mode)) +
  geom_bar(show.legend = FALSE) +
  facet_wrap(genre ~ .) +
  labs(x = "Mode", y = "Number of tracks") +
  scale_fill_manual(values=c("#2ca25f", "#de2d26"))

ggplotly(majorminorplot)
```

Column {data-width = 300}
-------------------------------------------------------

The bar graph confirms the expectation stated on the previous page that comedy movie songs indeed are more likely than action movie songs to be in a major key. Moreover, it appears that generally film music is more often in a a major rather than minor key.