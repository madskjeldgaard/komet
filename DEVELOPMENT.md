# General

Development happens on the `develop` branch. Once it has stabilized and there are enough features, it might be time for an update. See below. 

## Updating
Updating implies setting a new git tag and generating a changelog using `git cliff` (see [here for more information](https://github.com/orhun/git-cliff) ). This is handled automatically by the `update` script in the [scripts](../scripts/) folder.

The script will not allow an update if the test suite for this package does not pass.

## Testing
