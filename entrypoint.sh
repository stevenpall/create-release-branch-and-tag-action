#!/bin/bash
set -eo pipefail

# Read in some config env vars
initial_version=${INITIAL_VERSION:-0.1.0}
dry_run=${DRY_RUN:-false}
verbose=${VERBOSE:-false}
release_branch_prefix=${RELEASE_BRANCH_PREFIX:-release}

if ${verbose}; then
    set -x
fi

# Get the latest git ref that matches semver format
tag_fmt="^?[0-9]+\.[0-9]+\.[0-9]+$"
git_refs=$(git for-each-ref --sort=-v:refname --format '%(refname:lstrip=2)')
matching_tag_refs=$(echo "${git_refs}" | grep -E "${tag_fmt}" || true)
tag=$(echo "${matching_tag_refs}" | head -n1)
# If no tags exist, start at initial_version
if [ -z "${tag}" ]; then
    tag="${initial_version}"
fi

# Get current commit hash for tag
tag_commit=$(git rev-list -n1 "${tag}" || true)
# get current commit hash
commit=$(git rev-parse HEAD)
# skip if there are no new commits
if [ "${tag_commit}" == "$commit" ]; then
    echo "No new commits since previous tag. Skipping..."
    exit 0
fi

# Set new tag (only increments patch -- additional logic could be added for minor/major)
new_tag=$(semver -i patch "${tag}")

# Set new branch name
new_branch="${release_branch_prefix}/${new_tag}"

# Exit if dry_run is set
if ${dry_run}; then
	echo "Dry run set. Exiting."
    exit 0
fi

# Create new release branch
echo "Creating new branch: ${new_branch}"
git checkout -b "${new_branch}"

# Create a new tag locally
echo "Creating new local tag: ${new_tag}"
git tag "${new_tag}"

# Push new release branch and tag
echo "Pushing new branch (${new_branch}) and tag (${new_tag})"
git push origin --atomic "${new_branch}" "${new_tag}"

echo "Operation completed successfully."
