#------------------------------------------------------------------------
require(pacman)
pacman::p_load(ggplot2, sf, raster, ggspatial, ggpubr, cowplot, colorspace)
#https://awesomeopensource.com/project/EmilHvitfeldt/r-color-palettes
#------------------------------------------------------------------------
Peru        <- getData('GADM', country='Peru', level=2) %>%st_as_sf() 
Peru_dis    <- getData('GADM', country='Peru', level=3) %>%st_as_sf() 
Peru_d      <- st_centroid(Peru)                               
Peru_d      <- cbind(Peru, st_coordinates(st_centroid(Peru$geometry))) 
Cusco       <- subset(Peru_d, NAME_1 == "Cusco")
Cusco_dis   <- subset(Peru_d, NAME_1 == "Cusco")
hcl_palettes(plot = TRUE)
q6 <- sequential_hcl(13, palette = "Purple-Oran")

A <-ggplot()+
  geom_sf(data= Peru,fill=NA, color="Black", size = .1)+
  geom_sf(data= Cusco ,fill= "Black")+
  theme_void()
  
B <-ggplot()+
  geom_sf(data= Cusco, aes(fill=NAME_2), color="black", size = .1)+
  geom_sf(data= Cusco_dis, fill=NA,  color="black", size = .1)+
  scale_fill_manual(values =q6, name="Provincias")+
  ggrepel::geom_label_repel(data =  Cusco, aes(x= X, y=Y, label = NAME_2), size = 3, color="black", fontface = "bold") +
  coord_sf() +
  theme_void()+
  annotation_north_arrow(location="tr",which_north="true",style=north_arrow_fancy_orienteering ())+
  ggspatial::annotation_scale(location = "bl",bar_cols = c("grey60", "white"), text_family = "ArcherPro Book")

map_Union <-ggdraw() + 
  draw_plot(B) +
  draw_plot(A, x = 0.55, y = 0.65, width = .25, height = .25)

ggsave(plot = map_Union ,"Mapas exportados/Cusco.png", units = "cm", width = 29,height = 21, dpi = 900)# guardar grafico
#------------------------------------------------------------------------

