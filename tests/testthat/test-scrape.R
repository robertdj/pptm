test_that('Scrape package archive', {
    package_archive <- mockthat::with_mock(
        get_package_archive_url = get_package_archive_url_mock('here'),
        scrape_package_archive('here')
    )

    expect_df(
        package_archive,
        c(
            'Name' = 'character', 
            'LastModified' = 'POSIXct', 
            'URL' = 'character', 
            'PackageName' = 'character'
        )
    )
})


test_that('Scrape package page', {
    currrent_package <- mockthat::with_mock(
        get_package_url = get_package_url_mock('here'),
        scrape_package_page('here')
    )

    expect_df(
        currrent_package,
        c(
            'Name' = 'character', 
            'LastModified' = 'Date', 
            'URL' = 'character', 
            'PackageName' = 'character'
        )
    )
})


test_that('Scrape package versions', {
    package_versions <- mockthat::with_mock(
        get_package_archive_url = get_package_archive_url_mock('here'),
        get_package_url = get_package_url_mock('here'),
        scrape_package_versions('here')
    )

    expect_df(
        package_versions,
        c(
            'Name' = 'character', 
            'LastModified' = 'POSIXct', 
            'URL' = 'character', 
            'PackageName' = 'character'
        )
    )
})
