#!/usr/bin/env bash

# Notes
# wait, waitpid, waitid - wait for process to change state
# used for some process

# I'm using  `cmd > /dev/null` as a trashbin. Anything written on /dev/null will disappear, it is often called the black hole of Linux.
# Used for not showing some output, i our case it would overload the screen.

# ---------------------------------------------------------------------------
# VARS
# ---------------------------------------------------------------------------\

# main or master?
# https://www.zdnet.com/article/github-to-replace-master-with-main-starting-next-month/
primary_branch=main

# colors
HIGHLIGHT="\e[34m"
BG_HIGHLIGHT="\e[44m"
PROMPT_HIGHLIGHT="\e[32m"

BLACK="\e[30m"
RED="\e[31m"
WHITE="\e[37m"
BG_WHITE="\e[47m"

# Style
BOLD='\e[1m'
UNDR='\e[4m'
DIM="\E[2m"

# Reset
RST="\e[0m"

PrintGitLogo(){
echo -e "\n\n\n
${RED}⠀⠀⠀⠀⠀⢀⣤⡀⠀⠀⠀⠀⠀${BLACK}⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⠀⠀⠀⠀⠀⠀
${RED}⠀⠀⠀⠀⣀⠻⣿⣿⣦⡀⠀⠀⠀${BLACK}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⠿⠃⠀⣴⡆⠀⠀
${RED}⠀⠀⣠⣾⣿⣷⠉⢹⣿⣿⣆⠀⠀${BLACK}⠀⠀⢠⣴⣶⣶⣶⣶⠰⣶⣶⡆⣾⣿⣷⣶⡇
${RED}⢠⣾⣿⣿⣿⣿⡇⣧⡙⠻⣿⣷⡄${BLACK}⠀⠀⣿⣿⠀⢈⣿⡇⠀⢸⣿⡇⢸⣿⡇⠀⠀
${RED}⠈⢻⣿⣿⣿⣿⡇⣿⣧⣴⣿⡿⠃${BLACK}⠀⠀⢘⣿⠿⠿⠟⠁⠀⢸⣿⡇⢸⣿⣇⢀⡀
${RED}⠀⠀⠙⢿⣿⣿⡀⣸⣿⣿⠋⠀⠀${BLACK}⠀⠀⣻⣿⣿⣿⣿⣶⠸⠿⠿⠿⠀⠻⠿⠟⠃
${RED}⠀⠀⠀⠀⠙⢿⣿⣿⠟⠁⠀⠀⠀${BLACK}⠀⠀⢿⣧⣤⣤⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀
${RED}⠀⠀⠀⠀⠀⠀⠙⠁⠀⠀⠀⠀⠀${BLACK}⠀⠀⠀⠈⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n$RST"
}

# ---------------------------------------------------------------------------
# FUNCTIONS
# ---------------------------------------------------------------------------

# draw a line
function drawline {
  printf '\n\e[32m%*s\e[0m\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

function PrintTitle {
  # printf "\n${BG_HIGHLIGHT}%s${RST}\n"
  printf "\n\n$PROMPT_HIGHLIGHT$BOLD$UNDR%s$RST\n" "$1"
  drawline
}

# print audit question
function PrintQ {
  # printf "\n${BG_HIGHLIGHT}%s${RST}\n"
  printf "\n\n$PROMPT_HIGHLIGHT%s$RST\n\n" "$1"
}

# for printing the files
function PrintCmd {
  printf "command: $DIM%s$RST\n\n" "$1"
}

# for printing the files
function CatFile {
  printf "\n$DIM---%s$RST\n" "$1"
  cat -n "$1"
  printf "$DIM---$RST\n"
}

# check status and log GitStatus [log num]
function GitStatus {
  if [ $# -eq 0 ]
  then
    printf "$DIM%s$RST\n" "Git status:"
    git status
  else
    printf "$DIM%s$RST\n" "Git status:"
    git status
    echo ""
    printf "$DIM%s$RST\n" "Git logs:"
    git log --oneline -"$1"
  fi
}

# ! commented for testing purpose [START]

# # check if path exists and create stock it in a variable
# ensure_path() {
#     local input_path="$1"
#     local variable_name="$2"

#     # Add a trailing / if not already present
#     if [[ "${input_path}" != */ ]]; then
#         input_path="${input_path}/"
#     fi

#     # Check if the directory exists, create it if not
#     if [[ ! -d "${input_path}" ]]; then
#         mkdir -p "${input_path}"
#     fi

#     # Assign the path to the specified variable
#     eval "${variable_name}='${input_path}'"
# }

# # ---------------------------------------------------------------------------
# # PROMPTS
# # ---------------------------------------------------------------------------

# # project path
# # todo if folder doesn't exists
# echo "Choose the directory of your git project:"
# while true ; do
#     read -r -e -p "Path: " filepath
#     if [[ "${filepath}" != */ ]]; then
#         filepath="${filepath}/"
#     fi
#     if [ -d "$filepath" ] ; then
#         break
#     else
#     fi
#     echo "$filepath is not a directory..."
# done
# user_repo=${filepath}
# echo Selected: "$user_repo"

# drawline

# # choice editor
# names=(Vscode Codium)
# selected=()
# PS3='Which code editor do you use? '
# select name in "${names[@]}" ; do
#     for reply in $REPLY ; do
#         selected+=(${names[reply - 1]})
#     done
#     [[ $selected ]] && break
# done
# code_editor=${selected[@]}
# if [ "$code_editor" == "Vscode" ]; then
#   code_launch=code
# else
#   code_launch=codium
# fi

# echo Selected: "$code_editor"

# drawline

# # choice repository
# names=(Github Gitea)
# selected=()
# PS3='Which Git hosting service do you use? '
# select name in "${names[@]}" ; do
#     for reply in $REPLY ; do
#         selected+=(${names[reply - 1]})
#     done
#     [[ $selected ]] && break
# done
# remote_git=${selected[@]}
# # echo Selected: "$remote_git"

# drawline

# read -p "Enter your $remote_git repository: " remote_url

# drawline

# read -p "Enter your $remote_git account name: " user_name

# drawline

# read -p "Enter your $remote_git account email: " user_email

# drawline

# echo "Please check your answers:"
# printf "The directory of this project: $PROMPT_HIGHLIGHT%s$RST\n" "$user_repo"
# printf "Your code editor:  $PROMPT_HIGHLIGHT%s$RST\n" "$code_editor" 
# printf "Your remote repository: $PROMPT_HIGHLIGHT%s$RST\n" "$remote_url" 
# printf "Your remote repository name: $PROMPT_HIGHLIGHT%s$RST\n" "$user_name"  
# printf "Your remote repository email: $PROMPT_HIGHLIGHT%s$RST\n" "$user_email"  

# # echo Your username is $username, we will not display your password
# while true; do
#     read -p "Are these informations corrects? " yn
#     case $yn in
#         [Yy]* ) break;;
#         [Nn]* ) exit;;
#         * ) echo "Please answer yes or no.";;
#     esac
# done
# drawline

# ! for testing purpose

# import a .env file with some infos:
# user_repo=<user repo>
# code_launch=<code editor>
# remote_url=<remote url>
# user_name=<name>
# user_email=<email>

set -a # automatically export all variables
source .env
set +a

# ! for testing purpose [END]

# ---------------------------------------------------------------------------
# START
# ---------------------------------------------------------------------------

PrintGitLogo # print the git logo

# ---------------------------------------------------------------------------



PrintTitle "Setup and Installation"



# ---------------------------------------------------------------------------


PrintQ "Did the student successfully install Git on their local machine?"
# ---------------------------------------------------------------------------

if git --version ./?> /dev/null;
then
  # echo GIT is installed
  git --version
else
  echo GIT is not installed
  # install git
  sudo apt install git-all & pid=$!; wait $pid
  git --version
fi

# ---------------------------------------------------------------------------

# create a Hello directory

mkdir -p "$user_repo""hello" && cd "$_"  || return

# Git configuration

# Initialisation of the git repository

git init > /dev/null && pid=$!; wait $pid

# default branch name to avoid the warning message
git config --local init.defaultBranch $primary_branch

# ? store credential
git config --local credential.helper store

# configure --local
git config --local user.name $user_name
git config --local user.email $user_email

# ---------------------------------------------------------------------------


PrintQ "Did the student configure Git with a valid username and email address?"
# ---------------------------------------------------------------------------

git config user.name
git config user.email


# ---------------------------------------------------------------------------



PrintTitle "Git commits to commit"



# ---------------------------------------------------------------------------


PrintQ "Did the student navigate to the work directory and create a subdirectory named hello?"
# ---------------------------------------------------------------------------

tree "$user_repo"


PrintQ 'Did the student generate a file named hello.sh with the content echo "Hello, World" inside the hello directory?'
# ---------------------------------------------------------------------------

# Create a file
echo 'echo "Hello, World"' > "$user_repo""hello/hello.sh"

# first commit
git add "$user_repo""hello/hello.sh" > /dev/null
git commit -m "init, added hello.sh" > /dev/null

# ! generate and store First_Snapshot hastag <------------------------------------------------------------------<<<
first_snapshot=$(git log --pretty=format:"%H" -1)
printf "$RED%s$RST\n" "$(git log --pretty=format:"%H" -1)"

# * proof

tree "$user_repo"
CatFile "$user_repo""hello/hello.sh"


PrintQ "Did the student initialize a Git repository in the hello directory?"
# ---------------------------------------------------------------------------

GitStatus 1


PrintQ "Did the student use the git status command to check the status of the repository?"
# ---------------------------------------------------------------------------

echo -e "Yes"


PrintQ 'Did the student modify the hello.sh file content with the provided echo "Hello, $1"?'
# ---------------------------------------------------------------------------

# modify the file
cat <<EOF>"$user_repo""hello/hello.sh"
#!/bin/bash

echo "Hello, \$1"
EOF


CatFile "$user_repo""hello/hello.sh"


PrintQ 'Did the student stage the modified hello.sh file, commit the changes to the repository, and ensure that the working tree is clean afterward?'
# ---------------------------------------------------------------------------

# stage
git add hello.sh > /dev/null
# commit
git commit -m "added shebang and argument" > /dev/null 

# check
GitStatus 2


PrintQ 'Did the student further modify the hello.sh file to include comments, and then make two separate commits as instructed?'
# ---------------------------------------------------------------------------

#  modify line 3
cat <<EOF>hello.sh
#!/bin/bash

# Default is "World"
echo "Hello, \$1"
EOF

git add "$user_repo""hello/hello.sh" > /dev/null
git commit -m "line 3, added comment" > /dev/null

# show content
CatFile "$user_repo""hello/hello.sh"


# ! generate and store Second_Recent_Snapshot hastag <------------------------------------------------------------------<<<
second_recent_snapshot=$(git log --pretty=format:"%H" -1)
printf "$RED%s$RST\n" "$(git log --pretty=format:"%H" -1)"

# Modify line 4 and 5
cat <<EOF>hello.sh
#!/bin/bash

# Default is "World"
name=\${1:-"World"}
echo "Hello, \$name"
EOF

git add "$user_repo""hello/hello.sh" > /dev/null
git commit -m "line 4 and 5, added variable" > /dev/null

# show content
CatFile "$user_repo""hello/hello.sh"


PrintQ 'Did the student make two separate commits, with the first commit for the comment in line 1 and the second commit for the changes made to lines 3 and 4, as instructed?'
# ---------------------------------------------------------------------------

# check
GitStatus 2


# ---------------------------------------------------------------------------



PrintTitle "History"



# ---------------------------------------------------------------------------


PrintQ 'Did the student display the Git history of the working directory with the git log command?'
# ---------------------------------------------------------------------------

# display the Git history
PrintCmd 'git log'
git log


PrintQ 'Did the student successfully display a condensed view of the Git history, showing only commit hashes and messages using the "One-Line History" format?'
# ---------------------------------------------------------------------------

PrintCmd 'git log --oneline'
git log --oneline



PrintQ 'Was the student able to customize the log output to display the last 2 entries?'
# ---------------------------------------------------------------------------

PrintCmd 'git log --oneline -2'
git log --oneline -2


PrintQ 'Did the student successfully demonstrate viewing commits made within the last 5 minutes?'
# ---------------------------------------------------------------------------

PrintCmd 'git log --since="5 minutes ago" --until="now"'
git log --since="5 minutes ago" --until="now"


PrintQ 'Did the student successfully customize the format of Git logs and display them according to this example'
printf "Example: $DIM%s$RST\n\n" " * e4e3645 2023-06-10 | Added a comment (HEAD -> main) [John Doe]?"
# ---------------------------------------------------------------------------


# customize the format
git log --pretty=format:"%h %ad | %s%d [%an]" --date=short


# ---------------------------------------------------------------------------



PrintTitle "Check it out"



# ---------------------------------------------------------------------------


PrintQ 'Did the student successfully restore the first snapshot of the working tree and print the content of hello.sh?'
# ---------------------------------------------------------------------------

# restore First Snapshot
PrintCmd "git checkout $first_snapshot"
git checkout $first_snapshot 2> /dev/null & pid=$!; wait $pid

# show content
CatFile "$user_repo""hello/hello.sh"


PrintQ 'Did the student successfully restore the second recent snapshot and print the content of hello.sh?'
# ---------------------------------------------------------------------------

# restore First Snapshot
PrintCmd "git checkout $second_recent_snapshot"
git checkout $second_recent_snapshot 2> /dev/null & pid=$!; wait $pid

# show content
CatFile "$user_repo""hello/hello.sh"


PrintQ 'Did the student ensure that the working directory reflects the latest version of hello.sh from the main branch without using commit hashes?'
# ---------------------------------------------------------------------------

PrintCmd "git checkout $primary_branch"
git checkout $primary_branch 2> /dev/null & pid=$!; wait $pid

# show content
CatFile "$user_repo""hello/hello.sh"


# ---------------------------------------------------------------------------



PrintTitle "TAG me"



# ---------------------------------------------------------------------------


PrintQ 'Did the student successfully tag the current version of the repository as v1?'
# ---------------------------------------------------------------------------

PrintCmd "git tag v1"
git tag v1
git log --oneline -1


PrintQ 'Did the student successfully tag the version immediately prior to the current version as v1-beta, without relying on commit hashes?'
# ---------------------------------------------------------------------------

PrintCmd "git tag v1-beta HEAD~1"
git tag v1-beta HEAD~1
git log --oneline -2


PrintQ 'Did the student navigate back and forth between the two tagged versions, v1 and v1-beta?'
# ---------------------------------------------------------------------------

# Tnavigate back and forth between the two tagged versions
# v1
PrintCmd "git checkout v1"
git checkout v1 2> /dev/null
git log --oneline -2

# v1-beta
PrintCmd "git checkout v1-beta"
git checkout v1-beta 2> /dev/null
git log --oneline -2

# To return to the latest commit of your current branch (e.g., main):
echo -e "\nReturning to the latest commit of your current branch"
PrintCmd "git checkout $primary_branch"
git checkout $primary_branch 2> /dev/null
git log --oneline -1


PrintQ 'Did the student display a list of all tags present in the repository to verify successful tagging?'
# ---------------------------------------------------------------------------

echo -e "Yes"


# ---------------------------------------------------------------------------



PrintTitle "Changed your mind?"


# ---------------------------------------------------------------------------


PrintQ 'Did the student successfully revert the modifications made to the latest version of the file, restoring it to its original state before staging using a Git command?'
# ---------------------------------------------------------------------------

# modify of the file with unwanted comments
sed -i "s/# Default is \"World\"/# This is a bad comment. We want to revert it./" "$user_repo""hello/hello.sh"

# show content
CatFile "$user_repo""hello/hello.sh"

# revert all unstaged changes
PrintCmd "git restore hello.sh"
git restore "$user_repo""hello/hello.sh"
# restore for newest version of git otherwise `git checkout -- <filename>`

# show content
CatFile "$user_repo""hello/hello.sh"


PrintQ 'Did the student introduce unwanted changes to the file, stage them, and then successfully clean the staging area to discard the changes?'
# ---------------------------------------------------------------------------

# modify of the file with unwanted comments
sed -i "s/# Default is \"World\"/# This is an unwanted but staged comment/" "$user_repo""hello/hello.sh"

# show content
CatFile "$user_repo""hello/hello.sh"

# stage the file
git add "$user_repo""hello/hello.sh"

GitStatus

# revert all staged changes
PrintCmd "git reset HEAD hello.sh"
git reset HEAD "$user_repo""hello/hello.sh"

PrintCmd "git restore hello.sh"
git restore "$user_repo""hello/hello.sh"

# show content
CatFile "$user_repo""hello/hello.sh"

GitStatus


PrintQ 'Did the student add unwanted changes again, stage the file, commit the changes, and then revert them back to their original state?'
# ---------------------------------------------------------------------------

# modify of the file with unwanted comments
sed -i "s/# Default is \"World\"/# This is an unwanted but committed change/" "$user_repo""hello/hello.sh"

# show content
CatFile "$user_repo""hello/hello.sh"

# stage the file
PrintCmd 'git add hello.sh"'
git add "$user_repo""hello/hello.sh"

PrintCmd 'git commit -m "added an unwanted change, stage it and commit it"'
# commit the changes
git commit -m "added an unwanted change, stage it and commit it"

# proof
git log --oneline -1

PrintCmd 'git revert HEAD'
git revert --no-edit HEAD

# show content
CatFile "$user_repo""hello/hello.sh"

# proof
git log --oneline -1


PrintQ 'Did the student tag the latest commit with oops and remove commits made after the v1 version, ensuring that the HEAD points to v1?'
# ---------------------------------------------------------------------------

# tagging the latest commit "oops"
PrintCmd 'git tag oops'
git tag oops

# proof
git log --oneline

PrintCmd 'git reset --hard v1'
git reset --hard v1

# proof
git log --oneline


PrintQ 'Did the student display the logs with the deleted commits, particularly focusing on the commit tagged oops?'
# ---------------------------------------------------------------------------

PrintCmd 'git log --all --oneline  --grep="revert"'
git log --all --oneline  --grep="revert"


PrintQ "Did the student ensure that unreferenced commits were deleted from the history, with no logs remaining for these deleted commits?"
# ---------------------------------------------------------------------------

# delete tags and branches referencing the commits
PrintCmd 'git tag -d "oops"'
git tag -d "oops"

# note, if pushed to remote `git push origin --delete oops`

# expire reflog entries
PrintCmd 'git reflog expire --expire-unreachable=now --all'
git reflog expire --expire-unreachable=now --all

# run garbage collection
PrintCmd 'git gc --prune=now --aggressive'
git gc --prune=now --aggressive 2> /dev/null

# proof
PrintCmd 'git log --oneline --all'
git log --oneline --all


PrintQ 'Did the student add author information to the file and commit the changes?'
# ---------------------------------------------------------------------------

# Add an author comment to the file and commit the changes.
sed -i "s/# Default is \"World\"/# Default is World\\n# Author: Jim Weirich/" "$user_repo""hello/hello.sh"

# show content
CatFile "$user_repo""hello/hello.sh"

PrintCmd 'git add hello.sh'
git add "$user_repo""hello/hello.sh"

PrintCmd 'git commit -m "Add author comment"'
git commit -m "Add author comment"

# proof
git log --oneline -1


PrintQ 'Did the student update the file to include the author email without making a new commit, but included the change in the last commit?'
# ---------------------------------------------------------------------------

sed -i "s/# Author: Jim Weirich/# Author: Jim Weirich\\n# Email: jim@weirich.net/" "$user_repo""hello/hello.sh"

# show content
CatFile "$user_repo""hello/hello.sh"

PrintCmd 'git add hello.sh'
git add "$user_repo""hello/hello.sh"

PrintCmd 'git commit --amend -m "Add author comment and email"'
git commit --amend -m "Add author comment and author email"




# proof
git log --oneline -1


# ---------------------------------------------------------------------------



PrintTitle "Move it"


# ---------------------------------------------------------------------------


PrintQ 'Did the student successfully move the hello.sh program into a lib/ directory using Git commands?'
# ---------------------------------------------------------------------------

# move the program hello.sh into a lib/
PrintCmd 'mkdir "lib"'
mkdir "$user_repo""hello/lib"

PrintCmd 'git mv "hello.sh" "lib/"'
git mv "$user_repo""hello/hello.sh" "$user_repo""hello/lib/"

tree "$user_repo""hello"


PrintQ 'Did the student commit the move of hello.sh?'
# ---------------------------------------------------------------------------

git commit -m "moved hello.sh to lib/ using Git command"
git log --oneline -1


PrintQ 'Did the student create and commit a Makefile in the root directory of the repository with the provided content?'
# ---------------------------------------------------------------------------

# create the Makefile at the root of the repository
cat <<EOF>"$user_repo""hello/Makefile"
TARGET="lib/hello.sh"

run:
	bash \${TARGET}
EOF

# show content
CatFile "$user_repo""hello/Makefile"

PrintCmd 'git add Makefile'
git add "$user_repo""hello/Makefile"

PrintCmd 'git commit -m "Added Makefile"'
git commit -m "Added Makefile"


# ---------------------------------------------------------------------------



PrintTitle "blobs, trees and commits"



# ---------------------------------------------------------------------------


PrintQ 'Ask the student to navigate to the .git/ directory and explain to you the purpose of each subdirectory, including objects/, config, refs, and HEAD.'
# ---------------------------------------------------------------------------

PrintCmd 'tree -L 1 .git'
tree -L 1 .git

cat << EOF

- branches        folder, contains information about remote branches (deprecated)
- COMMIT_EDITMSG  file that contains the commit message of the most recent commit
- config          configuration file for the repository, containing settings such as remote repositories, branch information, and user identity
- description     file (plain-text) containing a description of the repository
- HEAD            file that points to the current branch reference, typically refs/heads/main
- hooks           folder, contains client- or server-side scripts that Git executes before or after certain operations, like committing or merging
- index           file, staging area (or cache), where changes are stored before they are committed
- info            folder, contains global exclude patterns for the repository (in the exclude file)
- logs            folder, stores logs for the reflog, which keeps track of updates to the tips of branches and other references
- objects         folder, stores all the content (blobs, trees, and commits) as binary files
- ORIG_HEAD       file that records the original reference of HEAD before a potentially dangerous operation, such as a merge or a reset
- packed-refs     file that stores a packed version of all references
- refs            folder, contains references to commit objects. This includes heads (branches), tags, and remote-tracking branches

[source](https://git-scm.com/docs/gitrepository-layout)
EOF


PrintQ 'Was the student able to explain the purpose of each subdirectory, including objects/, config, refs, and HEAD?'
# ---------------------------------------------------------------------------

echo -e "Most likely"


PrintQ 'Did the student successfully find the latest object hash within the .git/objects/ directory using Git commands?'
# ---------------------------------------------------------------------------

PrintCmd 'git log -1 --format="%H"'
LAST_OBJECT="$(git log -1 --format="%H")"
echo -e "$LAST_OBJECT"
# check with `find .git/objects -type f -printf '%T@ %p\n' | sort -n | tail -1`

cat << EOF

git log: shows the commit logs
-1: limits the output to the latest commit
--format="%H": specifies the format to show only the commit hash
EOF


PrintQ 'Was the student able to print the type and content of this object using Git commands?'
# ---------------------------------------------------------------------------

PrintCmd 'git cat-file -t "$(git log -1 --format="%H")"'
git cat-file -t "$LAST_OBJECT"

PrintCmd 'git cat-file -p "$(git log -1 --format="%H")"'
git cat-file -p "$LAST_OBJECT"

cat << EOF
'-t' type
'-p' content
EOF


PrintQ 'Did the student use Git commands to dump the directory tree referenced by a specific commit?'
# ---------------------------------------------------------------------------

# dump the directory tree referenced by this commit
PrintCmd "git ls-tree --full-tree -r $LAST_OBJECT"
git ls-tree --full-tree -r "$LAST_OBJECT"
echo -e ""


PrintQ "Were they able to dump the contents of the lib/ directory and the hello.sh file using Git commands?"
# ---------------------------------------------------------------------------

# dump the contents of the lib/ directory using Git commands
PrintCmd "git ls-tree --full-tree -r HEAD lib"
git ls-tree --full-tree -r "HEAD" lib
echo -e ""

# dump the contents of the hello.sh file using Git commands
PrintCmd "git show HEAD:lib/hello.sh"
git show HEAD:lib/hello.sh


# ---------------------------------------------------------------------------



PrintTitle "Branching, Merging & Rebasing"



# ---------------------------------------------------------------------------


PrintQ "Did the student successfully create and switch to a new branch named greet?"







# ---------------------------------------------------------------------------



exit 1




cd "$user_repo""hello" || return

# back to the work tree
printf "$BG_HIGHLIGHT%s$RST\n" "Branching"

drawline # -----------------------------------------------------------------

# ------------------------------------------

# ---------------------------------------------------------------------------
PrintQ "Create and Switch to New Branch"
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

# ---------------------------------------------------------------------------
PrintQ "Draw a commit tree diagram"
# git log --graph --oneline
git log --graph --all --decorate --oneline

printf "$BG_HIGHLIGHT Conflicts, merging and rebasing$RST\n"

drawline # -----------------------------------------------------------------

# ------------------------------------------

before_merge=$(git log --pretty=format:"%H" -1)

# ---------------------------------------------------------------------------
PrintQ "Merge Main/Master into Greet Branch"
# ---------------------------------------------------------------------------
PrintQ "Merge the changes from the Main/Master branch into the greet branch"

git checkout greet
git merge --no-edit $primary_branch

# switch to main/master branch
git checkout $primary_branch

# ---------------------------------------------------------------------------
PrintQ "______________________________________"
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

# ---------------------------------------------------------------------------
PrintQ "commit before merge"
echo "$before_merge"

# pause to correct any conflicts
read -rp $'\e[41mCorrect the conflicts in your code editor and press Enter to continue\e[0m' </dev/tty

# ---------------------------------------------------------------------------
PrintQ "Rebasing Greet Branch"
git add hello.sh 
git commit -m "added hello.sh"

# ---------------------------------------------------------------------------
PrintQ "go back to the point before the initial merge between main/master and greet"
git checkout $before_merge 2> /dev/null & pid=$!; wait $pid
git rebase $primary_branch
# HEAD is now detached, going back to main
git checkout $primary_branch

# ---------------------------------------------------------------------------
PrintQ "Merging Greet into Main/Master"
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

exit 0

printf "$BG_HIGHLIGHT%s$RST\n" "Local and remote repositories"

drawline # -----------------------------------------------------------------

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

drawline # -----------------------------------------------------------------

# ------------------------------------------

# ---------------------------------------------------------------------------
PrintQ "What is a bare repository and why is it needed?"

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
