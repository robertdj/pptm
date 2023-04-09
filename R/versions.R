get_single_version <- function(package_name, date, package_dir = NULL, parent = NA_character_)
{
    package_versions <- scrape_package_versions(package_name)

    selected_package_version <- find_package_version(package_versions, date)

    local_package_file <- download_package_version(selected_package_version, package_dir = package_dir)

    data.frame(
        Package = pkg.peek::get_package_name(local_package_file),
        Version = as.character(pkg.peek::get_package_version(local_package_file)),
        Parent = parent,
        URL = selected_package_version$URL,
        Filename = local_package_file
    )
}


get_version_with_deps <- function(local_file, date, package_dir = NULL)
{
    print(local_file)
    dependencies <- get_package_imports(local_file)

    non_base_deps <- remove_base_packages(dependencies)
    if (length(non_base_deps) == 0)
        return(data.frame(
            Package = character(0),
            Parent = character(0),
            URL = character(0),
            Filename = character(0)
        ))

    # TODO Don't re-download

    package_name <- pkg.peek::get_package_name(local_file)
    list_of_version_dfs <- lapply(
        non_base_deps, get_single_version,
        date = date, package_dir = dirname(local_file), parent = package_name
    )

    dependencies_version <- do.call('rbind', list_of_version_dfs)

    # TODO Check if package is already downloaded
    foo <- lapply(dependencies_version$Filename, get_version_with_deps, date = date, package_dir = package_dir)
    bar <- do.call('rbind', foo)
    rbind(dependencies_version, bar)
}


get_version <- function(package_name, date, r_version, package_dir = NULL)
{
    package_versions <- get_single_version(package_name, date)

    local_file <- package_versions$Filename

    deps_versions <- get_version_with_deps(local_file, date, dirname(local_file))

    rbind(package_versions, deps_versions)
}


install_version <- function(versions)
{
    download_folder <- unique(dirname(versions$Filename))
    stopifnot(length(download_folder) == 1)
    stopifnot(grepl('/src/contrib$', download_folder))

    local_cran <- substr(download_folder, 1, nzchar(download_folder) - 12)

    tools::write_PACKAGES(local_cran)
    top_packages <- subset(versions, is.na(versions$Parent))
    install.packages(top_packages$Package, repos = paste0('file:', local_cran), type = 'source')
}
