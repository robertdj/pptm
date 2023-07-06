test_that('Get single version', {
    package_versions <- mockthat::with_mock(
        get_package_archive_url = get_package_archive_url_mock('here'),
        get_package_url = get_package_url_mock('here'),
        download_package_version = function(x, ...) create_test_package(x$PackageName),
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
        get_version('here', date = as.Date('2021-01-01'))
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


test_that('Install versions', {
    versions <- mockthat::with_mock(
        get_package_archive_url = get_package_archive_url_mock('here'),
        get_package_url = get_package_url_mock('here'),
        download_package_version = function(x, ...) create_test_package(x$PackageName),
        get_version('here', date = as.Date('2021-01-01'))
    )

    cran_path <- unique(dirname(versions$Filename))
    on.exit(unlink(cran_path, recursive = TRUE), add = TRUE)

    install_dir <- file.path(tempdir(), 'pptm_install_dir')
    if (!dir.exists(install_dir))
        dir.create(install_dir, recursive = TRUE)
    on.exit(unlink(install_dir, recursive = TRUE), add = TRUE)

    install_version(versions, lib = install_dir, quiet = TRUE)

    installed_packages <- installed.packages(install_dir)
    installed_package_names <- sort(as.character(installed_packages[, 'Package']))
    expect_equal(sort(versions$Package), installed_package_names)
})
