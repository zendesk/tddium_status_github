require 'rake'
require 'github_api'

namespace :tddium do
  desc "tddium environment pre-run setup task"
  task :pre_hook do
    if TddiumStatusGithub.token && !TddiumStatusGithub.token.empty?
      begin
        TddiumStatusGithub.github.repos.statuses.create(TddiumStatusGithub.remote[0],
          TddiumStatusGithub.remote[1],
          TddiumStatusGithub.sha,
          :state => "pending",
          :description => "Running build ##{TddiumStatusGithub.session}.",
          :target_url => TddiumStatusGithub.url)
      rescue Github::Error::GithubError => e
        STDERR.puts("Caught Github error when updating status: #{e.message}")
      end
    end
  end

  desc "tddium environment post-build setup task"
  task :post_build_hook do
    if TddiumStatusGithub.token && !TddiumStatusGithub.token.empty?
      case ENV['TDDIUM_BUILD_STATUS']
      when "passed"
        status = "success"
        description = "Build ##{TddiumStatusGithub.session} succeeded!"
      when "error"
        status = "error"
        description = "Build ##{TddiumStatusGithub.session} encountered an error."
      else
        status = "failure"
        description = "Build ##{TddiumStatusGithub.session} failed."
      end

      begin
        TddiumStatusGithub.github.repos.statuses.create(TddiumStatusGithub.remote[0],
          TddiumStatusGithub.remote[1],
          TddiumStatusGithub.sha,
          :state => status,
          :description => description,
          :target_url => TddiumStatusGithub.url)
      rescue Github::Error::GithubError => e
        STDERR.puts("Caught Github error when updating status: #{e.message}")
      end
    end
  end
end
