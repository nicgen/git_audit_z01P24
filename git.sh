#!/usr/bin/env bash

# VARS
# ------------------------------------------
# main or master?
# https://www.zdnet.com/article/github-to-replace-master-with-main-starting-next-month/
primary_branch=main
HIGHLIGHT="\e[34m"
PROMPT_HIGHLIGHT="\e[32m"
RST="\e[0m"
BG_HIGHLIGHT="\e[44m"

# FUNCTIONS
# ------------------------------------------
# draw a line
function drawline {
  printf '\e[37m%*s\e[0m\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

# PROMPTS
# ------------------------------------------
# project path
echo "Choose the directory of your git project:"
while true ; do
    read -r -e -p "Path: " filepath
    if [ -d "$filepath" ] ; then
        break
    fi
    echo "$filepath is not a directory..."
done
user_repo=${filepath}
echo Selected: "$user_repo"

drawline

# choice editor
names=(Vscode Codium)
selected=()
PS3='Which code editor do you use? '
select name in "${names[@]}" ; do
    for reply in $REPLY ; do
        selected+=(${names[reply - 1]})
    done
    [[ $selected ]] && break
done
code_editor=${selected[@]}
if [ "$code_editor" == "Vscode" ]; then
  code_launch=code
else
  code_launch=codium
fi

echo Selected: "$code_editor"

drawline

# choice repository
names=(Github Gitea)
selected=()
PS3='Which Git hosting service do you use? '
select name in "${names[@]}" ; do
    for reply in $REPLY ; do
        selected+=(${names[reply - 1]})
    done
    [[ $selected ]] && break
done
remote_git=${selected[@]}
# echo Selected: "$remote_git"

drawline

read -p "Enter your $remote_git repository: " remote_url

drawline

read -p "Enter your $remote_git account name: " user_name

drawline

read -p "Enter your $remote_git account email: " user_email

drawline

echo "Please check your answers:"
printf "The directory of this project: $PROMPT_HIGHLIGHT%s$RST\n" "$user_repo"
printf "Your code editor:  $PROMPT_HIGHLIGHT%s$RST\n" "$code_editor" 
printf "Your remote repository: $PROMPT_HIGHLIGHT%s$RST\n" "$remote_url" 
printf "Your remote repository name: $PROMPT_HIGHLIGHT%s$RST\n" "$user_name"  
printf "Your remote repository email: $PROMPT_HIGHLIGHT%s$RST\n" "$user_email"  

# echo Your username is $username, we will not display your password
while true; do
    read -p "Are these informations corrects? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

drawline

printf "$BG_HIGHLIGHT%s$RST\n" "Branching"

# CORE
# ------------------------------------------
^printf\s"\$BG_HIGHLIGHT\s([\w]+)\$RST\\n"


printf "$BG_HIGHLIGHT%s$RST\n" "Setting Up Git"
drawline
# ------------------------------------------
printf "$HIGHLIGHT%s$RST\n" "Check if git is installed"
if git --version ./?> /dev/null;
then
  echo GIT is installed
  git --version
else
  echo GIT is not installed
  # install git
  sudo apt install git-all & pid=$!; wait $pid
fi

printf "$HIGHLIGHT%s$RST\n" "Configuration"
# default branch name to avoid the warning message
git config --global init.defaultBranch $primary_branch

# store credential
git config --global credential.helper store

printf "$HIGHLIGHT%s$RST\n" "Create directory and change working directory"
mkdir "$user_repo""hello" && cd $_  || return
if pwd != "$user_repo""hello";
then 
  cd "$user_repo""hello/" || return
fi

# repository
printf "$HIGHLIGHT%s$RST\n" "Initialisation of the git repository"
git init && pid=$!; wait $pid

# git remote add
# git remote add origin $remote_url
# configure --local
git config --local user.name $user_name
git config --local user.email $user_email
# check git config
git config --local --list

printf "$BG_HIGHLIGHT%s$RST\n" "Git commits to commit"
drawline
# ------------------------------------------
printf "$HIGHLIGHT%s$RST\n" "Create a file"
drawline
echo 'echo "Hello, World"' > hello.sh
echo "git status:"
git status

# first commit
git add hello.sh
git commit -m "init, added hello.sh"
# generate and store First_Snapshot hastag
first_snapshot=$(git log --pretty=format:"%H" -1)

# check working tree
git status

# modify the file
cat <<EOF>hello.sh
#!/bin/bash

echo "Hello, \$1"
EOF

git add hello.sh
git commit -m "added shebang and argument" 2> /dev/null 
# check working tree
git status

printf "$HIGHLIGHT%s$RST\n" "modify line 3"
cat <<EOF>hello.sh
#!/bin/bash

# Default is "World"
echo "Hello, \$1"
EOF

git add hello.sh
git commit -m "line 3, modified comment" 2> /dev/null 

# Second_Recent_Snapshot hastag
second_recent_snapshot=$(git log --pretty=format:"%H" -1)

printf "$HIGHLIGHT%s$RST\n" "Modify line 4 and 5"
cat <<EOF>hello.sh
#!/bin/bash

# Default is "World"
name=\${1:-"World"}
echo "Hello, \$name"
EOF

git add hello.sh
git commit -m "line 4 and 5, added variable"

# History
printf "$HIGHLIGHT%s$RST\n" "git history full"
git log
echo "----------"
printf "$HIGHLIGHT%s$RST\n" "git history oneline format"
git log --oneline
echo "----------"
printf "$HIGHLIGHT%s$RST\n" "Personalized Format"
git log --pretty=format:"%h %ad | %s%d [%an]" --date=short
echo "----------"

# Check it out
printf "$HIGHLIGHT%s$RST\n" "Restore First Snapshot"
git checkout $first_snapshot 2> /dev/null & pid=$!; wait $pid
echo "Print the content of the hello.sh"
echo "----------"
cat hello.sh
echo "----------"

printf "$HIGHLIGHT%s$RST\n" "Restore Second Recent Snapshot"
# note: detached HEAD state > return to main
git checkout $primary_branch
git checkout $second_recent_snapshot 2> /dev/null & pid=$!; wait $pid
echo "Print the content of the hello.sh"
echo "----------"
cat hello.sh
echo "----------"

printf "$HIGHLIGHT%s$RST\n" "Return to Latest Version"
git checkout -
cat hello.sh

printf "$BG_HIGHLIGHT%s$RST\n" "TAG me"
drawline
# ------------------------------------------
printf "$HIGHLIGHT%s$RST\n" "Referencing Current Version"
git tag v1
printf "$HIGHLIGHT%s$RST\n" "Tagging Previous Version"
git tag v1-beta HEAD^
# HEAD^ refers to the parent of the current commit (i.e., the previous commit)
# You can also use HEAD~1, which means "1 commit before HEAD"
printf "$HIGHLIGHT%s$RST\n" "Navigating Tagged Versions"      
# To move to the v1 tag:
git checkout v1       
# To move to the v1-beta tag:
git checkout v1-beta
# To return to the latest commit of your current branch (e.g., main):
git checkout $primary_branch
# Note: Replace 'main' with your branch name if different (e.g., 'master')
# If you're unsure which branch you were on, you can use:
git checkout -
printf "$HIGHLIGHT%s$RST\n" "Listing Tags"
git tag

printf "$BG_HIGHLIGHT Changed your mind?$RST\n"
drawline
# ------------------------------------------
printf "$HIGHLIGHT%s$RST\n" "Reverting Changes"

# modify of the file with unwanted comments
sed -i "s/# Default is \"World\"/# This is a bad comment. We want to revert it./" hello.sh 

# revert all unstaged changes
git checkout -- hello.sh

printf "$HIGHLIGHT%s$RST\n" "Staging and Cleaning"

# modify of the file with unwanted comments
sed -i "s/# This is a bad comment. We want to revert it./# This is an unwanted but staged comment/" hello.sh 

git add hello.sh

# Unstage the changes for a specific file:
git reset HEAD hello.sh
git checkout -- hello.sh

printf "$HIGHLIGHT%s$RST\n" "Committing and Reverting"

# modify of the file with unwanted comments
sed -i "s/# This is an unwanted but staged comment/# This is an unwanted but committed change/" hello.sh 
# 2. Stage the changes
git add hello.sh
# 3. Commit the changes
git commit -m "Added unwanted changes"
# 4. Revert the commit
git revert --no-edit HEAD

printf "$HIGHLIGHT%s$RST\n" "Tagging and Removing Commits"
git tag oops
printf "$HIGHLIGHT%s$RST\n" "Ensure that the HEAD points to v1"
git reset --hard v1

printf "$HIGHLIGHT%s$RST\n" "Displaying Logs with Deleted Commits"
git log --all --oneline  --grep="revert"
# git reflog

printf "$HIGHLIGHT%s$RST\n" "Cleaning Unreferenced Commits"
# 2. Remove any unreachable objects
git gc --prune=now -q
# If you want to be extra thorough:
# git gc --aggressive --prune=now

printf "$HIGHLIGHT%s$RST\n" "Author Information"
# Add an author comment to the file and commit the changes.
sed -i "s/# Default is \"World\"/# Default is World\\n# Author: Jim Weirich/" hello.sh 

git add hello.sh
git commit -m "Add author comment"

printf "$HIGHLIGHT%s$RST\n" "Oops the author email was forgotten"
sed -i "s/# Author: Jim Weirich/# Author: Jim Weirich\\n# Email: jim@weirich.net/" hello.sh 

git add hello.sh
git commit --amend -m "added author email"

printf "$BG_HIGHLIGHT%s$RST\n" "Move it"
drawline
# ------------------------------------------
echo "Moving hello.sh"

# move the program hello.sh into a lib/
mkdir "$user_repo""lib"
git mv hello.sh lib/
git commit -m "Move hello.sh to lib/ directory"

# create a Makefile in the root directory
cat <<EOF>Makefile
TARGET="lib/hello.sh"

run:
	bash \${TARGET}
EOF

git add Makefile
git commit -m "Add Makefile"

printf "$BG_HIGHLIGHT blobs, trees and commits$RST\n"
drawline
# ------------------------------------------

echo "Exploring .git/ Directory"

cd .git || return
ls

# echo "objects: The bookshelves containing different versions of your project files (represented by blobs)."
# echo "config: Library rules and settings, like opening hours and borrowing limits."
# echo "refs: Catalog cards showing which sections (branches) are currently active and where specific versions (commits) are located."
# echo "HEAD: The bookmark indicating which section (branch) you're currently browsing in the library."
# read -rp "Press Enter to continue" </dev/tty

printf "$HIGHLIGHT%s$RST\n" "Latest Object Hash"
git rev-parse HEAD
object=$(git rev-parse HEAD)
printf "$HIGHLIGHT%s$RST\n" "type of this object using Git commands"
git cat-file -t "$object"
printf "$HIGHLIGHT%s$RST\n" "content of this object using Git commands"
git cat-file -p "$object"

printf "$HIGHLIGHT%s$RST\n" "Dumping Directory Tree"

git ls-tree HEAD
git ls-tree HEAD:lib

cd "$user_repo""hello" || return

# back to the work tree
printf "$BG_HIGHLIGHT%s$RST\n" "Branching"
drawline
# ------------------------------------------

printf "$HIGHLIGHT%s$RST\n" "Create and Switch to New Branch"
git checkout -b greet & pid=$!; wait $pid

echo "Create a new file named greeter.sh"
pwd
cat <<EOF>lib/greeter.sh
#!/bin/bash

Greeter() {
    who="\$1"
    echo "Hello, \$who"
}
EOF

git add lib/greeter.sh
git commit -m "added greeter.sh"

echo "Update the lib/hello.sh"

cat <<EOF>lib/hello.sh
#!/bin/bash

source lib/greeter.sh

name="\$1"
if [ -z "\$name" ]; then
    name="World"
fi

Greeter "\$name"
EOF

git add lib/hello.sh
git commit -m "updated hello.sh to use greeter.sh"

sed -i "s/TARGET=\"lib\/hello.sh\"/# Ensure it runs the updated lib\/hello.sh file\\nTARGET=\"lib\/hello.sh\"/" Makefile

git add Makefile
git commit -m "added comment"

echo "Switch back to the $primary_branch branch, compare and show the differences between the $primary_branch and greet branches for Makefile, hello.sh, and greeter.sh files."
git checkout $primary_branch
git diff $primary_branch greet -- Makefile lib/hello.sh lib/greeter.sh

echo "Generate a README.md"

echo "This is the Hello World example from the git project." > README.md
git add README.md
git commit -m "added README.md"

printf "$HIGHLIGHT%s$RST\n" "Draw a commit tree diagram"
# git log --graph --oneline
git log --graph --all --decorate --oneline

printf "$BG_HIGHLIGHT Conflicts, merging and rebasing$RST\n"
drawline
# ------------------------------------------

before_merge=$(git log --pretty=format:"%H" -1)

printf "$HIGHLIGHT%s$RST\n" "Merge Main/Master into Greet Branch"
printf "$HIGHLIGHT%s$RST\n" "Merge the changes from the Main/Master branch into the greet branch"

git checkout greet
git merge --no-edit $primary_branch

# switch to main/master branch
git checkout $primary_branch

printf "$HIGHLIGHT%s$RST\n" "______________________________________"
pwd
tree

# make changes to hello.sh
cat <<EOF>hello.sh
#!/bin/bash

echo "What's your name"
read my_name

echo "Hello, \$my_name"
EOF

# save and commit the changes
git add hello.sh
git commit -m "unchanged previous changes"

echo "Merging Main/Master into Greet Branch (Conflict)"

git checkout greet
git merge --no-edit $primary_branch

# open vscode
if which $code_launch;
then
  $code_launch .
else
  printf "$HIGHLIGHT%s$RST\n" "vscode is not installed"
fi

# TEST whereami > greet
# echo "which branch I'm in"
# git rev-parse --abbrev-ref HEAD

printf "$HIGHLIGHT%s$RST\n" "commit before merge"
echo "$before_merge"

# pause to correct any conflicts
read -rp $'\e[41mCorrect the conflicts in your code editor and press Enter to continue\e[0m' </dev/tty

printf "$HIGHLIGHT%s$RST\n" "Rebasing Greet Branch"
git add hello.sh 
git commit -m "added hello.sh"

printf "$HIGHLIGHT%s$RST\n" "go back to the point before the initial merge between main/master and greet"
git checkout $before_merge 2> /dev/null & pid=$!; wait $pid
git rebase $primary_branch
# HEAD is now detached, going back to main
git checkout $primary_branch

printf "$HIGHLIGHT%s$RST\n" "Merging Greet into Main/Master"
# Merge the changes from the greet branch into the main/master branch.
git merge --no-edit greet

# pause to correct any conflicts (no conflicts)
# read -rp "Correct the conflicts and press Enter to continue" </dev/tty

# printf "$HIGHLIGHT%s$RST\n" "Understanding Fast-Forwarding and Differences:"
# printf "$HIGHLIGHT%s$RST\n" "Fast-forwarding is a specific type of merging that happens when the history allows for a simple extension without a new merge commit."
# printf "$HIGHLIGHT%s$RST\n" "Merging is the general concept of integrating changes, potentially creating a new merge commit or requiring conflict resolution."
# printf "$HIGHLIGHT%s$RST\n" "Rebasing is a powerful tool for manipulating history but should be used with caution, especially in collaborative workflows."

# pause to explain fast-forwarding and the difference between merging and rebasing.
# read -rp "Explain fast-forwarding and the difference between merging and rebasing" </dev/tty

printf "$BG_HIGHLIGHT%s$RST\n" "Local and remote repositories"
drawline
# ------------------------------------------

# In the work/ directory, make a clone of the repository hello as cloned_hello. (Do not use copy command)
cd "$user_repo" || return
git clone hello cloned_hello && cd cloned_hello || return
# Show the logs for the cloned repository.
git log --all --oneline
# Display the name of the remote repository and provide more information about it.
git remote -v
# List all remote and local branches in the cloned_hello repository.
git branch -a -v
# -a flag shows all branches, including local and remote.
# -v flag displays the branches in a verbose format, including the latest commit 

cd "$user_repo""hello" || return
# Make changes to the original repository, update the README.md file with the provided content, and commit the changes.
sed -i "s/This is the Hello World example from the git project./This is the Hello World example from the git project.\\n(changed in the original)/" README.md

# and commit the changes
git add README.md
git commit -m "added comment"

# Inside the cloned repository (cloned_hello)
cd "$user_repo""cloned_hello" || return

# fetch the changes from the remote repository
git fetch --all
# and display the logs. Ensure that commits from the hello repository are included in the logs.
git log --all --oneline
# Merge the changes from the remote main branch into the local main branch.
git merge origin/$primary_branch

# Add a local branch named greet tracking the remote origin/greet branch.
git checkout -b greet origin/greet

# Add a remote to your Git repository...
# git remote add origin $remote_url
git remote set-url origin "$remote_url"

# ...and push the main/master
echo "push main/master to origin..."
# git push -u origin $primary_branch & pid=$!; wait $pid
# ...and greet branches to the remote.
echo "push greet to origin..."
# git push -u origin greet & pid=$!; wait $pid
git push origin --all

# Be ready for this question in the audit!

# echo "solution: git pull origin main/master"
# read -rp "What is the single git command equivalent to what you did before to bring changes from remote to local main/master branch?" </dev/tty

printf "$BG_HIGHLIGHT%s$RST\n" "Bare repositories"
drawline
# ------------------------------------------

printf "$HIGHLIGHT%s$RST\n" "What is a bare repository and why is it needed?"

cd "$user_repo" || return

# Create a bare repository named hello.git from the existing hello repository.
git clone --bare hello hello.git & pid=$!; wait $pid
# change directory
cd "$user_repo""hello" || return
# Add the bare hello.git repository as a remote to the original repository hello.
git remote add origin "$user_repo""hello.git"
# Change the README.md file in the original repository with the provided content
sed -i "s/This is the Hello World example from the git project./This is the Hello World example from the git project.\\n(Changed in the original and pushed to shared)/" README.md
# Commit the changes...
git add README.md
git commit -m "added comment"
# ...and push them to the shared repository

# Switch to the cloned repository cloned_hello
cd "$user_repo""cloned_hello" || return
# and pull down the changes just pushed to the shared repository.
# ! change
git pull "$user_repo""hello.git"
