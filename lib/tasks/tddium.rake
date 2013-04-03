require 'github-api'

namespace :tddium do
  desc "tddium environment pre-run setup task"
  task :pre_hook do
    begin
      github = Github.new(:basic_auth => basic_auth)
      response = github.oauth.create(:scopes => ["repo:status"])

      if response.status == 201
        ENV['GITHUB_TOKEN'] = response.token

        github.repos.statuses.create("zendesk", "zendesk", sha,
          :state => "pending",
          :target_url => url)
      end
    rescue Github::Error::GithubError
    end
  end

  desc "Run post-build script"
  task :post_build_hook do
    token = ENV['GITHUB_TOKEN']

    if token
      github = Github.new(:oauth_token => token)

      status = case ENV['TDDIUM_BUILD_STATUS']
      when "passed"
        "success"
      when "error"
        "error"
      else
        "failure"
      end

      begin
        github.repos.statuses.create("zendesk", "zendesk", sha,
          :state => status,
          :target_url => url)
      rescue Github::Error::GithubError
      end
    end
  end

  def url
    "https://api.tddium.com/1/reports/#{ENV['TDDIUM_SESSION_ID']}"
  end

  def sha
    `git rev-parse HEAD`.strip
  end

  def basic_auth
    ENV['GITHUB_AUTH']
  end
end
