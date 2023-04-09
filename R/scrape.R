#' Get URL of package archive
#'
#' @param package_name Name of the package, .e.g. `'dplyr`.
#'
#' @export
get_package_archive_url <- function(package_name)
{
    paste0('https://cran.r-project.org/src/contrib/Archive/', package_name)
}


read_package_archive_page <- function(package_name)
{
    package_url <- get_package_archive_url(package_name)
    print(package_url)
    rvest::read_html(package_url)
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

    archive_file <- archive_table$Name[1]
    package_name <- substr(archive_file, 1, gregexec('_', archive_file)[[1]] - 1)
    archive_table$URL <- paste(get_package_archive_url(package_name), archive_table$Name, sep = '/')

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
    package_page <- read_package_archive_page(package_name)
    raw_archive_tables <- rvest::html_table(package_page)
    stopifnot(length(raw_archive_tables) == 1)

    parse_archive_table(raw_archive_tables[[1]])
}


get_package_url <- function(package_name)
{
    paste0('https://cran.r-project.org/web/packages/', package_name, '/index.html')
}


read_package_page <- function(package_name)
{
    package_url <- get_package_url(package_name)
    rvest::read_html(package_url)
}


parse_package_page <- function(package_page)
{
    # TODO This could probably be done smarter
    package_tables <- rvest::html_table(package_page)
    # The search look like 'Package source:', but the separating character(s) between the two words
    # is not a space
    downloads_table_index <- sapply(package_tables, function(df) { any(grepl('^Package.*source:$', df[[1]])) })
    downloads_table <- package_tables[[which(downloads_table_index)]]
    current_source_name <- downloads_table[[2]][1]

    data.frame(
        Name = current_source_name,
        LastModified = Sys.Date(),
        URL = paste0('https://cran.r-project.org/src/contrib/', current_source_name)
    )
}


scrape_package_page <- function(package_name)
{
    package_page <- read_package_page(package_name)
    parse_package_page(package_page)
}


#' Scrape package versions
#'
#' Scrape package versions from CRAN.
#'
#' @param package_name Name of the package as a string.
#'
#' @return A dataframe with columns `Name` (package name and version) and `LastModified`.
#'
#' @export
scrape_package_versions <- function(package_name)
{
    package_archive <- scrape_package_archive(package_name)
    currrent_package <- scrape_package_page(package_name)

    rbind(package_archive, currrent_package)
}
