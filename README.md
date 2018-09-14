# Persistence API Meta Project

## 1 Introduction
This project is the meta Repository for the Process Engine Persistence Layer.

This guide describes the process for installing and setting up a complete
developer setup.

## 2 Setup and Installation

There are currently two shell scripts that help you to set up the
meta repository and keep it up to date.

### 2.1 setup.sh

This script performs a complete setup, including downloading the repositories,
installing all dependencies, running the build process and setting/resetting
the local database.

### 2.2 reinstall.sh

This is a light-weight alternative to the setup-script.
It performs only the installation and the build process and is therefore better
suited for testing your changes.

## 3 About the Meta Repository

A meta repository combines both advantages of a monolithic and a distributed
repository structure by creating a _meta repository_.

The meta repository contains a clone of all component repos that are used by
the process engine.

Logically, it looks like the whole project is a monolithic repo, but internally
every component is a git repository itself.

So you keep every used component in one place, but also can work independently
on every component.

## 4 Setup Meta

```
npm install -g meta
```

* This will install meta globally and enable you to use meta commands

```
npm install
```

* This will install the NPM dependencies of the meta project
  * These dependencies can also include meta plugins

## 5 Repository Management

### 5.1 Clone modules of the meta project

```
meta git update
```

* This will clone all modules into the folder of the meta project

### 5.2 Add an existing module to the meta project

```
meta project add PROJECT_NAME PROJECT_GITHUB_PATH
```

* This will create an entry in the `.meta`-file located in the root directory
of the meta project.
* `PROJECT_NAME` should be the name used in the package.json
* `PROJECT_GITHUB_PATH` should be the ssh link copied to clone the repository

### 6.3 Execute a command in **all** repositories

```
meta exec "any command"
```

* If the command contains spaces, make sure to wrap it in quotes

### 5.4 Execute a command in **some** repositories

```
meta exec "any command" --exclude correlations.repository.sequelize,logging.repositroy.file_system
meta exec "any command" --include-only correlations.repository.sequelize,logging.repositroy.file_system
```

* Arguments for `--exclude` and `--include-only` are separated by commas
* A command run with `--exclude` will be executed in every module specified
in the `.meta`-file, excluding the given arguments
* A command run with `--include-only` will only be executed in modules
contained in the argument list - modules specified in the `.meta`-file will
not be included

## 6 Project Workflow

### 6.1 Clean all repositories

```
meta git clean -fd
```

* removes **all** untracked changes
* e.g.: to remove all `node_modules` folders

### 6.2 Update all repositories

```
meta exec "git checkout develop"
meta exec "git pull"
```

* First checkout the `develop` branch so that every repository is on the same
branch
  * If you got unsaved work on any repository that is not on the `develop` branch
  you will see an error that you have to manually fix
* Then pull the `develop` branch to fetch possible updates
  * If you got unsaved work on a repository that already was on the `develop`
  branch you will see an error that you have to manually fix

### 6.3 Install NPM dependencies

Although the meta NPM plugin provides a shortcut to install the `node_modules`
for every package this involves a lot of overhead, because it starts fresh in
every package and executes `npm install` in it.

A better way to achieve this is by sharing the same node_modules in multiple
packages wherever it is possible.

We can do this by using the tool `minstall`:

* To run minstall just execute `npm install` in the root folder of the meta
project
  * The package folders should already exist at this time (see `3.1`)


This is the meta way:

```
meta npm install
```

* BE CAREFUL: this can take a long time
* Runs npm install in each module specified in the `.meta`-file individually

### 6.4 Local Setup (linking local modules)

```
meta npm link --all
```

* Links all modules specified in the `.meta`-file if they are a dependency to
another module specified in the `.meta`-file

### 6.5 Initialize git flow on all repositories

```
meta exec "git checkout master"
meta exec "git flow init"
```

* First checkout the `master` branch so that every repository is on the same
branch
  * This will enable you to use the git flow default branch names and just hit
  `Enter` during initilization
* Then `git flow init` will be run in each repository individually

### 6.6 Start a feature on multiple repositories

```
meta exec "git flow feature start my_feature" --include-only correlations.repository.sequelize,logging.repositroy.file_system
```

* Starts the feature "my_feature" in the modules
`correlations.repository.sequelize` and `logging.repositroy.file_system`

### 6.7 Publish a feature on multiple repositories

```
meta exec "git flow feature publish my_feature" --include-only correlations.repository.sequelize,logging.repositroy.file_system
```

* Publishes the feature "my_feature" in the modules
`correlations.repository.sequelize` and `logging.repositroy.file_system`

### 6.8 List the git status on all repositories

```
meta git status
```

* Runs `git status` in each module specified in the `.meta`-file individually

### 6.9 Push the changed on all repositories

```
meta git push
```

* Runs `git push` in each module specified in the `.meta`-file individually

