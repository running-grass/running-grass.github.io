#!/bin/sh
printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

rm -rf public/*

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public

# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin HEAD:main

# Go To Root folder
cd ..

# Add changes to git.
git add .

# Commit changes.
msg="edit post $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin HEAD:main

exit 0
