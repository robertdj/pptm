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
    recursive_version_with_deps <- lapply(
        dependencies_version$Filename, get_version_with_deps,
        date = date, package_dir = package_dir
    )
    recursive_version_with_deps_df <- do.call('rbind', recursive_version_with_deps)

    rbind(dependencies_version, recursive_version_with_deps_df)
}

#' Get historical packages
#' 
#' Get a package and its dependencies as they appeared on a particular point in time.
#' 
#' @param package_name Name of the package to install.
#' @param date Get `package_name` and its dependencies as they appeared on CRAN on `date`.
#' @param r_version NOT IMPLEMENTED YET. An alternative to `date` is to choose the R version that `package_name` should match. 
#' This will be the last date where `r_version` was the current R. 
#' This ensures that all packages have been checked to work with this R version.
#' @param package_dir Directory where `package_name` and its dependencies are downloaded to. Note that it will contain a valid CRAN.
#' 
#' @return A dataframe with columns `Package`, `Version`, `Parent`, `URL`, `Filename`.
#' 
#' @seealso [install_version()].
#' 
#' @export 
get_version <- function(package_name, date, r_version, package_dir = NULL)
{
    package_versions <- get_single_version(package_name, date)

    local_file <- package_versions$Filename

    deps_versions <- get_version_with_deps(local_file, date, dirname(local_file))

    rbind(package_versions, deps_versions)
}


#' Install package as they appeared in the past
#' 
#' @param versions An output from [get_version()].
#' @param ... Arguments passed on to [install.packages()].
#' 
#' @return The same as [install.packages()].
#' 
#' @export 
install_version <- function(versions, ...)
{
    stopifnot(is.data.frame(versions))
    stopifnot(colnames(versions) %in% c('Package', 'Version', 'Parent', 'URL', 'Filename'))

    download_folder <- unique(dirname(versions$Filename))
    stopifnot(length(download_folder) == 1)
    stopifnot(grepl('/src/contrib$', download_folder))

    local_cran <- substr(download_folder, 1, nchar(download_folder) - 12)

    tools::write_PACKAGES(download_folder)
    top_packages <- subset(versions, is.na(versions$Parent))

    utils::install.packages(
        pkgs = versions$Filename,
        repos = NULL,
        type = 'source',
        ...
    )
}
