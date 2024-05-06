#!/usr/bin/env bash

# Source:
# https://stackoverflow.com/questions/13716658/how-to-delete-all-commit-history-in-github

# Checkout/create orphan branch (this branch won't show in git branch command):
git checkout --orphan latest_branch

# Add all the files to the newly created branch:
git add -A

# Commit the changes:
git commit -am "initial commit"

# Delete main (default) branch (this step is permanent):
git branch -D main

# Rename the current branch to main:
git branch -m main

# Finally, all changes are completed on your local repository,
# and force update your remote repository:
git push -f origin main

