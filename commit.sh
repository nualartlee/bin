#!/bin/bash
# Commit changes locally and to remotes

# print help function
print_help()
{
    echo
    echo "Commits repository changes locally and to remotes."
    echo
    echo "usage: ./commit.sh -m 'message'"
    echo
}

# Get arguments
while [ "$1" != "" ]; do
    case $1 in
        -m | --message )        shift
                                message=$1
                                ;;
        -h | --help )           print_help
                                exit
                                ;;
        * )                     print_help
                                exit 1
    esac
    shift
done

# Check that a message is provided
if [ -z ${message+x} ]; then
    print_help
    exit
fi

# print header
clear
echo ==========================
echo Committing Changes

# Update Python requirements
pip3 freeze > requirements_all.txt
git add requirements_all.txt

# Add changes
git add -u

# Prepare commit message
status=$(git status -uno)
status=${status/ to be/}
status=${status/(use*unstage)$'\n'/}
status=${status/$'\n'Untracked*files)/}
commit_message=$message$'\n\n'$status

# Commit locally
commit=$(git commit -a -uno -m "$commit_message")

# Push to GitHub
#git push origin master
git push -u

# Show new repository status
echo
echo ==========================
echo Current Repository Status:
echo
git log -n 1
echo
echo
