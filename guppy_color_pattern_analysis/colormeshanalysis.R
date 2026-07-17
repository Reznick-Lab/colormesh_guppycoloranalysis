library(Colormesh)
library(tidyverse)

# relative file paths 
imagedir     <- "input/"
lm_imagedir  <- "input_landmarked/"   # subset folder with only landmarked images read from the tps file
writedir     <- "output/"
tps_file     <- "merged.TPS"

# Read TPS file 
lm_array <- tps2array(tps_file)

# tps2array may not parse ID= lines correctly, so extract image names
# directly from the TPS file and assign them to the array
tps_lines  <- readLines(tps_file)
id_lines   <- tps_lines[grepl("^ID=", tps_lines)]
raw_ids    <- sub("^ID=", "", id_lines)
img_names  <- gsub("^tmp_", "", basename(raw_ids))   # strip temp-path prefix
img_names  <- sub("\\.jpg$", "", img_names)           # remove trailing .jpg added by landmark.images()

# Assign corrected names to the array's third dimension
dimnames(lm_array)[[3]] <- img_names

# Copy only the landmarked images into a dedicated subfolder so that
# tps.unwarp's internal loop (which iterates over ALL files in imagedir)
# processes only the specimens that have landmarks.
dir.create(lm_imagedir, showWarnings = FALSE)
for (f in img_names) {
  file.copy(file.path(imagedir, f), file.path(lm_imagedir, f), overwrite = TRUE)
}

# Verify all images were copied
missing <- img_names[!file.exists(file.path(lm_imagedir, img_names))]
if (length(missing) > 0) {
  warning("These images listed in the TPS are not found:\n",
          paste(missing, collapse = "\n"))
}


# Define perimeter map & sliders 
# Perimeter map defines the order of landmarks around the specimen outline
perimeter.map <- c(1, 8:17, 2, 18:19, 3, 20:27, 4, 28:42, 5, 43:52, 6, 53:54, 7, 55:62)

# Sliders: main.lms identifies which of the 62 landmarks are traditional (non-sliding)
sliders <- make.sliders(perimeter.map, main.lms = 1:7)

# Unwarp all images to consensus shape
unwarped <- tps.unwarp(
  imagedir    = lm_imagedir,
  landmarks   = lm_array,
  image.names = img_names,
  sliders     = sliders,
  write.dir   = writedir
)

# Build color sampling template via Delaunay triangulation 
# so an unwarped image must be provided even though the parameter looks optional.
# Load the first unwarped image to supply the required image dimensions.
first_unwarped <- image_reader(writedir, unwarped$unwarped.names[1])

sampling_template <- tri.surf(
  unwarped$target,
  point.map           = perimeter.map,
  num.passes          = 2,
  corresponding.image = first_unwarped
)


#. Sample colors from unwarped images 
# Extracts RGB values at each sampling point (radius = 3 pixels)
color_data <- rgb.measure(
  imagedir             = writedir,
  image.names          = unwarped$unwarped.names,
  delaunay.map         = sampling_template,
  px.radius            = 3,
  linearize.color.space = FALSE
)



# ---- 7. Quick summary ----
cat("\n--- Pipeline Summary ---\n")
cat("TPS file:         ", tps_file, "\n")
cat("Specimens:        ", dim(lm_array)[3], "\n")
cat("Landmarks:        ", dim(lm_array)[1], "\n")
cat("Sampling points:  ", nrow(sampling_template$centroids), "\n")
cat("Color array dims: ", paste(dim(color_data$rgb), collapse = " x "), "\n")
cat("Output folder:    ", writedir, "\n")



# saving extracted color data to a csv files
final.df <- make.colormesh.dataset(
  df                = color_data,
  specimen.factors  = unwarped$unwarped.names,
  use.perimeter.data = TRUE,
  write2csv         = paste0(writedir, "colormesh_rgb_data.csv")
)



###########################################
# principal components analysis
# Run PCA on the numeric color columns (drop any non-numeric/factor columns)
numeric_cols <- final.df %>% select(where(is.numeric))
# Remove constant/zero-variance columns ( landmark coordinates)
numeric_cols <- numeric_cols %>% select(where(~ sd(., na.rm = TRUE) > 0))
pca_result   <- prcomp(numeric_cols, center = TRUE, scale. = TRUE)

# Build a tidy data frame for plotting
pca_df <- tibble(
  specimen = unwarped$unwarped.names,
  PC1      = pca_result$x[, 1],
  PC2      = pca_result$x[, 2]
)

# Variance explained (for axis labels)
var_exp <- summary(pca_result)$importance[2, 1:2] * 100

# Plot PC1 vs PC2 with specimen names as labels
ggplot(pca_df, aes(x = PC1, y = PC2, label = specimen)) +
  geom_point(size = 2, alpha = 0.6) +
  geom_text(vjust = -0.8, size = 3, check_overlap = TRUE) +
  labs(
    x     = paste0("PC1 (", round(var_exp[1], 1), "% variance)"),
    y     = paste0("PC2 (", round(var_exp[2], 1), "% variance)"),
    title = "Colormesh PC1 vs PC2"
  ) +
  theme_bw()

