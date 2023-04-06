get_package_url_mock <- function(package_name)
{
    local_package_file <- test_path('testdata', paste0(package_name, '.html'))
    stopifnot(file.exists(local_package_file))

    return(local_package_file)
}


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
})
