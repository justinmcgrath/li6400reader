read_6400 = function(x, ...) {
    UseMethod("read_6400")
}

read_6400.connection = function(connection, ...) {
    file_lines = readLines(connection)

    start_of_data = grep('\\$STARTOFDATA\\$', file_lines)
    OPEN_REMARK = c(grep('^"OPEN +[^"]+"$', file_lines), length(file_lines))

    sections = create_sections(file_lines, OPEN_REMARK)

    result = vector('list', length(sections))
    for (i in seq_along(sections)) {
        result[[i]] = parse_section(sections[[i]], ...)
    }
    return(result)
}

read_6400.character = function(file_path, ...) {
    file_connection = file(file_path)
    on.exit(close(file_connection))
    return(read_6400.connection(file_connection, ...))
}

parse_file_info = function(xmllines) {
    suppressWarnings(XML_pacakage_is_present <- requireNamespace('XML', quietly=TRUE))
    if (XML_pacakage_is_present) {
        curated_lines = gsub('items\\[([^\\]]+)\\]', 'items\\1', xmllines, perl=TRUE)  # Remove brackets from the items tags (e.g., "items[1]"). Brackets break the XML parser.
        curated_lines = gsub('"', '', curated_lines, perl=TRUE)  # Remove quotation marks. Quotation marks are not necessary in fields and they get read with the data.
        parsed_lines = XML::xmlToList(XML::xmlParse(c('<doc>', curated_lines, '</doc>')))  # XML files need a document-level tag. The parser doesn't care what the tag is, so I wrap everything in <doc></doc>.

        # The files repeat the top-level tags, but it makes more sense to have a hierachical structure. This groups subtags with the same top-level tag into a single group.
        file_info = vector('list', length(unique(names(parsed_lines))))
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

parse_section = function(section_lines, ...) {
    start_of_data = grep('\\$STARTOFDATA\\$', section_lines)
    
    if (length(start_of_data) == 0) {
        result = list()  #  There are no data, so insert an empty list.
    } else {
        start_of_data = start_of_data[1]  # Files sometimes have more than one line with "$STARTOFDATA$", so keep only the first instance.
        header_row_number = start_of_data + 1
        headers = section_lines[header_row_number]
        observation_lines = section_lines[-c(seq_len(start_of_data), header_row_number)]  # Delete everything before "$STARTOFDATA$" and the header row.
        #logged_line_indexes = grepl('(^[0-9]+	)', observation_lines)  # All of the lines with data begin with a number.
        logged_line_indexes = !grepl('^"[^"]* ', observation_lines, perl=TRUE)  # There's nothing certain to identify a remark. This looks for a quoted field at the start of the line with spaces in it.
        data_lines = c(headers, observation_lines[logged_line_indexes])  # Keep the headers and lines with data.
        remarks = gsub('"', "", observation_lines[!logged_line_indexes][-1])  # Keep remarks, but remove unnecessary quotation marks.
        result = read.delim(textConnection(data_lines), ...)
    }

    
    xmllines = section_lines[grepl("^<", section_lines)]  # The 6400 files have a syntax that is sort of like XML. Search for lines with "<>" tags and parse them as XML.
    file_info = parse_file_info(xmllines)

    for (name in names(file_info)) {
        attributes(result)[[name]] = file_info[[name]]
    }

    date = sub('\\"[^ ]+ (([^ ]+ +){3}).*', '\\1',  section_lines[2], perl=TRUE)  # The date is always on the second line and has the same format.
    attributes(result)$section_creation_date = as.character(as.Date(as.POSIXlt(date, format='%b %d %Y')))
    attributes(result)$remarks = remarks
    class(result) = c(class(result), 'li6400_data')
    return(result)
}

create_sections = function(file_lines, breaks) {
    n_sections = length(breaks) - 1
    sections = vector('list', n_sections)
    for (i in seq_len(n_sections)) {
        sections[[i]] = file_lines[seq(breaks[i], breaks[i+1])]
    }
    return(sections)
}

