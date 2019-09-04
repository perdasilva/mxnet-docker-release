# mxnet-docker-release
Release scripts for mxnet python docker images based on mxnet pip packages

## Instructions

1. Copy the *tests* and *example* directories from the mxnet src from the version you would like to release, e.g. `cp -R /home/user/mxnet/example .`.

2. Login to the mxnet docker account
3. Run `./release.sh` - you may need to adjust the variant list first to match your expectations
