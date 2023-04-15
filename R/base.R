#' Remove base packages
#'
#' It is common to have base R packages dependencies, but when trying to install a base package in
#' RStudio you'll get complaints about the package already being loaded.
#' This function removes the base R packages from the input (if any).
#'
#' @param package_names Name of the package(s).
#'
#' @return The unique entries in `package_names` without base packages (if any).
remove_base_packages <- function(package_names)
{
    stopifnot(is.character(package_names))

    base_packages_info <- utils::installed.packages(priority = 'base')

    setdiff(unique(package_names), base_packages_info[, 'Package'])
}
