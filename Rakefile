require 'bundler/gem_tasks'

task :default => :spec

task :spec do
  title 'Running Specs'
  files = FileList['spec/**/*_spec.rb'].shuffle.join(' ')
  sh "bundle exec bacon #{files}"
end

def title(title)
  cyan_title = "\033[0;36m#{title}\033[0m"
  puts
  puts '-' * 80
  puts cyan_title
  puts '-' * 80
  puts
end

