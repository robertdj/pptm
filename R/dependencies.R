find_package_version <- function(package_versions, date)
{
    package_versions_after_date <- subset(package_versions, package_versions$LastModified >= date)
    stopifnot(nrow(package_versions_after_date) > 0)

    last_package_version <- utils::head(package_versions_after_date, n = 1)

    return(last_package_version)
}


download_package_version <- function(package_archive, package_dir = NULL)
{
    stopifnot(nrow(package_archive) == 1)

    if (is.null(package_dir))
        package_dir <- file.path(tempdir(), 'pptm')

   if (!grepl('/src/contrib$', package_dir))
       package_dir <- file.path(package_dir, 'src', 'contrib')

    local_file <- file.path(package_dir, package_archive$Name)
    local_file_dir <- dirname(local_file)

    if (!dir.exists(local_file_dir))
        dir.create(local_file_dir, recursive = TRUE)

    if (!file.exists(local_file))
        utils::download.file(package_archive$URL, local_file)

    return(local_file)
}


get_package_imports <- function(package_file)
{
    package_desc <- pkg.peek::get_package_desc(package_file)
    desc_import_list <- package_desc['Imports']
    if (is.na(desc_import_list))
        return(character(0))

    desc_import_list_sans_newlines <- gsub('[\r\n]', '', desc_import_list)
    raw_imports <- strsplit(desc_import_list_sans_newlines, split = ',( )?')

    package_imports <- sub(
        '([[:alpha:]][[:alnum:]]*)([^[:alnum:]].*)', '\\1', raw_imports[[1]]
    )

    return(package_imports)
}
