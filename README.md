# li6400reader
Create data frames from a LI-6400 files.

## Example usage
```r
photosynthetic_data = read_6400('2017-01-01 field measurements')
```

### View the rem#arks.
```r
attributes(photosynthetic_data)$remarks
```

### View the serial number (the XML package is required).
```r
attributes(photosynthetic_data)$li6400$factory$unit
```

