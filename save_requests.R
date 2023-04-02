test_data_path <- here::here('tests', 'testthat', 'testdata')
if (!dir.exists(test_data_path))
    dir.create(test_data_path)

download.file(pptm::get_package_url('dplyr'), fs::path(test_data_path, 'dplyr.html'))
