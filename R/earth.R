
##' Getting a color scheme from a place on earth
##'
##'
##' @title earthtones
##'
##' @param latitude
##'
##' @param longitude
##'
##' @param zoom
##'
##' @param number_of_colors
##' 
##' @param method specifies clustering method. Options are \code{kmeans} or \code{pam} (partitioning around medoids)
##' 
##' @param sampleRate subsampling factor - bigger number = more subsampling 
##'
##' @import grDevices stats graphics
##' @export
##' @examples
##' #
##' #
##' uluru<-get_earthtones(latitude = -25.5,
##' longitude = 131,zoom=12,number_of_colors=5)
##' print(uluru)
##' 
##' world<-get_earthtones(latitude = 0,longitude = 0,
##' zoom=2,number_of_colors=8)
##' plot(world)
##' 
##' british_columbia_glacier<-get_earthtones(latitude = 50.759
##'  ,longitude = -125.673,zoom=10,number_of_colors=5)
##' plot(british_columbia_glacier)
##' 
##' joshua_tree<-get_earthtones(latitude = 33.9, 
##'  longitude = -115.9,zoom=9,number_of_colors=5)
##' plot(joshua_tree)
##' 
##' par(mfrow=c(2,1))
##' bahamas<-get_earthtones(latitude = 24.2,longitude=-77.88,
##' zoom=11,number_of_colors=5)
##' plot(bahamas)
##' 
##' bahamas<-get_earthtones(latitude = 24.2,longitude=-77.88,
##' zoom=11,number_of_colors=5,method='pam',sampleRate=500)
##' plot(bahamas)
##' 
##' 
##' 

get_earthtones <- function(latitude=50.759, longitude=-125.673,
                           zoom=11,number_of_colors=3,method="kmeans",sampleRate=500) {
  # test specified method is supported
  supported_methods<-c("kmeans","pam")
  if (!method %in% supported_methods) {
    stop(paste0("method specified is not valid (typo?) or not yet supported, please choose from: ",
                paste(supported_methods, collapse = ", ")))
  }
  
  map<-ggmap::get_map(location = c(longitude,latitude), maptype ="satellite",zoom=zoom)
  out.col <- get_colors_from_map(map, number_of_colors, clust.method=method, subsampleRate=sampleRate)
  return(structure(out.col, class = "palette"))
}
  
  
  #' @export
plot.palette <- function(x, ...) {
    n <- length(x)
    old <- par(mar = c(0.5, 0.5, 0.5, 0.5))
    on.exit(par(old))
    
    image(1:n, 1, as.matrix(1:n), col = x,
          ylab = "", xaxt = "n", yaxt = "n", bty = "n")
    
    #rect(0, 0.9, n + 1, 1.1, col = rgb(1, 1, 1, 0.8), border = NA)
    #text((n + 1) / 2, 1, labels = attr(x, "name"), cex = 1, family = "serif")
}


##' This returns a color scheme from a geographic place but 
##' as a side product, it plots a map of the satellite image along with the color pallette.
##'
##'
##' @title plot_satellite_image_and_pallette
##'
##' @param latitude
##'
##' @param longitude
##'
##' @param zoom
##'
##' @param number_of_colors
##' 
##' @param method specifies clustering method. Options are \code{kmeans} or \code{pam} (partitioning around medoids)
##' 
##' @param sampleRate subsampling factor - bigger number = more subsampling 
##'
##' @export
##' @examples
##' #
##' #
##' uluru<-plot_satellite_image_and_pallette(latitude = -25.5,
##' longitude = 131,zoom=10)
##' 
##' 
##' world<-plot_satellite_image_and_pallette(latitude = 0,longitude = 0,
##' zoom=2,number_of_colors=4)
##' 
##' british_columbia_glacier<-plot_satellite_image_and_pallette(latitude = 50.759,
##' longitude = -125.673,zoom=10,number_of_colors=4)
##' 
##'  joshua_tree<-plot_satellite_image_and_pallette(latitude = 33.9,
##'  longitude = -115.9,zoom=9,number_of_colors=5)
##' 
##' bahamas<-plot_satellite_image_and_pallette(latitude = 24.2,
##' longitude=-77.88,zoom=11,number_of_colors=5)
##' 
##' 
##' rio_negro_amazon_mixing<-plot_satellite_image_and_pallette(latitude = -3.0817,
##' longitude=-60.49666,zoom=10,number_of_colors=3)
##' 
##' grand_canyon<-plot_satellite_image_and_pallette(latitude = 36.094994,
##' longitude=-111.837962,zoom=12,number_of_colors=6)
##' 

plot_satellite_image_and_pallette <- function(latitude = 24.2,longitude=-77.88,zoom=11,
                                              number_of_colors=2,method="kmeans",sampleRate=50) {
  map <- ggmap::get_map(location = c(longitude,latitude),maptype ="satellite",zoom=zoom)
  col.pal <- get_colors_from_map(map,number_of_colors=number_of_colors,clust.method=method,subsampleRate=sampleRate)
  par(mfrow=c(2,1),mar = c(0.5, 0.5, 0.5, 0.5))
  plot(map)
  image(1:number_of_colors, 1, as.matrix(1:number_of_colors), col = col.pal,ylab = "",xlab="", xaxt = "n", yaxt = "n", bty = "n")
  return(structure(col.pal, class = "palette"))
}



get_colors_from_map<-function(map,number_of_colors,clust.method=method,subsampleRate=sampleRate){
  if (subsampleRate < 300 & clust.method=="pam") {
    message("Pam can be slow, consider a larger sampleRate?")
  }
  sample.systematically<-seq(from=1,to=length(map),by=subsampleRate) #this is just to speed things up
  col.vec<-c(map[sample.systematically])
  col.vec.rgb<-t(col2rgb(col.vec))
  col.vec.lab<-convertColor(col.vec.rgb,from="sRGB",to="Lab",scale.in=255)
  lab.restructure<-data.frame(L=col.vec.lab[,1],a=col.vec.lab[,2],b=col.vec.lab[,3])
  if (clust.method=="kmeans"){
    out<-kmeans(lab.restructure,number_of_colors)
    out.rgb<-convertColor(out$centers,from="Lab",to="sRGB",scale.out=1)
  }
  if (clust.method=="pam"){
    if (!requireNamespace("cluster",quietly=TRUE)) {
      stop("The 'cluster' package is needed for method='pam'. Please install it.",
           call. = FALSE)
    }
    out<-cluster::pam(x=lab.restructure,k=number_of_colors,diss=FALSE)
    out.rgb<-convertColor(out$medoids,from="Lab",to="sRGB",scale.out=1)
  }
  return(rgb(out.rgb))
}


  