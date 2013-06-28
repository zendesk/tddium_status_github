module TddiumStatusGithub
  module_function

  def url
    "https://api.tddium.com/1/reports/#{session}"
  end

  def sha
    `git rev-parse HEAD`.strip
  end

  def session
    ENV['TDDIUM_SESSION_ID']
  end

  def token
    ENV['GITHUB_TOKEN']
  end

  def github
    @github ||= Github.new(:oauth_token => token)
  end

  def remote
    url = `git config --get remote.ci-origin.url`.strip
    url =~ /.*[:\/](.*\/[^\.]*)/ && $1.split("/")
  end
end

dir = File.join(File.expand_path(File.dirname(__FILE__)), "tasks")

Dir.glob(File.join(dir, "*.rake")).each do |task|
  load task
end
