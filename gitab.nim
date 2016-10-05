import os

let isGitCode = execShellCmd("git status")

case isGitCode
of 0:
  echo("Current dir is in git repo")
else:
  quit("fatal: Current dir is not in a git repo", 1)
  
if paramCount() == 0:
  quit("Please specify git branch to archive")

let branch = paramStr(1)
echo("Archiving ", branch)

let isBranch = execShellCmd("git rev-parse --verify --quiet " & branch)

case isBranch
of 0:
  echo("Archiving branch " & branch)
else:
  quit("fatal: Branch " & branch & " doesn't exist", 1)

let archiveTag = "archive/" & tailDir(branch)
echo("Tagging as " & archiveTag)

let code = execShellCmd("git tag " & archiveTag & " " & branch)
if code != 0:
  quit("fatal: Tagging failed", 1)
  
if execShellCmd("git push --tags") != 0:
  quit("fatal: Push failed", 1)

let remoteDeleteBranch = ":" & tailDir(branch)
if execShellCmd("git push origin " & remoteDeleteBranch) != 0:
  quit("fatal: Remote branch delete failed", 1)

if execShellCmd("git branch -D " & tailDir(branch)) != 0:
  quit("fatal: Local branch delete failed", 1)