.onLoad <- function(libname, pkgname)
{
    op <- options()
    pptm_options <- list(pptm.scrape.cache <- file.path(tempdir(), 'pptm_scrape_cache'))

    toset <- !(names(pptm_options) %in% names(op))
    if (any(toset)) options(pptm_options[toset])

    invisible()
}
