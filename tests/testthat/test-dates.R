test_that('Get error for non-existing version', {
    expect_error(get_r_date('3.1.0'))
})


test_that('Get date for existing version', {
    version_date <- get_r_date('4.1.0')

    expect_s3_class(version_date, 'Date')
})
