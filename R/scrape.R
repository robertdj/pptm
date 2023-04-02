#' @export
get_package_url <- function(package_name)
{
    paste0('https://cran.r-project.org/src/contrib/Archive/', package_name)
}


read_package_page <- function(package_name)
{
    package_url <- get_package_url(package_name)
    xml2::read_html(package_url)
}


#' Scrape package archive
#' @export
scrape_package_archive <- function(package_name)
{
    package_page <- read_package_page(package_name)
    raw_archive_tables <-  rvest::html_table(package_page)
    stopifnot(length(raw_archive_tables) == 1)

    raw_archive_table <- raw_archive_tables[[1]]

    expected_table_columns <- c('Name', 'Last modified')
    all_expected_columns_present <- all(
        intersect(names(raw_archive_table), expected_table_columns) == expected_table_columns
    )
    stopifnot(all_expected_columns_present)

    package_name_regex <- paste0('^', package_name, '_[[:digit:]](\\.[[:digit:]]){,4}\\.tar\\.gz')
    archive_table <- subset(
        raw_archive_table[expected_table_columns],
        grepl(package_name_regex, raw_archive_table[['Name']])
    )

    names(archive_table) <- c('Name', 'LastModified')

    archive_table[['LastModified']] <- strptime(
        archive_table[['LastModified']],
        format = '%Y-%m-%d %H:%M',
        tz = 'UTC'
    )

    sorted_archive_table <- archive_table[order(archive_table$LastModified), ]

    return(sorted_archive_table)
}
