# spectool-fav

Fetch and verify sources from a RPM specfile.

# Objective

We have [spectool](http://pkgbuild.sourceforge.net/spectool.html) that helps us to fetch sources of a RPM specfile. However, there was - at least not known to the author - no tool available, that not only fetches, but also verifies the sources of a specfile against a checksum. At least no tool that is part of a bigger build-tool-chain.

What spectool-fav does, is to retrieve the sources of a specfile using spectool and automatically verify these files against a list of checksums for these files. Which means, that we then can safely start the build job.

Additionally, we verify the signature of the sources file against our keyring, so that we can also verify that no-one tampered with the source for the checksums.

It is up to the user to have all the keys used to sign the sources files within the used gpg-keyring.

# Usage

    spectool-fav SPECFILE

This expects a project to have the following structure:

    .
    ├── some_rpm.sources
    ├── some_rpm.sources.asc
    ├── SOURCES
    └── SPECS
        └── some_rpm.spec

Assuming the spec file would contain the following 2 entries:

    Source0: http://mydownload.example.com/file1.tar.gz2
    Source1: http://mydownload.example.com/file2.blob

The some_rpm.sources would have one line per file. Started with the sha512 checksum and followed by the filename.

    aSHA512sum111111... file1.tar.gz2
    aSHA512sum22222... file2.blob

Which matches what sha512sum generates.

Signature for the sources file should be created as a detached signature:

    gpg --sign --detch --armor some_rpm.sources

## Options

*--force-fetch* Force to refetch the sources

# License

GPLv3

# Contact

mh ( ÄT ) immerda.ch
