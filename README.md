# Git

<!-- for Joplin users -->
<!-- ${toc} -->

## Usage

Clone the repo and launch the script with 

```sh
clone https://github.com/nicgen/git_audit_z01P24.git
cd git_audit_z01P24
bash git.sh
```

Fill the prompts and voilà!

Notes:
- the prompt for the path will create the directories for you (create the work dir)
- all the entries are prompted but there are also some options that you can de/activate:
  - primary_branch: main vs master ([reason](https://www.zdnet.com/article/github-to-replace-master-with-main-starting-next-month/))
  - markdown: do you want to export a markdown file?

To export the markdown

```sh
bash git.sh > filename.md
```

- full_script: do you want to fully execute the script, even the remote part?
- for testing purpose you can inject a .env file:

```txt file=.env
user_repo=<user repo>
code_launch=<code editor>
remote_url=<remote url>
user_name=<name>
user_email=<email>
```


## Links

> Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.

- [website](https://git-scm.com/)
- [docs](https://git-scm.com/docs/git)
- [download](https://git-scm.com/downloads)

## Lexical for git

- [gitglossary - A Git Glossary](https://git-scm.com/docs/gitglossary)

### Staging concept:

- **Making Changes**: You edit your files in your working directory using your preferred text editor or IDE. These changes exist locally on your machine but haven't been registered with Git yet.
- **Staging Changes**: Once you're satisfied with your edits, you use the git add command to add specific files or changes to the staging area. This tells Git that you want to include these modifications in the next commit.
- **Committing Changes**: Finally, you use the git commit command to create a new commit object. This commit captures the staged changes, along with a commit message you provide summarizing the modifications. The actual content of the files is stored in Git's database (.git/objects directory).

Benefits of Staging:

- **Selectivity**: You can stage specific files or changes within a file instead of committing everything at once. This allows for granular control over what goes into each commit.
- **Review**: The staged changes act as a temporary holding area before - committing. You can review the staged changes using git status and make adjustments before finalizing the commit.
- **Partial Commits**: Staging allows you to create multiple commits for a complex set of changes, improving the clarity and organization of your commit history.

<!-- ### Rebasing

> Rebasing in Git is a powerful tool that allows you to rewrite your commit history by rearranging, combining, or editing existing commits. It's like reorganizing your project's history to create a cleaner and more linear progression.

Core Concept:

- Imagine your commit history as a linked list, where each commit points to its parent commit.
- Rebasing takes a series of commits (usually a branch) and replays them on top of a different base commit.
- This creates a new linear history, potentially removing or modifying the original commits. -->

### Fast-Forwarding

> Fast-forwarding is a specific type of merge operation in Git. It happens when you integrate changes from one branch into another without creating a new merge commit. Here's why it occurs:

Imagine your commit history as a linked list, where each commit points to its parent commit.
When merging two branches, Git typically creates a new commit that points to the two branches being merged. This creates a branching point in the history.
However, in a fast-forward, there are no new commits on the branch you're merging into (usually the main branch).
So, Git simply extends the existing branch pointer (HEAD) to point to the commit from the branch you're merging from. This "fast-forwards" the history without creating a new merge commit.

### Merging

> Merging is a broader concept in Git that involves integrating changes from one branch into another. It can happen with or without a fast-forward. Here's the general process:

Identify the branch containing the changes you want to integrate (e.g., feature branch).
Use the git merge command with the branch name.
Git analyzes the history of both branches and attempts to combine the changes.
If there are no conflicts (changes in the same part of the code from both branches), Git creates a new merge commit that points to the two branches being merged. This becomes a branching point in the history.
If there are conflicts, Git pauses the merge process and highlights the conflicting sections. You need to manually resolve these conflicts and then commit the resolved changes.

### Rebasing

> Rebasing is a powerful but potentially complex operation that rewrites your Git history. It involves taking a series of commits (usually a branch) and replaying them on top of a different base commit. Here's what happens:

You identify the commits to rebase (often a branch).
You use the git rebase command with the base commit specified.
Git essentially detaches the commits from their original branch and replays them one by one on top of the new base commit.
This creates a new linear history, potentially removing or modifying the original commits.
During the rebase, if there are conflicts (similar to merging), you need to resolve them manually.

### Key Differences

Feature	| Merging | Rebasing
-|-|-
History | Creates a new merge commit (usually) | Rewrites history
Use Case | Integrating changes, resolving conflicts | Reorganizing commits, squashing small commits
Impact on Others | May cause issues if already shared | Can cause issues if already shared (more likely)
Complexity | Simpler | More complex (requires conflict resolution)

### TL;DR

- **Fast-forwarding** is a specific type of merging that happens when the history allows for a simple extension without a new merge commit.
- **Merging** is the general concept of integrating changes, potentially creating a new merge commit or requiring conflict resolution.
- **Rebasing** is a powerful tool for manipulating history but should be used with caution, especially in collaborative workflows.

## Setting Up Git

```sh
apt-get install git
```

Verify if git is correctly installed

```sh
git --version
```

### Configuration

```sh
git config --global init.defaultBranch main
git config --global user.name <user name>
git config --global user.email <user email>
```

#### Store Credential

```sh
git config --global credential.helper store
```

Warning: the storage format is a .git-credentials file, stored in **plaintext**. Use an SSH key for your accounts instead (not allowed on gitea Zone01)

### Git commits to commit

> Within the work directory, establish a subdirectory named hello. Inside this directory, generate a file titled hello.sh and input the following content:

```sh
mkdir "hello" && cd $_
echo 'echo "Hello, World"' > hello.sh
```

Initialize the git repository in the hello directory.

```sh
git init
```

```sh
# add a file
git add <filename>
# commit a change
git commit -m "<commit_msg>"
# check the working tree
git status
```

## History

Show the history of the working directory.

```sh
git log
```

Show One-Line History for a condensed view showing only commit hashes and messages.

```sh
git log --oneline
# alt
git log --pretty=oneline
```

Controlled Entries:

display the last 2 entries

```sh
git log -2
```

display commits made within the last 5 minutes

```sh
git log --since=5.minutes
```

Personalized Format:

including the commit hash, date, message, branch information, and author name, resembling * e4e3645 2023-06-10 | Added a comment (HEAD -> main) [John Doe]

```sh
git log --pretty=format:"%h %ad | %s%d [%an]" --date=short
```

## Check it out

Restore First Snapshot

```sh
git checkout <first-commit-hash> hello.sh
# read the file
cat hello.sh
```

Restore Second Recent Snapshot

```sh
# detached HEAD state, you have to return to main
git checkout main
git checkout <second-commit-hash> hello.sh
# alt.
# go back one commit from the HEAD
git checkout HEAD~1 hello.sh
# print the content of the hello.sh
cat hello.sh
```

Return to Latest Version

```sh
git checkout main
# alternative
git checkout -
cat hello.sh
```

## TAG me

Referencing Current Version

```sh
# To create a lightweight tag named "v1" on your current commit
git tag v1
```

Tagging Previous Version

```sh
git tag v1-beta HEAD^
# This creates a lightweight tag named v1-beta pointing to the commit immediately before the current one.
# Note: HEAD^^^ for three commits back, and so on. Alternatively, you can use HEAD~2, HEAD~3
```

Navigating Tagged Versions

```sh
git checkout v1
git checkout v1-beta
# These commands will put you in a "detached HEAD" state at the commit where the tag points. You can look at the files, run tests, or even create new commits from this stategit checkout v1-beta
```

Listing Tags

```sh
git tag
```

## Change your mind?

Reverting Changes

```sh
git checkout -- hello.sh
# If you want to revert all unstaged changes in the working directory:
git checkout -- .
```

Staging and Cleaning

> Staging: `git add` command to add specific files or changes to the staging area. This tells Git that you want to include these modifications in the next commit.

```sh
# Unstage the changes for a specific file:
git reset HEAD hello.sh
git checkout -- hello.sh
```

Committing and Reverting

> Commit: captures the staged changes, along with a commit message you provide summarizing the modifications. The actual content of the files is stored in Git's database.

```sh
# You added the file and commit
# Revert the commit
git revert --no-edit HEAD
```

Tagging and Removing Commits

```sh
git tag oops
```

Displaying Logs with Deleted Commits (focusing on the commit tagged oops)

```sh
# display all logs
git log --all
# in one line emphasis on the deleted commit
git log --all --oneline --grep="revert"
```

Cleaning Unreferenced Commits

```sh
git reflog expire --expire-unreachable=now --all
git gc --prune=now --aggressive
```

> Reflog: A **reflog** shows the local "history" of a ref. In other words, it can tell you what the 3rd last revision in this repository was, and what was the current state in this repository. [official doc](https://git-scm.com/docs/gitglossary#Documentation/gitglossary.txt-aiddefreflogareflog)


## Move it

```sh
git mv <file> <folder/>
```


## blobs, trees and commits

### Exploring .git/ Directory

file/folder | description
-|-
**branches**        | folder, contains information about remote branches (deprecated)
**COMMIT_EDITMSG**  | file that contains the commit message of the most recent commit
**config**          | configuration file for the repository, containing settings such as remote repositories, branch information, and user identity
**description**     | file (plain-text) containing a description of the repository
**HEAD**            | file that points to the current branch reference, typically refs/heads/main
**hooks**           | folder, contains client or server side scripts that Git executes before or after certain operations, like committing or merging
**index**           | file, staging area (or cache), where changes are stored before they are committed
**info**            | folder, contains global exclude patterns for the repository (in the exclude file)
**logs**            | folder, stores logs for the reflog, which keeps track of updates to the tips of branches and other references
**objects**         | folder, stores all the content (blobs, trees, and commits) as binary files
**ORIG_HEAD**       | file that records the original reference of HEAD before a potentially dangerous operation, such as a merge or a reset
**packedrefs**      | file that stores a packed version of all references
**refs**            | folder, contains references to commit objects. This includes heads (branches), tags, and remote-tracking branches

### Latest Object Hash

- latest object hash

```sh
git rev-parse HEAD
```

- print the type

```sh
git cat-file -t "$object"
```

- print the content

```sh
git cat-file -p "$object"
```

### Dumping Directory Tree

- dump the directory tree

```sh
git ls-tree HEAD
git ls-tree HEAD:lib
```

## Branching


### Create and Switch to New Branch

- Create a local branch named greet and switch to it.

```sh
git switch -c <new_branch> [<start point>]
```

> note: `-c` this option stands for "create" and tells Git to create a new branch if it doesn’t already exist

```sh
# Switch back to the main branch
git switch master
# note, `git checkout` is for the older version of git
# compare and show the differences between the main and greet branches for Makefile, hello.sh, and greeter.sh files
git diff master..greet -- Makefile lib/hello.sh lib/greeter.sh
```

`git diff main..greet` compares the main branch with the greet branch  
`--` indicates the end of the options and the beginning of the file list  
`Makefile hello.sh greeter.sh` specifies the files you want to compare  

- Draw a commit tree diagram illustrating the diverging changes between all branches to demonstrate the branch history.

```sh
git log --graph --all --decorate --oneline
```

`log` Shows the commit logs.  
`--graph`Draw a text-based graphical representation of the commit history on the left hand side of the output
`--all`Pretend as if all the refs in `refs/`, along with HEAD, are listed on the command line as `<commit>`
`--decorate` decorate options  
`--oneline` This is designed to be as compact as possible.  


## Conflicts, merging and rebasing

### Merge Main into Greet Branch

Automatic resolve

```sh
git merge -X theirs  $primary_branch
# also 
# git checkout --theirs <filename>
```

```sh
# 
git checkout greet
# 
git merge --no-edit master
# switch to main/master branch
git checkout master
```

### Rebasing Greet Branch


```sh
# go back to the point before the initial merge between main/master and greet
git checkout <hash>
git rebase master
# HEAD is now detached, going back to main
git checkout master
```

`git checkout <hash>`

This command checks out a specific commit identified by its unique hash. This detaches your HEAD from any current branch and points it directly to that commit.

`git rebase master`

This performs a rebase operation. Rebasing replays your commits on top of the specified branch (master in this case). This essentially rewrites your branch history by integrating your changes on top of the latest state of master.

Note: There can be potential conflicts during the rebase if your commits overlap with changes already present in master. You'll need to manually resolve these conflicts before the rebase can be completed.

`git checkout master`

After a successful rebase, you might want to switch back to the master branch itself. This command simply checks out the master branch, assuming it still exists.

### Understanding Fast-Forwarding and Differences

**Fast-forwarding** is a specific type of merging that happens when the history allows for a simple extension without a new merge commit.  
**Merging** is the general concept of integrating changes, potentially creating a new merge commit or requiring conflict resolution.  
**Rebasing** is a powerful tool for manipulating history but should be used with caution, especially in collaborative workflows.  

## Local and remote repositories

- In the work/ directory, make a clone of the repository hello as cloned_hello. (Do not use copy command)

```sh
git clone hello cloned_hello
```

- Display the name of the remote repository and provide more information about it

```sh
git remote -v
```

- List all remote and local branches in the cloned_hello repository.

```sh
git branch -a -v
```

- fetch the changes from the remote repository

```sh
git fetch --all
```

### "What is the single git command equivalent to what you did before to bring changes from remote to local main branch?"

```sh
git pull origin main/master
```

## Bare repositories

- What is a bare repository and why is it needed?

A bare repository in Git is essentially a repository stripped down to its core functionality - version control history.  
Unlike a regular repository you use for local development, a bare repository doesn't contain a working directory with the actual files you edit.  
It only holds the internal data structures that track changes and history, typically stored in a hidden folder named .git.

- Create a bare repository named hello.git from the existing hello repository.

```sh
git clone --bare hello hello.git
```
