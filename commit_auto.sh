#!/bin/bash
# Commit changes locally and to remotes
# Commit is made to an 'auto' branch and then switched back to current

# print header
#clear
echo ================================
echo Automatically Committing Changes

# Get current branch
branch=$(git status | grep -Po 'On branch \K[^ ]+')
echo Current branch is "$branch"

# Create/Checkout auto branch
auto=${branch}_auto
git branch ${auto}
git checkout ${auto}

# Merge changes from current branch
git merge --no-ff --no-edit ${branch}

# Push to remote
git push --set-upstream origin ${auto}

# Return to current branch
git checkout ${branch}

## Add changes
#git add -u
#
## Prepare commit message
#status=$(git status -uno)
#status=${status/ to be/}
#status=${status/(use*unstage)$'\n'/}
#status=${status/$'\n'Untracked*files)/}
#commit_message=$message$'\n\n'$status
#
## Commit locally
#commit=$(git commit -a -uno -m "$commit_message")
#
## Push to GitHub
##git push origin master
#git push -u
#
## Show new repository status
#echo
#echo ==========================
#echo Current Repository Status:
#echo
#git log -n 1
#echo
#echo
