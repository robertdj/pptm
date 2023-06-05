all_r_versions <- rversions::r_versions()

r_archives <- data.frame(
    version = head(all_r_versions$version, -1),
    date = tail(as.Date(all_r_versions$date), -1)
)

supported_r_archives <- subset(r_archives, r_archives$version >= as.numeric_version('4.0.0'))

usethis::use_data(supported_r_archives, overwrite = TRUE, internal = TRUE)
