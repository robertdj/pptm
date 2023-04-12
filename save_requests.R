test_data_path <- here::here('tests', 'testthat', 'testdata')
if (!dir.exists(test_data_path))
    dir.create(test_data_path)

download.file(pptm:::get_package_archive_url('here'), file.path(test_data_path, 'here_archive.html'))
download.file(pptm:::get_package_url('here'), file.path(test_data_path, 'here.html'))

download.file(pptm:::get_package_archive_url('rprojroot'), file.path(test_data_path, 'rprojroot_archive.html'))
download.file(pptm:::get_package_url('rprojroot'), file.path(test_data_path, 'rprojroot.html'))


for (package_archive in c('here_1.0.1.tar.gz', 'rprojroot_2.0.3.tar.gz'))
{
    tmp_dir <- tempdir()
    archive_file <- file.path(tmp_dir, package_archive)
    download.file(paste0('https://cran.r-project.org/src/contrib/', package_archive), archive_file)

    archive_filename <- basename(archive_file)
    package_name <- substr(archive_filename, 1, gregexec('_', archive_filename)[[1]] - 1)
    untar(archive_file, paste0(package_name, '/DESCRIPTION'), exdir = test_data_path)
}
