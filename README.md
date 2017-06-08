# li6400reader
Create data frames from LI-6400 files.

## Example usage
```r
photosynthetic_data = read_6400('2017-01-01 field measurements')

# View the remarks.
attributes(photosynthetic_data)$remarks

# View the serial number (the XML package is required).
attributes(photosynthetic_data)$li6400$factory$unit

# Read a file from a URL.
url_connection = 'https://your_file_online'
photosynthetic_data = read_6400(url_connection)
close(url_connection)
```

## Installation
Download this package from GitHub. Unzip the the file and run the command below from the command line. The default file name when downloading from GitHub is shown.
```
R CMD INSTALL li6400reader-master
```

