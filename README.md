# create-release-branch-and-tag-action

A GitHub Action for creating a new SemVer tag and release branch.

## Usage

```yaml
# Bump version every 3 weeks
name: Bump version
on:
  schedule:
  	- cron: '0 0 */21 * *'

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
    - uses: actions/checkout@v3

    - name: Bump version, push branch and tag
      uses: stevenpall/create-release-branch-and-tag-action@0.1.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

```

If no `#major`, `#minor` or `#patch` tag is found in any commit message since the last tag's commit, the action will do a `minor` bump.

> **_Note:_** No action will be taken if the `HEAD` commit has already been tagged.

### Options

**Environment Variables**

- **GITHUB_TOKEN** **_(required)_** - Required for permission to push tags and branches to the repo.
- **INITIAL_VERSION** **_(optional)** - If no tags exist, this specifies the initial tag. Defaults to `0.1.0`.
- **DRY_RUN** _(optional)_ - Prints the next version without creating a new branch or tag. Possible values are `true` and `false` (default).
- **VERBOSE** _(optional)_ - Print git logs. For some projects these logs may be very large. Possible values are `true` (default) and `false`.
- **RELEASE_BRANCH_PREFIX** _(optional)_ - Specifies the prefix for the release branch name. Defaults to `release` (e.g. `release/0.1.0`).
- **MAJOR_VERSION_TOKEN** _(optional)_ - Change the default `#major` version commit message string.
- **MINOR_VERSION_TOKEN** _(optional)_ - Change the default `#minor` version commit message string
- **PATCH_VERSION_TOKEN** _(optional)_ - Change the default `#patch` version commit message string.

### Credits

- [anothrNick/github-tag-action](https://github.com/anothrNick/github-tag-action)
