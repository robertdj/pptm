Poor Person's Time Machine
==========================

The goal of {pptm} is to provide a way to install packages as the appeared on CRAN on a particular date.
For instance to ensure that all packages work with the chosen version of R.

On a day-to-day basis it probably works well enough to use the fluent versions that comes with `install.packages` (that is, always installing the newest version) -- even though we potentially experience incompatible package versions.
But when using R more seriously I prefer to fix the versions of R as well as the packages in use.
(The [{renv} package](https://rstudio.github.io/renv) can keep track of the versions, but AFAIK not find historical versions that match.)

For many moons I have relied on [Microsoft's MRAN](https://mran.microsoft.com) to provide such a time machine.
However, this service soon comes to an end and I need an alternative.
One could start making copies of CRAN just like MRAN or use Posit's Package Manager, but as its name suggests this package is for people who want a cheaper option.


# Installation

{pptm} is only on GitHub and can be installed with the {remotes} package:

```r
remotes::install_github('robertdj/pptm')
```


# Usage

On CRAN a package provides the current version in source code format as well as binaries for Windows and macOS.
Furthermore, CRAN keeps an archive of previous versions, but only in source code format.

{pptm} looks through a package's archive and picks the version that was current at a specified date.
We need to do this recursively by checking all dependencies of the package as well.

As an example, consider the {dplyr} package on a date suitable for R version 4.1.1:

```r
pptm::install_version('dplyr', date = as.POSIXct('2021-11-01'))
```

Why choose the date 2021-11-01 for R version 4.1.1? 
This is the date where R version 4.1.2 was released and hence the last day where all packages on CRAN ought to work with R version 4.1.1.
My usecase is always to use these "last day of R version X being the latest" and to facilitate this `install_version` can take a version of R as argument:

```r
pptm::install_version('dplyr', r_version = '4.1.1')
```
