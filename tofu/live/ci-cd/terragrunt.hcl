terraform {
  source = "../..//modules/ci-cd"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  # TODO: fill in your GitHub username
  github_owner = "LinkedInLearning"

  # TODO: fill in your GitHub user ID (NOT the same as your username). You can get this from the GitHub API, or by
  # opening the repo in your browser, doing View Source, and grabbing the 'content' value of the
  # 'octolytics-dimension-user_id' meta tag. This is required for all repos created after July 15, 2026. Set to null
  # only for repos created before that date.
  github_owner_id = "28577987"

  # TODO: fill in your repo name (probably the same if you forked the course repo)
  github_repo = "devops_foundations_day_2_7773006"

  # TODO: fill in your GitHub repo ID. You can get this from the GitHub API, or by opening the repo in your browser,
  # doing View Source, and grabbing the 'content' value of the 'octolytics-dimension-repository_id' meta tag. This is
  # required for all repos created after July 15, 2026. Set to null only for repos created before that date.
  github_repo_id = "1333603985"
}