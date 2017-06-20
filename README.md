# li6400reader
Create data frames from LI-6400 files.

## Example usage
```r
library(li6400reader)
photosynthetic_data = read_6400('2017-01-01 field measurements')[[1]]
# A list of data frames is returned, with one item for each section of the 6400 file. If there is only one section, use "[[1]]" to access it.

# View the remarks.
attributes(photosynthetic_data)$remarks

# View the serial number (the XML package is required).
attributes(photosynthetic_data)$li6400$factory$unit

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

