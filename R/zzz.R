.onLoad <- function(libname, pkgname)
{
    op <- options()
    pptm_scrape_cache <- file.path(tempdir(), 'pptm_scrape_cache')
    pptm_options <- list(pptm.scrape.cache = pptm_scrape_cache)

    toset <- !(names(pptm_options) %in% names(op))
    if (any(toset)) {
        if (!dir.exists(pptm_scrape_cache))
            dir.create(pptm_scrape_cache)

        options(pptm_options[toset])
    }

    invisible()
}
