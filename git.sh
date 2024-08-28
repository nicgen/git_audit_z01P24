#!/usr/bin/env bash

# Notes

# wait, waitpid, waitid - wait for process to change state
# used for some process

# I'm using  `cmd > /dev/null` as a trashbin. Anything written on /dev/null will disappear, it is often called the black hole of Linux.
# Used for not showing some output, in our case it would overload the screen.

# ---------------------------------------------------------------------------
# VARS
# ---------------------------------------------------------------------------\

# main vs master?
# https://www.zdnet.com/article/github-to-replace-master-with-main-starting-next-month/
primary_branch=main

# TESTING part
full_script=0 # do you want to fully execute the script, even the remote part?

script_path="$(dirname -- "${BASH_SOURCE[0]}")"
echo $script_path

# colors
HIGHLIGHT="\e[34m"
BG_HIGHLIGHT="\e[44m"
PROMPT_HIGHLIGHT="\e[32m"

BLACK="\e[30m"
RED="\e[31m"
WHITE="\e[37m"
BG_WHITE="\e[47m"
BG_RED="\e[41m"
YELLOW="\e[33m"

# Style
BOLD='\e[1m'
UNDR='\e[4m'
DIM="\E[2m"
EXPND="\e[K"

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

PrintEnd(){
echo -e "\n
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠤⠲⠦⠉⠉⠉⠏⠉⠒⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢀⡠⠲⠃⢀⣤⠀⠀⠀⠲⠂⠀⠠⠆⠀⠙⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⡔⠁⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⠊⠁⠀⢁⡴⠚⠉⣉⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⠠⠤⠔⠒⡄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⡆⢰⠆⠀⠋⣠⠔⠉⠁⣀⡠⠄⠒⠂⠀⠀⠀⠀⠀⠀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠔⠊⠁⠀⠀⠀⠀⠀⣠⡴⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢠⡆⠀⠀⠀⡜⠁⣠⠔⠋⢁⡔⠒⠒⠤⡀⠀⠀⠀⠀⡐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠎⠀⠀⠀⢀⣀⣤⣶⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⡆⡶⠀⠀⢀⡜⠁⢀⣀⢸⠀⠀⠀⠀⠈⢆⠀⠀⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⠊⠁⠀⢀⡀⣴⡿⠿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠰⡀⠀⠀⠘⠀⡞⠁⠀⠉⢇⠀⣿⣄⠀⠈⡆⠀⠕⠒⠉⣉⡒⡄⠀⠀⠀⠀⢀⠤⠊⠁⢀⡠⠔⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠑⢄⡀⠀⠀⢇⠀⣤⡄⠈⢢⡈⠻⡖⢀⡞⣀⠔⠊⠁⠀⠀⠉⠐⠒⠠⢎⢁⡠⠔⠂⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⢂⠘⢿⣦⡇⠉⠓⢶⡫⠞⠁⣀⣤⣤⣤⣤⣤⣤⣤⠴⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢡⠦⠭⡇⠀⡠⠊⠀⣠⣮⣬⣿⣿⣿⣿⣿⣯⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠁⢀⠔⡧⠊⠀⢀⡜⠁⠙⣿⣿⣿⡿⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣀⣡⠎⠀⠀⢠⠊⠀⠀⠀⣸⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠃⠀⠀⣰⣧⣀⣀⡠⣴⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢧⣤⣤⣾⡿⠿⠋⠁⠀⢹⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠿⠛⠛⠛⠛⠻⢿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡸⠀⠀⠀⠀⠀⠀⠀⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠁⡰⢤⣀⣀⡄⢠⠞⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
"
}

# ---------------------------------------------------------------------------
# FUNCTIONS
# ---------------------------------------------------------------------------

# draw a line
function drawline {
printf '\n\e[32m%*s\e[0m\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

# print title
function PrintTitle {
printf "\n\n$PROMPT_HIGHLIGHT$BOLD$UNDR%s$RST\n" "$1"
drawline
}

# print audit question
function PrintQ {
printf "\n\n$PROMPT_HIGHLIGHT%s$RST\n" "$1"
}

# for printing the files
function PrintCmd {
printf "\n$DIM%s$YELLOW%s$RST\n\n" "command: " "$1"
}

# for printing the files
function CatFile {
{ printf "\n$DIM---%s$RST\n" "$1"; cat -n "$1"; printf "$DIM---$RST\n"; }
}

# for printing the files
function CatTxt {
{ printf "\n$DIM---%s$RST\n";echo -e "$1";printf "$DIM---$RST\n"; }
}

function GitLog {
printf "\n$DIM%s$RST\n" "logs:"
if [ $# -eq 0 ]
then
git log
else
git log -$1
fi
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
    echo -e "\n"
    printf "$DIM%s$RST\n" "Git logs:"
    git log --oneline -"$1"
  fi
}

# for debuging purpose
function DebugHere {
printf '\n\e[32m%*s\e[0m\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' #
echo -e "\n$BG_RED$EXPND" "DEBUG" "$RST"
# echo -e "\n$BG_RED$EXPND""$(git log)""$RST"
printf '\n\e[32m%*s\e[0m\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' #
# before_merge=$(git log --pretty=format:"%H" -1)
echo -e "\n$BG_RED%s$EXPND" "$before_merge"
}

# ! commented for testing purpose [START]

# check if path exists and create stock it in a variable
ensure_path() {
    local input_path="$1"
    # local variable_name="$2"

    # Remove a trailing / if not already present
    if [[ "${input_path}" == */ ]]; then
        input_path="${input_path::-1}"
    fi

    # Check if the directory exists, create it if not
    if [[ ! -d "${input_path}" ]]; then
        mkdir -p "${input_path}"
    fi

    # Assign the path to the specified variable
    # eval "${variable_name}='${input_path}'"
    echo -e "${input_path}"
}

# ! ENV [START]

# ? Import variables from the .env file:
# ```txt file=.env
# user_repo=<user repo>
# code_launch=<code editor>
# remote_url=<remote url>
# user_name=<name>
# user_email=<email>
# ```

# ! uncomment for testing purpose
set -a # automatically import all variables from your .env file
if [ ! -f $script_path/.env ]; then
echo "The .env file is not found!"
exit 1
else
source .env
fi
set +a
# !

# ! ENV [END]

# ---------------------------------------------------------------------------
# START
# ---------------------------------------------------------------------------

PrintGitLogo # print the git logo

# ---------------------------------------------------------------------------



PrintTitle "Setup and Installation"



# ---------------------------------------------------------------------------


PrintQ "Did the student successfully install Git on their local machine?"
# ---------------------------------------------------------------------------

PrintCmd "git --version"

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

mkdir -p "$user_repo/hello" && cd "$_"  || return

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

PrintCmd "git config user.name"
git config user.name

PrintCmd "git config user.email"
git config user.email


# ---------------------------------------------------------------------------



PrintTitle "Git commits to commit"



# ---------------------------------------------------------------------------


PrintQ "Did the student navigate to the work directory and create a subdirectory named hello?"
# ---------------------------------------------------------------------------

PrintCmd "tree $user_repo"
tree "$user_repo"


PrintQ 'Did the student generate a file named hello.sh with the content echo "Hello, World" inside the hello directory?'
# ---------------------------------------------------------------------------

# Create a file
echo 'echo "Hello, World"' > "$user_repo/hello/hello.sh"

# first commit
git add "$user_repo/hello/hello.sh" > /dev/null
git commit -m "init, added hello.sh" > /dev/null

# ! generate and store First_Snapshot hastag <------------------------------------------------------------------<<<
first_snapshot=$(git log --pretty=format:"%H" -1)
printf "$RED%s$RST\n" "$(git log --pretty=format:"%H" -1)"

# * proof

tree "$user_repo"
CatFile "$user_repo/hello/hello.sh"


PrintQ "Did the student initialize a Git repository in the hello directory?"
# ---------------------------------------------------------------------------

GitStatus 1


PrintQ "Did the student use the git status command to check the status of the repository?"
# ---------------------------------------------------------------------------

echo -e "Yes"


PrintQ 'Did the student modify the hello.sh file content with the provided echo "Hello, $1"?'
# ---------------------------------------------------------------------------

# modify the file
cat <<EOF>"$user_repo/hello/hello.sh"
#!/bin/bash

echo "Hello, \$1"
EOF


CatFile "$user_repo/hello/hello.sh"


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

git add "$user_repo/hello/hello.sh" > /dev/null
git commit -m "line 3, added comment" > /dev/null

# show content
CatFile "$user_repo/hello/hello.sh"


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

git add "$user_repo/hello/hello.sh" > /dev/null
git commit -m "line 4 and 5, added variable" > /dev/null

# show content
CatFile "$user_repo/hello/hello.sh"


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
GitLog 2


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
CatFile "$user_repo/hello/hello.sh"


PrintQ 'Did the student successfully restore the second recent snapshot and print the content of hello.sh?'
# ---------------------------------------------------------------------------

# restore First Snapshot
PrintCmd "git checkout $second_recent_snapshot"
git checkout $second_recent_snapshot 2> /dev/null & pid=$!; wait $pid

# show content
CatFile "$user_repo/hello/hello.sh"


PrintQ 'Did the student ensure that the working directory reflects the latest version of hello.sh from the main branch without using commit hashes?'
# ---------------------------------------------------------------------------

PrintCmd "git checkout $primary_branch"
git checkout $primary_branch 2> /dev/null & pid=$!; wait $pid

# show content
CatFile "$user_repo/hello/hello.sh"


# ---------------------------------------------------------------------------



PrintTitle "TAG me"



# ---------------------------------------------------------------------------


PrintQ 'Did the student successfully tag the current version of the repository as v1?'
# ---------------------------------------------------------------------------

PrintCmd "git tag v1"
git tag v1
GitLog 1


PrintQ 'Did the student successfully tag the version immediately prior to the current version as v1-beta, without relying on commit hashes?'
# ---------------------------------------------------------------------------

PrintCmd "git tag v1-beta HEAD~1"
git tag v1-beta HEAD~1
GitLog 2


PrintQ 'Did the student navigate back and forth between the two tagged versions, v1 and v1-beta?'
# ---------------------------------------------------------------------------

# Tnavigate back and forth between the two tagged versions
# v1
PrintCmd "git checkout v1"
git checkout v1 2> /dev/null
GitLog 2

# v1-beta
PrintCmd "git checkout v1-beta"
git checkout v1-beta 2> /dev/null
GitLog 2

# To return to the latest commit of your current branch (e.g., main):
echo -e "\nReturning to the latest commit of your current branch"
PrintCmd "git checkout $primary_branch"
git checkout $primary_branch 2> /dev/null
GitLog 1


PrintQ 'Did the student display a list of all tags present in the repository to verify successful tagging?'
# ---------------------------------------------------------------------------

echo -e "Yes"


# ---------------------------------------------------------------------------



PrintTitle "Changed your mind?"


# ---------------------------------------------------------------------------


PrintQ 'Did the student successfully revert the modifications made to the latest version of the file, restoring it to its original state before staging using a Git command?'
# ---------------------------------------------------------------------------

# modify of the file with unwanted comments
sed -i "s/# Default is \"World\"/# This is a bad comment. We want to revert it./" "$user_repo/hello/hello.sh"

# show content
CatFile "$user_repo/hello/hello.sh"

# revert all unstaged changes
PrintCmd "git restore hello.sh"
git restore "$user_repo/hello/hello.sh"
# restore for newest version of git otherwise `git checkout -- <filename>`

# show content
CatFile "$user_repo/hello/hello.sh"


PrintQ 'Did the student introduce unwanted changes to the file, stage them, and then successfully clean the staging area to discard the changes?'
# ---------------------------------------------------------------------------

# modify of the file with unwanted comments
sed -i "s/# Default is \"World\"/# This is an unwanted but staged comment/" "$user_repo/hello/hello.sh"

# show content
CatFile "$user_repo/hello/hello.sh"

# stage the file
git add "$user_repo/hello/hello.sh"

GitStatus

# revert all staged changes
PrintCmd "git reset HEAD hello.sh"
git reset HEAD "$user_repo/hello/hello.sh"

PrintCmd "git restore hello.sh"
git restore "$user_repo/hello/hello.sh"

# show content
CatFile "$user_repo/hello/hello.sh"

GitStatus


PrintQ 'Did the student add unwanted changes again, stage the file, commit the changes, and then revert them back to their original state?'
# ---------------------------------------------------------------------------

# modify of the file with unwanted comments
sed -i "s/# Default is \"World\"/# This is an unwanted but committed change/" "$user_repo/hello/hello.sh"

# show content
CatFile "$user_repo/hello/hello.sh"

# stage the file
PrintCmd 'git add hello.sh"'
git add "$user_repo/hello/hello.sh"

PrintCmd 'git commit -m "added an unwanted change, stage it and commit it"'
# commit the changes
git commit -m "added an unwanted change, stage it and commit it"

# proof
GitLog 1

PrintCmd 'git revert HEAD'
git revert --no-edit HEAD

# show content
CatFile "$user_repo/hello/hello.sh"

# proof
GitLog 1


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
sed -i "s/# Default is \"World\"/# Default is World\\n# Author: Jim Weirich/" "$user_repo/hello/hello.sh"

# show content
CatFile "$user_repo/hello/hello.sh"

PrintCmd 'git add hello.sh'
git add "$user_repo/hello/hello.sh"

PrintCmd 'git commit -m "Add author comment"'
git commit -m "Add author comment"

# proof
GitLog 1


PrintQ 'Did the student update the file to include the author email without making a new commit, but included the change in the last commit?'
# ---------------------------------------------------------------------------

sed -i "s/# Author: Jim Weirich/# Author: Jim Weirich\\n# Email: jim@weirich.net/" "$user_repo/hello/hello.sh"

# show content
CatFile "$user_repo/hello/hello.sh"

PrintCmd 'git add hello.sh'
git add "$user_repo/hello/hello.sh"

PrintCmd 'git commit --amend -m "Add author comment and email"'
git commit --amend -m "Add author comment and author email"




# proof
GitLog 1


# ---------------------------------------------------------------------------



PrintTitle "Move it"


# ---------------------------------------------------------------------------


PrintQ 'Did the student successfully move the hello.sh program into a lib/ directory using Git commands?'
# ---------------------------------------------------------------------------

# move the program hello.sh into a lib/
PrintCmd 'mkdir "lib"'
mkdir "$user_repo/hello/lib"

PrintCmd 'git mv "hello.sh" "lib/"'
git mv "$user_repo/hello/hello.sh" "$user_repo/hello/lib/"

tree "$user_repo/hello"


PrintQ 'Did the student commit the move of hello.sh?'
# ---------------------------------------------------------------------------

git commit -m "moved hello.sh to lib/ using Git command"
GitLog 1


PrintQ 'Did the student create and commit a Makefile in the root directory of the repository with the provided content?'
# ---------------------------------------------------------------------------

# create the Makefile at the root of the repository
cat <<EOF>"$user_repo/hello/Makefile"
TARGET="lib/hello.sh"

run:
	bash \${TARGET}
EOF

# show content
CatFile "$user_repo/hello/Makefile"

PrintCmd 'git add Makefile'
git add "$user_repo/hello/Makefile"

PrintCmd 'git commit -m "Added Makefile"'
git commit -m "Added Makefile"


# ---------------------------------------------------------------------------



PrintTitle "blobs, trees and commits"



# ---------------------------------------------------------------------------


PrintQ 'Ask the student to navigate to the .git/ directory and explain to you the purpose of each subdirectory, including objects/, config, refs, and HEAD.'
# ---------------------------------------------------------------------------

PrintCmd 'tree -L 1 .git'
tree -L 1 .git

CatTxt "
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
"


PrintQ 'Was the student able to explain the purpose of each subdirectory, including objects/, config, refs, and HEAD?'
# ---------------------------------------------------------------------------

echo -e "Most likely"


PrintQ 'Did the student successfully find the latest object hash within the .git/objects/ directory using Git commands?'
# ---------------------------------------------------------------------------

PrintCmd 'git log -1 --format="%H"'
LAST_OBJECT="$(git log -1 --format="%H")"
echo -e "$LAST_OBJECT"
# check with `find .git/objects -type f -printf '%T@ %p\n' | sort -n | tail -1`

CatTxt "
git log: shows the commit logs
-1: limits the output to the latest commit
--format="%H": specifies the format to show only the commit hash
"


PrintQ 'Was the student able to print the type and content of this object using Git commands?'
# ---------------------------------------------------------------------------

PrintCmd 'git cat-file -t "$(git log -1 --format="%H")"'
git cat-file -t "$LAST_OBJECT"

PrintCmd 'git cat-file -p "$(git log -1 --format="%H")"'
git cat-file -p "$LAST_OBJECT"

CatTxt "
'-t' type
'-p' content
"


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
# https://github.com/01-edu/public/tree/master/subjects/git#branching


# ---------------------------------------------------------------------------


PrintQ "Did the student successfully create and switch to a new branch named greet?"
# ---------------------------------------------------------------------------

# create and Switch to new branch name greet
PrintCmd "git switch -c greet"
git switch -c greet & pid=$!; wait $pid

PrintCmd "git branch --show-current"
git branch --show-current


PrintQ "Did the student create and commited a new file named greeter.sh in the lib directory with the provided code in it?"
# ---------------------------------------------------------------------------

# create a new file named greeter.sh inside /lib
cat <<EOF>"$user_repo/hello/lib/greeter.sh"
#!/bin/bash

Greeter() {
    who="\$1"
    echo "Hello, \$who"
}
EOF

# show content
CatFile "$user_repo/hello/lib/greeter.sh"

PrintCmd 'git add lib/greeter.sh'
git add "$user_repo/hello/lib/greeter.sh"

PrintCmd 'git commit -m "added greeter.sh"'
git commit -m "added greeter.sh"

GitLog 1


PrintQ "Did the student update the lib/hello.sh file with the provided content, stage, and commit the changes?"
# ---------------------------------------------------------------------------

# update the lib/hello.sh

cat <<EOF>"$user_repo/hello/lib/hello.sh"
#!/bin/bash

source lib/greeter.sh

name="\$1"
if [ -z "\$name" ]; then
    name="World"
fi

Greeter "\$name"
EOF

# show content
CatFile "$user_repo/hello/lib/hello.sh"

PrintCmd 'git add lib/hello.sh'
git add "$user_repo/hello/lib/hello.sh"

PrintCmd 'git commit -m "updated hello.sh"'
git commit -m "updated hello.sh"

GitLog 1


PrintQ "Did the student update the Makefile with the comment, stage, and commit the changes?"
# ---------------------------------------------------------------------------

sed -i "s/TARGET=\"lib\/hello.sh\"/# Ensure it runs the updated lib\/hello.sh file\\nTARGET=\"lib\/hello.sh\"/" "$user_repo/hello/Makefile"

# show content
CatFile "$user_repo/hello/Makefile"

PrintCmd 'git add Makefile'
git add "$user_repo/hello/Makefile"

PrintCmd 'git commit -m "updated Makefile"'
git commit -m "updated Makefile"

GitLog 1


PrintQ "Was the student able to compare and show the differences between the main and greet branches for the Makefile, hello.sh, and greeter.sh files?"
# ---------------------------------------------------------------------------

# ! Switch back to the main branch [link](https://github.com/01-edu/public/tree/master/subjects/git#branching)
# > Switch back to the main branch, compare and show the differences between the main and greet branches for Makefile, hello.sh, and greeter.sh files.
PrintCmd "git switch $primary_branch"
git switch $primary_branch

PrintCmd 'git diff greet..main -- "Makefile" "lib/hello.sh" "lib/greeter.sh"'
git diff greet..main -- "$user_repo/hello/Makefile" "$user_repo/hello/lib/hello.sh" "$user_repo/hello/lib/greeter.sh"


PrintQ "Did the student generate a README.md file with the provided content and commit it?"
# ---------------------------------------------------------------------------

echo "This is the Hello World example from the git project." > "$user_repo/hello/README.md"

# show content
CatFile "$user_repo/hello/README.md"

PrintCmd 'git add README.md'
git add "$user_repo/hello/README.md"

PrintCmd 'git commit -m "added README"'
git commit -m "added README"

GitLog 1


PrintQ "Did the student draw a commit tree diagram illustrating the diverging changes between all branches to demonstrate the branch history?"
# ---------------------------------------------------------------------------

PrintCmd "git log --graph --all --decorate --oneline"
git log --graph --all --decorate --oneline


# ---------------------------------------------------------------------------



PrintTitle "Conflicts, merging and rebasing"



# ---------------------------------------------------------------------------


PrintQ "Did the student successfully merge the changes from the main branch into the greet branch?"
# ---------------------------------------------------------------------------

# ! generate and store Before_merge hash <------------------------------------------------------------------<<<
# ? generate and store Before_merge hash <------------------------------------------------------------------<<<
before_merge=$(git log --pretty=format:"%H" -1)
# ! generate and store Before_merge hash <------------------------------------------------------------------<<<
# switch to the greet branch
PrintCmd "git switch greet"
git switch greet

# merge the <primary_branch> branch into the greet branch
PrintCmd "git merge --no-edit $primary_branch"
git merge --no-edit $primary_branch

PrintCmd "git log --graph --all --decorate --oneline"
git log --graph --all --decorate --oneline


PrintQ "Did the student make the specified changes to the hello.sh file in the main branch and commit them?"
# ---------------------------------------------------------------------------

# ! switch to the <primary_branch> branch [link](https://github.com/01-edu/public/tree/master/subjects/git#conflicts-merging-and-rebasing)
# > Switch to main branch and make the changes below to the hello.sh file, save and commit the changes.
PrintCmd "git switch $primary_branch"
git switch $primary_branch

# make changes to hello.sh
cat <<EOF>"$user_repo/hello/lib/hello.sh"
#!/bin/bash

echo "What's your name"
read my_name

echo "Hello, \$my_name"
EOF

# show content
CatFile "$user_repo/hello/lib/hello.sh"

PrintCmd 'git add lib/hello.sh'
git add "$user_repo/hello/lib/hello.sh"

PrintCmd 'git commit -m "modified lib/hello.sh"'
git commit -m "modified lib/hello.sh"

GitLog 1

PrintQ "Did the student attempt to merge the main branch into the greet branch creating a conflict during the merge?"
# ---------------------------------------------------------------------------

# Attempt to merge the main branch into greet. Bingooo! There you have it, a conflict.

# switch to the greet branch
PrintCmd "git switch greet"
git switch greet


# merge the <primary_branch> branch into the greet branch
PrintCmd "git merge --no-edit $primary_branch"
git merge --no-edit $primary_branch

# ! BOOM Conflict!!! <------------------------------------------------------------------<<<
echo -e "\n$BG_RED$EXPND""CONFLICT""$RST"
# ! BOOM Conflict!!! <------------------------------------------------------------------<<<

PrintQ "Did the student successfully resolve the conflict, accepting changes from the main branch?"
# ---------------------------------------------------------------------------

PrintCmd 'git checkout --theirs "lib/hello.sh"'
git checkout --theirs "$user_repo/hello/lib/hello.sh"

echo -e "\nYes, by accepting the incoming changes from $primary_branch, as requested, with the cmd 'git checkout --theirs <filename>'"


PrintQ "Did the student commit the conflict resolution changes?"
# ---------------------------------------------------------------------------

PrintCmd 'git add lib/hello.sh'
git add "$user_repo/hello/lib/hello.sh"

PrintCmd 'git commit -m "resolving conflict by accepting incoming changes"'
git commit -m "resolving conflict by accepting incoming changes from the $primary_branch branch"

PrintCmd "git status"
git status

# check
GitLog 2

PrintQ "Did the student return to the point before the initial merge between main and greet?"
# ---------------------------------------------------------------------------

PrintCmd "git reset --hard $before_merge"
git reset --hard $before_merge

PrintQ "Did the student rebase the greet branch on top of the latest changes in the main branch?"
# ---------------------------------------------------------------------------

# note, already on greet
PrintCmd "git rebase $primary_branch greet"
git rebase $primary_branch greet

PrintCmd "git checkout $primary_branch"
git checkout $primary_branch

PrintQ "Did the student successfully merge the changes from the greet branch into the main branch?"
# ---------------------------------------------------------------------------

# PrintCmd 'git add lib/hello.sh lib/greeter.sh'
# git add "$user_repo/hello/lib/hello.sh" "$user_repo/hello/lib/greeter.sh"

# PrintCmd 'git commit --amend --no-edit'
# git commit --amend --no-edit

PrintCmd "git status"
git status

# PrintCmd "git rebase --continue"
# git rebase --continue


CatTxt "
- Fast-forwarding is a specific type of merging that happens when the history allows for a simple extension without a new merge commit.

- Merging is the general concept of integrating changes, potentially creating a new merge commit or requiring conflict resolution.
- Rebasing is a powerful tool for manipulating history but should be used with caution, especially in collaborative workflows.
"


PrintQ "Ask the student to explain the difference between merging and rebasing and if he understand Fast-Forwarding."
# ---------------------------------------------------------------------------

echo -e "yes"


PrintQ "Did the student demonstrate an understanding of fast-forwarding?"
# ---------------------------------------------------------------------------

echo -e "yes"


PrintQ "was the student able to explain the difference between merging and rebasing?"
# ---------------------------------------------------------------------------

echo -e "yes"


# ---------------------------------------------------------------------------



PrintTitle "Local & Remote Repositories"



# ---------------------------------------------------------------------------


PrintQ "Did the student complete the cloning process of the hello repository to cloned_hello?"
# ---------------------------------------------------------------------------

# In the work/ directory, make a clone of the repository hello as cloned_hello. (Do not use copy command)
cd "$user_repo" || return

PrintCmd git clone hello cloned_hello
git clone "$user_repo/hello" "$user_repo/cloned_hello" && cd "$user_repo/cloned_hello" || return


PrintQ "Did the student fetch and merge changes from the remote repository into the main branch?"
# ---------------------------------------------------------------------------

cd "$user_repo/hello" || return

# Make changes to the original repository, update the README.md file with the provided content, and commit the changes.
sed -i "s/This is the Hello World example from the git project./This is the Hello World example from the git project.\\n(changed in the original)/" "$user_repo/hello/README.md"

# show README.md
CatFile "$user_repo/hello/README.md"

# add README.md
PrintCmd "git add README.md"
git add README.md

# commit
PrintCmd "git commit -m 'modified comment'"
git commit -m "modified comment"

# change directory
cd "$user_repo/cloned_hello" || return

# fetch the changes from the remote
PrintCmd "git fetch"
git fetch

# merge the changes
PrintCmd "git merge origin/$primary_branch"
git merge origin/$primary_branch

# Show the logs for the cloned repository.
PrintCmd "git log --all --oneline"
git log --all --oneline

PrintQ "Did the student list both remote and local branches, make changes to the original repository, and synchronize the cloned repository with remote changes?"
# ---------------------------------------------------------------------------

# List all remote and local branches in the cloned_hello repository.
PrintCmd "git branch -a -v"
git branch -a -v


PrintQ "Did the student successfully clone the hello repository into the work/ directory as cloned_hello, without using the copy command?"
# ---------------------------------------------------------------------------

echo -e "Yes, by using \`git clone \"hello\" \"cloned_hello\"\`"


PrintQ "Did the student show the logs for the cloned_hello repository?"
# ---------------------------------------------------------------------------

# change directory
cd "$user_repo/cloned_hello" || return

PrintCmd "git log --all --oneline"
git log --all --oneline


PrintQ "Did the student display the name of the remote repository (origin) and provide more information about it?"
# ---------------------------------------------------------------------------

# Display the name of the remote repository and provide more information about it.
PrintCmd "git remote -v"
git remote -v


PrintQ "Did the student list all remote and local branches in the cloned_hello repository?"
# ---------------------------------------------------------------------------

PrintCmd "git branch -a -v"
git branch -a -v


PrintQ "Did the student make changes to the original repository, update the README.md file with the provided content, and commit the changes?"
# ---------------------------------------------------------------------------

echo -e "Yes, see above"


PrintQ "Inside the cloned repository (cloned_hello), did the student fetch the changes from the remote repository and display the logs, ensuring commits from the hello repository are included?"
# ---------------------------------------------------------------------------

echo -e "Yes, see above"


PrintQ "Did the student merge the changes from the remote main branch into the local main branch?"
# ---------------------------------------------------------------------------

echo -e "Yes, see above"


PrintQ "Did the student add a local branch named greet tracking the remote origin/greet branch?"
# ---------------------------------------------------------------------------

PrintCmd "git checkout -b greet"
git checkout -b greet

PrintCmd "git remote add -t greet hello ~/dev/git/work/hello"
git remote add -t greet hello ~/dev/git/work/hello


PrintQ "Did the student add a remote reference to their Git repository?"
# ---------------------------------------------------------------------------

PrintCmd "git remote set-url origin \"$remote_url\""
git remote set-url origin $remote_url


PrintQ "Did the student push the main and greet branches to the remote repository?"
# ---------------------------------------------------------------------------

# do you want to execute the full script, even the remote part
# printf "\n$DIM%s$YELLOW%s$RST\n\n" "command: " "$1"
if [ $full_script == 0 ]; then
  echo -e "TEST MODE:\nnothing is sent to the remote repository ($remote_url)"
  # echo -e "$BG_HIGHLIGHT""sudo rm -r $user_repo""$RST"
  # exit 1
else
  # echo -e "PRODUCTION MODE"
  DebugHere # debug here
  PrintCmd "git push -u --all origin"
  git push -u --all origin
fi

echo -e "Opening now the remote repository, please check the result."

xdg-open https://zone01normandie.org/git/ngenty/git_test.git

# PAUSE, resume the script after opening the repo in the browser
read -p "Press any key to resume ..."


PrintQ "What is the single git command equivalent to what you did before to bring changes from remote to local main branch?"
# ---------------------------------------------------------------------------

PrintCmd "git pull origin main/master"

echo -e "
git fetch origin
git merge origin/main
"


PrintQ "Did the student provide an accurate response?"
# ---------------------------------------------------------------------------

echo -e "Yes"


# ---------------------------------------------------------------------------



PrintTitle "Bare Repositories"



# ---------------------------------------------------------------------------


PrintQ "What is a bare repository and why is it needed?"
# ---------------------------------------------------------------------------

echo -e "
A bare repository in Git is essentially a repository stripped down to its core functionality - version control history.  
Unlike a regular repository you use for local development, a bare repository doesn't contain a working directory with the actual files you edit.  
It only holds the internal data structures that track changes and history, typically stored in a hidden folder named .git.
"


PrintQ "Did the student correctly explain what a bare repository is and why it is needed?"
# ---------------------------------------------------------------------------

echo -e "Yes, read above the answer"


PrintQ "Did the student successfully create a bare repository named hello.git from the existing hello repository?"
# ---------------------------------------------------------------------------

cd "$user_repo" || return
# Create a bare repository named hello.git from the existing hello repository.
PrintCmd "git clone --bare hello hello.git"
git clone --bare hello hello.git


PrintQ "Did the student add the bare hello.git repository as a remote to the original repository hello?"
# ---------------------------------------------------------------------------

# change directory
cd "$user_repo/hello" || return
# Add the bare hello.git repository as a remote to the original repository hello.

PrintCmd "git remote add bare \"$user_repo/hello.git\""
git remote add bare "$user_repo/hello.git"


PrintQ "Did the student change the README.md file in the original repository, commit the change, and push it to the shared repository?"
# ---------------------------------------------------------------------------

# Change the README.md file in the original repository with the provided content
sed -i "s/This is the Hello World example from the git project./This is the Hello World example from the git project.\\n(Changed in the original and pushed to shared)/" "$user_repo/hello/README.md"

CatFile "$user_repo/hello/README.md"

# Commit the changes...
git add "$user_repo/hello/README.md"
git commit -m "added comment"

CatFile "$user_repo/hello/README.md"

PrintCmd "git push bare --mirror"
git push bare --mirror

GitLog 1


PrintQ "Did the student switch to the cloned repository cloned_hello and successfully pull down the changes just pushed to the shared repository?"
# ---------------------------------------------------------------------------

# change directory
PrintCmd "cd $user_repo/cloned_hello"
cd "$user_repo/cloned_hello" || return

PrintCmd "git pull hello HEAD"
git pull hello HEAD

echo -e "Yes"

PrintEnd

# this git audit was a nightmare :P

