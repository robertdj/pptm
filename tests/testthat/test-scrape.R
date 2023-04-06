test_that('Read package page', {
    mockery::stub(read_package_page, 'get_package_url', get_package_url_mock('dplyr'))
    package_page <- read_package_page('dplyr')

    expect_s3_class(package_page, 'xml_document')
})


test_that('Scrape package page', {
    mockery::stub(read_package_page, 'get_package_url', get_package_url_mock('dplyr'))
    package_archive <- scrape_package_archive('dplyr')

    expect_df(package_archive, c('Name' = 'character', 'LastModified' = 'POSIXct'))
})
