# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "tddium-status-github"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steven Davidovitz"]
  s.email       = ["support@zendesk.com"]
  s.homepage    = "https://github.com/steved555/tddium-status-github"
  s.summary     = %q{Updates GitHub commits with their Tddium test status.}
  s.description = %q{Installs pre- and post-build hooks for Tddium that update GitHub commits with the test status.}
  s.license = 'Apache License Version 2.0'

  s.required_ruby_version     = ">= 1.8.7"
  s.required_rubygems_version = ">= 1.3.6"

  s.add_runtime_dependency "github_api"

  s.files              = `git ls-files -x Gemfile.lock`.split("\n") rescue ''
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths      = ["lib"]
end

