#' Helper function to test dataframes
#'
#' @param df Dataframe to be tested.
#' @param expected_cols Named vector with entries of the form "`<column name>` = `<column type>`".
#' For example `c('Foo' = 'character')`.
#'
#' @return Invisble `TRUE`. This function is called for its side-effects, which is expectations 
#' from `testthat`.
#'
#' @details See for example <https://blog.r-hub.io/2020/11/18/testthat-utility-belt>
expect_df <- function(df, expected_cols)
{
    testthat::expect_true(is.data.frame(df))

    testthat::expect_s3_class(df, 'data.frame')

    testthat::expect_equal(ncol(df), length(expected_cols))
    testthat::expect_named(df, names(expected_cols))

    # Datetime columns have multiple classes
    column_types <- vapply(df, function(x) { class(x)[1] }, character(1))
    testthat::expect_equal(column_types, expected_cols)

    return(invisible(TRUE))
}


get_package_archive_url_mock <- function(package_name)
{
    print('get_package_archive_url_mock')
    local_package_file <- testthat::test_path('testdata', paste0(package_name, '_archive.html'))
    stopifnot(file.exists(local_package_file))

    return(local_package_file)
}


get_package_url_mock <- function(package_name)
{
    print('get_package_url_mock')
    local_package_file <- testthat::test_path('testdata', paste0(package_name, '.html'))
    stopifnot(file.exists(local_package_file))

    return(local_package_file)
}
