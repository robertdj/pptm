#' https://github.com/r-lib/testthat/issues/273
#' https://blog.r-hub.io/2020/11/18/testthat-utility-belt/
expect_df <- function(df, expected_cols)
{
    testthat::expect_true(is.data.frame(df))

    testthat::expect_s3_class(df, 'data.frame')
    testthat::expect_named(df, names(expected_cols))

    return(invisible(TRUE))
}
