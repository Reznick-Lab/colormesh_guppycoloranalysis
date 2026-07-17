library(Colormesh)

lm_imagedir <- "landmarking_demo/"   # folder containing images to landmark
tps_out     <- "input_landmarked.TPS"  # where the new landmark file will be saved

# number of landmarks
n_landmarks <- 62

#list of image names
img_files <- list.files(lm_imagedir, pattern = "\\.JPG$|\\.jpg$|\\.png$|\\.PNG$",
                        full.names = FALSE)

# landmarking loop
lm_array <- landmark.images(
  imagedir      = lm_imagedir,
  image.names   = img_files,
  nlandmarks    = n_landmarks,
  writedir      = lm_imagedir,
  tps.filename  = tps_out
)
