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
scrape_package_archive <- function(package_name)
{
    package_page <- read_package_page(package_name)
    # TODO Make sure there is only a single table and it is correct
    raw_archive_table <-  rvest::html_table(package_page)[[1]]

    archive_table <- subset(
        raw_archive_table[c('Name', 'Last modified')],
        # TODO Stricter regex
        grepl(paste0('^', package_name, '_'), raw_archive_table[['Name']])
    )

    names(archive_table)[names(archive_table) == 'Last modified'] <- 'LastModified'

    archive_table[['LastModified']] <- strptime(
        archive_table[['LastModified']],
        format = '%Y-%m-%d %H:%M',
        tz = 'UTC'
    )

    return(archive_table)
}
