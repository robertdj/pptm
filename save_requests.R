test_data_path <- here::here('tests', 'testthat', 'testdata')
if (!dir.exists(test_data_path))
    dir.create(test_data_path)

package_names <- c('here', 'rprojroot')
package_versions <- c('here' = '1.0.1.tar.gz', 'rprojroot' = '2.0.3.tar.gz')

for (package in package_names) 
{
    download.file(
        pptm:::get_package_archive_url(package), 
        file.path(test_data_path, paste0(package, '_archive.html'))
    )
    download.file(
        pptm:::get_package_url(package), 
        file.path(test_data_path, paste0(package, '.html'))
    )

    package_archive <- paste0(package, '_', package_versions[package])
    tmp_dir <- tempdir()
    archive_file <- file.path(tmp_dir, package_archive)
    download.file(paste0('https://cran.r-project.org/src/contrib/', package_archive), archive_file)

    archive_filename <- basename(archive_file)
    package_name <- substr(archive_filename, 1, gregexec('_', archive_filename)[[1]] - 1)
    untar(archive_file, paste0(package_name, '/DESCRIPTION'), exdir = test_data_path)
    unlink(archive_file)
}
