# spectool-fav

Fetch and verify sources from an RPM specfile.

# Objective

We have [spectool](http://pkgbuild.sourceforge.net/spectool.html) that helps us to fetch sources of a RPM spec file. However, at least for the author there was no tool available that also verifies each of these files against a checksum and that is not part of another bigger build-chain.

So what we want to get is to retrieve the sources and automatically have them verified, so that we can safely start the build job.

Additionally, we verify the signature of the sources file against our keyring, so that we can also verify that no-one tampered with the source for our checksums.

It is up to the user to have all the keys used to sign the sources files within the used gpg-keyring.

# Usage

    spectool-fav SPECFILE

This expects a project to have the following structure:

    .
    ├── some_rpm.sources
    ├── some_rpm.sources.asc
    ├── README.md
    ├── SOURCES
    └── SPECS
        └── some_rpm.spec

Assuming the spec file would contain the following 2 entries:

    Source0: http://mydownload.example.com/file1.tar.gz2
    Source1: http://mydownload.example.com/file2.blob

The some_rpm.sources would have one line per filename followed by a sha512 checksum:

    file1.tar.gz2 aSHA512sum111111...
    file2.blob aSHA512sum22222...

Signature for the sources file should be created as a detached signature:

    gpg --sign --detch --armor some_rpm.sources

## Options

*--force-fetch* Force to refetch the sources

# License

GPLv3

# Contact

mh ( ÄT ) immerda.ch
