# li6400reader
Create data frames from LI-6400 files.

## Example usage
```r
library(li6400reader)
photosynthetic_data = read_6400('2017-01-01 field measurements')

# View the remarks.
attributes(photosynthetic_data)$remarks

# View the serial number (the XML package is required).
attributes(photosynthetic_data)$li6400$factory$unit

# Read a file from a URL.
photosynthetic_data = read_6400('https://your_file_online')

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

