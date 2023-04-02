test_data_path <- here::here('tests', 'testthat', 'testdata')
fs::dir_create(test_data_path)

download.file(get_package_url('dplyr'), fs::path(test_data_path, 'dplyr.html'))
