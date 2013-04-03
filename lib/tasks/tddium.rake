require 'github_api'
require 'tempfile'

namespace :tddium do
  desc "tddium environment pre-run setup task"
  task :pre_hook do
    if (basic_auth && !basic_auth.empty?) && (remote && !remote.empty?)
      begin
        github = Github.new(:basic_auth => basic_auth)
        response = github.oauth.create(:scopes => ["repo:status"])

        if response.status == 201
          File.open(github_token_file, "w+") do |file|
            file << response.token
          end

          github.repos.statuses.create(*remote, sha,
            :state => "pending",
            :description => "Running build ##{session}.",
            :target_url => url)
        end
      rescue Github::Error::GithubError => e
        STDERR.puts("Caught Github error when updating status: #{e.message}")
      end
    end
  end

  desc "tddium environment post-build setup task"
  task :post_build_hook do
    token = File.read(github_token_file)

    if token && !token.empty?
      File.delete(github_token_file)

      github = Github.new(:oauth_token => token)

      case ENV['TDDIUM_BUILD_STATUS']
      when "passed"
        status = "success"
        description = "Build ##{session} succeeded!"
      when "error"
        status = "error"
        description = "Build ##{session} encountered an error."
      else
        status = "failure"
        description = "Build ##{session} failed."
      end

      begin
        github.repos.statuses.create(*remote, sha,
          :state => status,
          :description => description,
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
    url = `git config --get remote.ci-origin.url`
    url =~ /.*[:\/](.*\/[^\.]*)/ && $1.split("/")
  end

  def github_token_file
    File.join(Dir.tmpdir, "github_token")
  end
end
