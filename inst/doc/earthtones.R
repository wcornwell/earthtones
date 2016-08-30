## ----setup, include=FALSE,message=FALSE,warning=FALSE--------------------
library("earthtones")
requireNamespace("ggplot2", quietly = TRUE)

## ----grand canyon,message=FALSE,dpi=300----------------------------------
get_earthtones(latitude = 36.094994, longitude=-111.837962, 
               zoom=12, number_of_colors=8)

## ----bahamas,message=FALSE,dpi=300---------------------------------------
get_earthtones(latitude = 24.2, longitude=-77.88, zoom=11, number_of_colors=5)

## ----sf,message=FALSE,dpi=300--------------------------------------------
get_earthtones(latitude = 37.89, longitude=-122.28, zoom=11, number_of_colors=12)

## ----ggb,message=FALSE,dpi=300-------------------------------------------
get_earthtones(latitude = 37.81391, longitude=-122.478289, zoom=19, number_of_colors=12)

## ----opera,message=FALSE,dpi=300-----------------------------------------
get_earthtones(latitude = -33.857077, longitude=151.214722, zoom=17, number_of_colors=12)

## ----bahama_iris,message=FALSE,dpi=100-----------------------------------
require(ggplot2)
bahamas_colors <- get_earthtones(latitude = 24.2,
      longitude=-77.88, zoom=11, number_of_colors=3,include.map=FALSE)
ggplot2::ggplot(iris, aes(x=Petal.Length, y=Petal.Width, col=Species))+
  geom_point(size = 2)+
  scale_color_manual(values = bahamas_colors)+
  theme_bw()

## ----gaspe,message=FALSE,dpi=100-----------------------------------------
iris.from.gaspe <- subset(iris, iris$Species!="virginica")

get_earthtones(latitude = 48.7709,
  longitude=-64.660939,zoom=9,number_of_colors = 2)
gaspe <- get_earthtones(latitude = 48.7709,
  longitude=-64.660939 ,zoom=9, number_of_colors = 2,include.map=FALSE)
ggplot2::ggplot(iris.from.gaspe, aes(x=Petal.Length, y=Petal.Width,col=Species))+
  geom_point(size = 2)+
  scale_color_manual(values = gaspe)+
  theme_bw()

## ----bahamas_kmeans,message=FALSE,dpi=300--------------------------------
get_earthtones(latitude = 24.2, longitude=-77.88,
               zoom=11, number_of_colors=5, method="kmeans")

## ----bahamas_pam,message=FALSE,dpi=300-----------------------------------
get_earthtones(latitude = 24.2, longitude=-77.88, 
               zoom=11, number_of_colors=5, method="pam")

