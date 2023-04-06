test_that('Get version', {
    mockery::stub(read_package_page, 'get_package_url', get_package_url_mock('here'))
    package_versions <- get_version('here', date = as.POSIXct('2021-11-01'))

    expect_df(
        package_versions,
        c(
            'Package' = 'character',
            'Version' = 'character',
            'Parent' = 'character',
            'URL' = 'character',
            'Filename' = 'character'
        )
    )

    expect_true(is.na(package_versions$Parent[1]))
    expect_equal(package_versions$Package[1], package_versions$Parent[2])

    targz_ext <- grepl('\\.tar\\.gz$', package_versions$URL)
    expect_true(all(targz_ext))

    expect_true(all(basename(package_versions$URL) == basename(package_versions$Filename)))
})
