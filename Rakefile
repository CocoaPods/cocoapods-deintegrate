require 'bundler/gem_tasks'
require 'bundler/setup'

task default: :spec

task :spec do
  title 'Running Specs'
  files = FileList['spec/**/*_spec.rb'].shuffle.join(' ')
  sh "bundle exec bacon #{files}"

  Rake::Task[:rubocop].invoke
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new do
  title 'Running RuboCop'
end

def title(title)
  cyan_title = "\033[0;36m#{title}\033[0m"
  puts
  puts '-' * 80
  puts cyan_title
  puts '-' * 80
  puts
end
