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


#' Make a package from a DESCRIPTION file
#'
#' @param desc_path The path to a valid `DESCRIPTION` file.
#' @param ... Arguments for [pkgbuild::build()]
#'
#' @details The package consists of a `DESCRIPTION` file and a `NAMESPACE` file.
#' Note that the `pkgbuild` package is required.
#'
#' @return The path of the built package.
create_empty_package <- function(desc_path, ...)
{
    stopifnot(file.exists(desc_path))

    pkg_build_dir <- file.path(tempdir(), 'pptm_package_build_dir')
    if (!dir.exists(pkg_build_dir))
        dir.create(pkg_build_dir)
    on.exit(unlink(pkg_build_dir, recursive = TRUE))

    file.copy(from = desc_path, to = pkg_build_dir)
    writeLines(
        "exportPattern(\"^[^\\\\.]\")",
        con = file.path(pkg_build_dir, 'NAMESPACE')
    )
    # file.create(file.path(pkg_build_dir, 'NAMESPACE'))

    pkgbuild::build(path = pkg_build_dir, ...)
}


create_test_package <- function(package_name)
{
    desc_path <- testthat::test_path('testdata', package_name, 'DESCRIPTION')
    print(desc_path)
    create_empty_package(desc_path, quiet = TRUE, vignettes = FALSE)
}