require 'github_api'

namespace :tddium do
  desc "tddium environment pre-run setup task"
  task :pre_hook do
    begin
      github = Github.new(:basic_auth => basic_auth)
      response = github.oauth.create(:scopes => ["repo:status"])

      if response.status == 201
        ENV['GITHUB_TOKEN'] = response.token

        github.repos.statuses.create(*remote, sha,
          :state => "pending",
          :description => session,
          :target_url => url)
      end
    rescue Github::Error::GithubError => e
      STDERR.puts("Caught Github error when updating status: #{e.message}")
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
        github.repos.statuses.create(*remote, sha,
          :state => status,
          :description => session,
          :target_url => url)
      rescue Github::Error::GithubError => e
        STDERR.puts("Caught Github error when updating status: #{e.message}")
      end
    end
  end

  def url
    "https://api.tddium.com/1/reports/#{session}"
  end

  def sha
    `git rev-parse HEAD`.strip
  end

  def basic_auth
    ENV['GITHUB_AUTH']
  end

  def session
    ENV['TDDIUM_SESSION_ID']
  end

  def remote
    url = `git config --get remote.origin.url`
    url =~ /.*[:\/](.*\/[^\.]*)/ && $1.split("/")
  end
end
