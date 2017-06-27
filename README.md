# li6400reader
The LI-6400 is a popular instrument used to collected photosynthetic data, but the the files it produces are not easily read by many programs, typically requiring hand editing before analysis can be performed. Therefore, this package provides functions to load LI-6400 files into R with minimal hassle.

LI-6400 files have sections, each section starting with a line like "OPEN 6.3.2". Each file may have multiple sections, but because sections may have different attributes and columns, sections in a file cannot necessarily be entered into a single data frame. Therefore, to handle this, `read_6400` creates a list of data frames, one data frame for each section. For uniformity, even if a file contains only one section, a list (with exactly one data frame) is returned.

## Example usage
```r
library(li6400reader)
photosynthetic_data = read_6400('2017-01-01 field measurements')[[1]]
# A list of data frames is returned, with one data frame for each section of the LI-6400 file.
# If a file contains only one section, use "[[1]]" to access it.

# View the data.
head(photosynthetic_data$Photo)

# View the remarks.
attributes(photosynthetic_data)$remarks

# View the serial number; this requires the XML package.
attributes(photosynthetic_data)$li6400$factory$unit

# The files have many attributes, so when using str() you typically want to limit `max.level`.
str(photosynthetic_data, 1)

# Read a file from a URL.
photosynthetic_data = read_6400('https://your_file_online')[[1]]

# Access the help file.
?read_6400
```

## Installation
Download this package from GitHub. Unzip the the file and run the command below from the command line. The default file name when downloading from GitHub is shown.

### From within R
```r
setwd(path_to_unzipped_files)
install.packages('li6400reader-master', repos=NULL, type="source")  
```

### From the command line
```
cd path_to_unzipped_files
R CMD INSTALL li6400reader-master
```

