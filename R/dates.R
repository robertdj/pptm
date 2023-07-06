get_r_date <- function(r_version)
{
    r_version_as_numeric_version <- as.numeric_version(r_version)

    matching_versions <- subset(
        supported_r_archives,
        supported_r_archives$version == r_version_as_numeric_version
    )

    if (nrow(matching_versions) == 0) {
        stop('No matching versions')
    }

    if (nrow(matching_versions) > 1) {
        stop('Multiple matching versions')
    }

    return(matching_versions$date)
}
