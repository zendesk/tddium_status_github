require 'rake'
require 'rake/testtask'

require 'bundler/setup'
require 'bundler/gem_tasks'
require 'tddium-status-github'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*.rb']
end

task :default => :test
