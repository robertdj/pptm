get_package_url_mock <- function(package_name)
{
    local_package_file <- test_path('testdata', paste0(package_name, '.html'))
    stopifnot(file.exists(local_package_file))

    return(local_package_file)
}


test_that('Read package page', {
    mockery::stub(read_package_page, 'get_package_url', get_package_url_mock('dplyr'))
    package_page <- read_package_page('dplyr')

    expect_s3_class(package_page, 'xml_document')
})


test_that('Scrape package page', {
    mockery::stub(read_package_page, 'get_package_url', get_package_url_mock('dplyr'))
    package_archive <- scrape_package_archive('dplyr')

    expect_df(
        package_archive,
        c(
            'Name' = 'character',
            'LastModified' = 'POSIXct'
        )
    )
})
