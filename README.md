[![Board Status](https://dev.azure.com/791445Board/65c04cf0-6a2b-4a0b-a843-579ac06079c1/cd73feb6-f463-414d-be58-13091abcb5cc/_apis/work/boardbadge/2f65c94e-ee12-4359-8b58-f4e3acc88054)](https://dev.azure.com/791445Board/65c04cf0-6a2b-4a0b-a843-579ac06079c1/_boards/board/t/cd73feb6-f463-414d-be58-13091abcb5cc/Microsoft.RequirementCategory)
# Tools for building GitHub Actions

This repository contains actions that can be used to automate the testing, building, and deployment of custom GitHub Actions using workflows.

## Workflows

* [Single Action in a Repository](/single-action.workflow) - Simple GitHub Action that wraps a separate command-line as one Action.
* [Multiple Actions in a Repository](/multi-action.workflow) - Multiple GitHub Actions that expose related, modular actions separated into sub-folder, eg. this repository.

## Makefile

### Adding automatic deployments to your Actions - Multi-Action

1. Download the appropriate tar file from the [releases page](https://github.com/actions/action-builder/releases) and copy it into your repository.
1. Untar the copied file, creating a new set of Makefiles and configuration files in your repository.
1. Copy `action_template.mk` into the sub-folder of each of your actions, and rename it to `Makefile`.
1. For each of your actions, update the new `Makefile` to:
    1. Use the `include` directives for any of the helper files that make sense for your Action.
    1. Set the target depedencies for each of the default targets that make sense for your Action.
    1. Add any additional actions that you would like performed to the target definitions.
    1. If you leave everything for the target blank, it will be skipped, but don't delete it or you will get errors.
1. Optionally: update your Makefile to represent the Docker image name that you would like.  If none is specified the directory name will be used by default.
    1. Add `IMAGE_NAME=<action_name>` to each Action's Makefile. Replace `<action_name` with the name of the image to publish.

## Actions
These have similar functionality to a number of top level actions.  The key differences are that they aggregate some functionality, and include `make`.

### GitHub Action for Shell
Tools for linting and testing shell scripts, as well as linting dockerfiles, using [`makefiles`](https://en.wikipedia.org/wiki/Makefile) and [dockerfile_lint](https://github.com/projectatomic/dockerfile_lint).

#### Usage

An example workflow to run Dockerfile linting and  with Google Cloud Platform and run the gcloud command:

```
workflow "Lint and Test Source" {
  on = "push"
  resolves = ["Test"]
}
 action "Lint" {
  uses = "actions/action-builder/shell@master"
  runs = "make"
  args = "lint"
}
 action "Test" {
  needs = "Lint"
  uses = "actions/action-builder/shell@master"
  runs = "make"
  args = "test"
}
 action "Build" {
  needs = ["Test", "Lint"]
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "build"
}
```

### GitHub Action for Docker
Tools for building, tagging and publishing Docker images.

#### Usage
Sample workflow that tests, builds, and tags a Docker image.

```
workflow "Test and Build Container" {
  on = "push"
  resolves = ["Build"]
}
 action "Lint" {
  uses = "actions/action-builder/shell@master"
  runs = "make"
  args = "lint"
}
 action "Test" {
  uses = "actions/action-builder/shell@master"
  runs = "make"
  args = "test"
}
 action "Build" {
  needs = ["Test", "Lint"]
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "build"
}
```

## License

[MIT](LICENSE). Please see additional information in each subdirectory.
