require 'bundler'
require 'rake'
require 'yaml'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new('spec')

namespace :repo do
  desc "push files generated with rakali to remote"
  task :push do

    # Configure git if this is run in Travis CI
    if ENV["TRAVIS"]
      sh "git config --global user.name '#{ENV['GIT_NAME']}'"
      sh "git config --global user.email '#{ENV['GIT_EMAIL']}'"
      sh "git config --global push.default simple"
    end

    # Commit and push to github
    sh "git add --all ."
    sh "git commit -m 'Committing converted files.'"
    sh "git push https://${GH_TOKEN}@github.com/rakali/rakali.rb master > /dev/null"
    puts "Pushed converted files to repo"
  end
end

# default task is running rspec tests
task :default => :spec
