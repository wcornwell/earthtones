
##' Earthtones downloads a satellite image from google earth, translates the image into a perceptually uniform color space, runs one of a few different clustering algorhitms on the colors in the imagesearching for a user supplied number of colors, and returns the resulting color palette.  
##'
##'
##' @title Find the color pallette of a particular place on earth
##'
##' @param latitude center of the returned satellite image
##'
##' @param longitude center of the returned satellite image
##'
##' @param zoom generally this should be between 2 and 20; higher values zoom in closer to the target lat/long; for details see \code{\link{get_map}}
##'
##' @param number_of_colors how many colors do you want?
##' 
##' @param method specifies clustering method. Options are \code{\link{kmeans}} or \code{\link{pam}} (partitioning around medoids)
##' 
##' @param sampleRate subsampling factor - bigger number = more subsampling and less computation
##' 
##' @param include.map logical flag that determines whether to return the satelitte image with the data object; for exploring the world leave this as TRUE; when you've settled on a color scheme and are using this in a script, change to FALSE
##' 
##' @param ... additional arguments passed to \code{\link{get_map}}
##'
##' @details Different parts of the world have different color diversity.  Zoom is also especially important.  To visualize the results, simply print the resulting object.  
##' 
##' @seealso \code{\link{get_map}}, \code{\link{kmeans}}, \code{\link{pam}} 
##' @import grDevices stats graphics
##' @export
##' @examples
##' 
##' uluru <- get_earthtones(latitude = -25.5,
##' longitude = 131, zoom=12, number_of_colors=5)
##' 
##' \donttest{
##' world <- get_earthtones(latitude = 0, longitude = 0,
##' zoom = 2, number_of_colors = 8)
##' 
##' british_columbia_glacier <- get_earthtones(latitude = 50.759,
##' longitude = -125.673, zoom = 10, number_of_colors = 5)
##' 
##' joshua_tree <- get_earthtones(latitude = 33.9, 
##'  longitude = -115.9, zoom = 9, number_of_colors = 5)
##'  
##' ## Compare clustering methods
##' par(mfrow=c(2,1))
##' get_earthtones(latitude = 24.2,longitude = -77.88,
##' zoom = 11, number_of_colors = 5 ,method = 'kmeans', sampleRate = 500)
##' 
##' get_earthtones(latitude = 24.2, longitude = -77.88,
##' zoom = 11, number_of_colors = 5 , method = 'pam', sampleRate = 500)
##' }
##' 
##' 
##' 

get_earthtones <- function(latitude=50.759, longitude=-125.673,
                           zoom=11,number_of_colors=3,method="pam",sampleRate=500,include.map=TRUE,...) {
  # test specified method is supported
  supported_methods<-c("kmeans","pam")
  if (!method %in% supported_methods) {
    stop(paste0("method specified is not valid (typo?) or not yet supported, please choose from: ",
                paste(supported_methods, collapse = ", ")))
  }
  
  map<-ggmap::get_map(location = c(longitude,latitude), maptype ="satellite",zoom=zoom,...)
  col.out <- get_colors_from_map(map, number_of_colors, clust.method=method, subsampleRate=sampleRate)
  if (include.map){
    out.col<-list()
    out.col$pal <- col.out
    out.col$map <- map
    return(structure(out.col, class = "palette"))
  }
  if (!include.map){
    return(col.out)
  }
}
  
##' @export
print.palette <- function(x, ...) {
  number_of_colors<-length(x$pal)
  par(mfrow=c(2,1),mar = c(0.5, 0.5, 0.5, 0.5))
  plot(x$map)
  image(1:number_of_colors, 1, as.matrix(1:number_of_colors), col = x$pal,ylab = "",xlab="", xaxt = "n", yaxt = "n", bty = "n")
}



get_colors_from_map<-function(map,number_of_colors,clust.method,subsampleRate){
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
      stop("The 'cluster' package is needed for cluster.method='pam'. Please install it.",
           call. = FALSE)
    }
    out<-cluster::pam(x=lab.restructure,k=number_of_colors,diss=FALSE)
    out.rgb<-convertColor(out$medoids,from="Lab",to="sRGB",scale.out=1)
  }
  return(rgb(out.rgb))
}
