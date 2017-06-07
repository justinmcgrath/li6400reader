read_6400 = function(file_string) {
    filecon = file(file_string)
    on.exit(close(filecon))
    file_lines = readLines(filecon)
    date = sub('\\"[^ ]+ (([^ ]+ ){3}).*', '\\1',  file_lines[2], perl=TRUE)  # The date is always on the second line and has the same format.

    start_of_data = grep('\\$STARTOFDATA\\$', file_lines)
    
    if (length(start_of_data) == 0) {
        result = list()  #  There are no data, so insert an empty list.
    } else {
        start_of_data = start_of_data[1]  # Files sometimes have more than one line with "$STARTOFDATA$", so keep only the first instance.
        headers = file_lines[start_of_data + 1]
        observation_lines = file_lines[-seq_len(start_of_data)]  # Delete everything before "$STARTOFDATA$".
        logged_line_indexes = grepl('(^[0-9]+	)', observation_lines)  # All of the lines with data begin with a number.
        data_lines = c(headers, observation_lines[logged_line_indexes])  # Keep the headers and lines with data.
        remarks = gsub('"', "", observation_lines[!logged_line_indexes][-1])  # Keep remarks, but remove unnecessary quotation marks.
        result = read.delim(textConnection(data_lines))
    }

    
    xmllines = file_lines[grepl("^<", file_lines)]  # The 6400 files have a syntax that is sort of like XML. Search for lines with "<>" tags and parse them as XML.
    file_info = parse_file_info(xmllines)

    for (name in names(file_info)) {
        attributes(result)[[name]] = file_info[[name]]
    }

    attributes(result)$file_creation_date = as.character(as.Date(as.POSIXlt(date, format='%b %d %Y')))
    attributes(result)$remarks = remarks
    class(result) = c(class(result), 'li6400_data')
    return(result)
}

parse_file_info = function(xmllines) {
    suppressWarnings(XML_pacakage_is_present <- require('XML', character.only=TRUE, quietly=TRUE))
    if (XML_pacakage_is_present) {
        currated_lines = gsub('items\\[([^\\]]+)\\]', 'items\\1', xmllines, perl=TRUE)  # Remove brackets from the items tags (e.g., "items[1]"). Brackets break the XML parser.
        currated_lines = gsub('"', '', currated_lines, perl=TRUE)  # Remove quotation marks. Quotation marks are not necessary in fields and they get read with the data.
        parsed_lines = XML::xmlToList(XML::xmlParse(c('<doc>', currated_lines, '</doc>')))  # XML files need a document-level tag. The parser doesn't care what the tag is, so I wrap everything in <doc></doc>.

        # The files repeat the top-level tags, but it makes more sense to have a hierachical structure. This groups subtags with the same top-level tag into a single group.
        file_info = vector('list',length(unique(names(parsed_lines))))
        names(file_info) = unique(names(parsed_lines)) 
        for (i in seq_along(parsed_lines)) {
            name = names(parsed_lines[i])
            file_info[[name]] = c(file_info[[name]], parsed_lines[[i]])
        }
    } else {
        file_info = list(file_data = 'Install the `XML` package in order to parse the 6400 file metadata.')
    }
    return(file_info)
}

add_time_stamp = function(li6400_data) {
        # This won't work if the file is open over midnight. result$datetime = as.POSIXlt(paste(date, result$HHMMSS), format='%b %d %Y %H:%M:%S')
        # result$date = as.Date(result$datetime)
        # result$date_string = date
}

