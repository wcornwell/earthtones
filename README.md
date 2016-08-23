earthtones
================

Here is how to install the package:

``` r
if(!require(devtools)) install.packages("devtools")
install_github("wcornwell/earthtones")
library(earthtones)
```

Geographic color schemes
------------------------

Let's say you wanted a color scheme based on a particular part of the world. For example the grand canyon.

``` r
grand_canyon<-plot_satellite_image_and_pallette(latitude = 36.094994,
                                                longitude=-111.837962,zoom=12,number_of_colors=5)
```

![](readme_files/figure-markdown_github/grand%20canyon-1.png)

`number_of_colors` corresponds to how many colors you want back. The zoom value is passed to `ggmap`--essentially larger values zoom closer to the target lat+long.

Or maybe you want a color scheme drawn from tropical reefs and lagoons.

``` r
bahamas<-plot_satellite_image_and_pallette(latitude = 24.2,
                                           longitude=-77.88,zoom=11,number_of_colors=5)
```

    ## Map from URL : http://maps.googleapis.com/maps/api/staticmap?center=24.2,-77.88&zoom=11&size=640x640&scale=2&maptype=satellite&language=en-EN&sensor=false

![](readme_files/figure-markdown_github/bahamas-1.png)

Just pick your favorite place in the world, and find out the major colors

``` r
uluru<-plot_satellite_image_and_pallette(latitude = -25.5,longitude = 131,zoom=10,number_of_colors=5)
```

![](readme_files/figure-markdown_github/uluru-1.png)

The function `plot_satellite_image_and_pallette` is good for seeing both the image and the color palette. To actually use the color, it's much easier to use `get_earthtones`. For example:

``` r
if(!require(ggplot2)) install.packages("ggplot2")
library(ggplot2)
bahamas_colors <- get_earthtones(latitude = 24.2,
      longitude=-77.88, zoom=11,number_of_colors=3)
ggplot(iris,aes(x=Petal.Length,y=Petal.Width,col=Species))+
  geom_point(size = 2.5)+
  scale_color_manual(values = bahamas_colors)+
  theme_bw()
```

![](readme_files/figure-markdown_github/bahama%20iris-1.png)

And now Fisher's irises are colored in a Bahama style. Actually the irises were collected by a botanist named Edgar Anderson from the Gaspé Peninsula in Quebec, so it might be better to use a color scheme from there:

``` r
plot_satellite_image_and_pallette(latitude = 48.7709,
  longitude=-64.660939,zoom=9,number_of_colors = 3)
```

![](readme_files/figure-markdown_github/gaspe-1.png)

    ## [1] "#223C2C" "#425942" "#4A5F97"
    ## attr(,"class")
    ## [1] "palette"

``` r
gaspe<-get_earthtones(latitude = 48.7709,
  longitude=-64.660939,zoom=9,number_of_colors = 3)
ggplot(iris,aes(x=Petal.Length,y=Petal.Width,col=Species))+
  geom_point(size = 2)+
  scale_color_manual(values = gaspe)+
  theme_bw()
```

![](readme_files/figure-markdown_github/gaspe-2.png)

Methods details
---------------

1.  This library gets an image from Google earth which come from different sources depending on the zoom and the particular place.

2.  It then extracts the colors in the image, translates them into a perceptually uniform color space and then runs k-means clustering algorithm to find the major colors for an area

3.  These are then converted back into a R style color pallete.
