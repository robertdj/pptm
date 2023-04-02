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


parse_archive_table <- function(raw_archive_table)
{
    expected_table_columns <- c('Name', 'Last modified')
    all_expected_columns_present <- all(expected_table_columns %in% names(raw_archive_table))
    stopifnot(all_expected_columns_present)

    archive_table_expected_cols <- raw_archive_table[, expected_table_columns]
    names(archive_table_expected_cols) <- c('Name', 'LastModified')

    archive_table_expected_cols[['LastModified']] <- as.POSIXct(
        archive_table_expected_cols[['LastModified']],
        format = '%Y-%m-%d %H:%M',
        tz = 'UTC'
    )

    archive_table <- subset(
        archive_table_expected_cols, !is.na(archive_table_expected_cols$LastModified)
    )

    sorted_archive_table <- archive_table[order(archive_table$LastModified), ]

    return(sorted_archive_table)
}


#' Scrape package archive
#'
#' Scrape package archive from CRAN.
#'
#' @param package_name Name of the package as a string.
#'
#' @return A dataframe with columns `Name` (package name and version) and `LastModified`.
#'
#' @export
scrape_package_archive <- function(package_name)
{
    package_page <- read_package_page(package_name)
    raw_archive_tables <-  rvest::html_table(package_page)
    stopifnot(length(raw_archive_tables) == 1)

    parse_archive_table(raw_archive_tables[[1]])
}
