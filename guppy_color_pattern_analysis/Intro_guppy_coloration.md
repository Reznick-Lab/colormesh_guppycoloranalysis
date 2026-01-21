# Background
Guppies show an extreme degree of polymorphisms in male color pattern, along with highly faithful transmission of color pattern phenotype along a patriline in wild populations. In simpler terms, this means that color patterns are exactly the same between grandfather, father, and offspring generations. *Figure 1* shows the color pattern phenotypes of some male lineages sampled from wild populations (this figure is described more in-depth in Potter T, et al. (2023)). Notice that orange, black, and bluish green color spots occur in the same region of the fish in father, son, and grandson. 

**Figure 1: Male color phenotypes from Potter T, et al. (2023)**
![Figure 1](science.ade5671-f1.jpg)


- Question 1: Based on the transmission pattern illustrated in Figure 1, would you predict an autosomal or sex-linked mode of inheritance in wild populations of guppies?
- Question 2: Guppies have an XY sex chromosome system, meaning that males have heteromorphic sex chromosomes. Based on what you recall about classical genetics, which chromosome would you expect to harbor the genes responsible for determining male color patterns?

# Colormesh phenotyping 
Potter et al. (2023) assess color manually by scanning the guppy pictures taken in the field station in Trinidad. For this project, however, we are going to use an unsupervised phenotyping approach, which is capable of producing multidimensional datasets. This unsupervised approach is called colormesh and is described in more detail in https://github.com/Reznick-Lab/Colormesh. 
Briefly, it requires placing 62 digital landmarks on guppy pictures similar to those illustrated in Figure 1. More details on how to landmark photos for guppy coloration analysis will be posted soon.


# Tasks for Jaime and Klarisse
1) Copy the Sorted_data_jaime folder from Mayank's hard drive
2) Edit the filenames to match the sample IDs of fish in the pictures
Use the following format for renaming '.jpeg' files and record all filenames in an Excel or Google Sheet tab

| filename              | num_fish           |
| --------------------- | ------------------ |
| 'background_photolabel' | # of fish in a pic |
Example filenames: wt_b2ylp211Fxylp211M; background = background color of photo (can be black/white), photolabel = green label stuck on the scale in each guppy photo - write down b2 (block id) and crossid information



# Cited literature
1. **Potter T**, **Arendt J**, **Bassar RD**, **Watson B**, **Bentzen P**, **Travis J**, **Reznick DN**. Female preference for rare males is maintained by indirect selection in Trinidadian guppies. _Science_ 380: 309–312, 2023. doi: [10.1126/science.ade5671](https://doi.org/10.1126/science.ade5671).
