get_version <- function(package_name, date, r_version, package_dir = NULL)
{
    package_archive <- scrape_package_archive(package_name)

    data.frame(
        'Package' = c('here', 'rprojroot'),
        'Version' = c('1.0.1', '2.0.3'),
        'Parent' = c(NA_character_, 'here'),
        'URL' = c(
            'https://cran.r-project.org/src/contrib/here_1.0.1.tar.gz',
            'https://cran.r-project.org/src/contrib/rprojroot_2.0.3.tar.gzß'
        ),
        'Filename' = file.path('/tmp/RtmpoMRkSP', c('here_1.0.1.tar.gz', 'rprojroot_2.0.3.tar.gz'))
    )
}


install_version <- function(package_name, date, r_version, package_dir = NULL)
{
    if (is.null(package_dir))
        package_dir <- tempdir()
}
