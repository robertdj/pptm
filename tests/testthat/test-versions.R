test_that('Get single version', {
    here_package <- create_test_package('here')

    package_versions <- mockthat::with_mock(
        get_package_archive_url = get_package_archive_url_mock('here'),
        get_package_url = get_package_url_mock('here'),
        download_package_version = here_package,
        get_single_version('here', date = as.POSIXct('2021-01-01'))
    )

    expect_equal(nrow(package_versions), 1L)

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
})


test_that('Get versions', {
    package_versions <- mockthat::with_mock(
        get_package_archive_url = get_package_archive_url_mock('here'),
        get_package_url = get_package_url_mock('here'),
        download_package_version = function(x, ...) create_test_package(x$PackageName),
        get_version('here', date = as.POSIXct('2021-01-01'))
    )

    expect_gt(nrow(package_versions), 1L)

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
})
