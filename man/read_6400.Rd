\name{read_6400}
\alias{read_6400}
\title{Read LI-6400 files into data frames.}
\usage{
read_6400(file_path)
read_6400(connection)
}
\arguments{
\item{file_path}{The path to a file. (a characater vector)}
\item{connection}{A file connection. See \code{help(\link{connections})}. (a connection)}
}
\value{
A list of data frames. Each data frame has additional attributes based on the file that was read.
}
\description{
\code{read_6400} reads a file in the format output by the LI-6400 and creates a data frame with columns and rows corresponding to the data recorded by the LI-6400. Remarks and file metadata are included in the attributes of the data frame. The "XML" package is required to parse file metadata.
}
\details{
Each record is read into the data frame. Remarks and other information in the file are recorded in the attributes of the data frame. Some information in the file is only readable if the XML package is installed.
LI-6400 files can have multiple sections in each file, so each section is read into a different data frame, and the result is returned as a list.
For files with only one section, there will only be one item in this list.
}
\examples{
\dontrun{
photosynthetic_data = read_6400('2017-01-01 field measurements')

# View the remarks.
attributes(photosynthetic_data)$remarks

# View the serial number (the XML package is required).
attributes(photosynthetic_data)$li6400$factory$unit

# Read a file from a URL.
url_connection = 'https://your_file_online'
photosynthetic_data = read_6400(url_connection)
close(url_connection)

# Note that many connections can be inferred from the file_path, so there is often no need to create a connection first.
# Thus, the following works too.
photosynthetic_data = read_6400('https://your_file_online')
}
}

