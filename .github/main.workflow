workflow "Build and Publish" {
  on = "push"
  resolves = "Release"
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

action "Docker Login" {
  needs = ["Test", "Lint"]
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}


action "Build" {
  needs = ["Docker Login"]
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "build"
}

action "Publish Filter" {
  needs = ["Build"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Publish" {
  needs = ["Publish Filter"]
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "publish"
}

action "Release" {
  needs = ["Publish"]
  uses = "docker://github/ghx:master"
  runs = "sh -c"
  args = ["ghx release create --tag v`grep VERSION make/Makefile | cut -d \"=\" -f 2` make/build/*.tar.gz"]
  secrets = ["GITHUB_TOKEN"]
}
