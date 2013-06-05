require 'rake/testtask'
require_relative 'version'

name = "#{$gem_name}-#{$version}.gem"

rule '.class' => '.java' do |t|
  sh "javac #{t.source}"
end

desc 'default task'
task :default => [:install_gem]

desc 'Makes a Gem'
task :make_gem do
  sh "gem build #{$gem_name}.gemspec"
end

desc 'Install the gem in the standard location'
task :install_gem => [:make_gem] do
  sh "gem install #{$gem_name}-#{$version}-java.gem"
end

desc 'Make documentation'
task :make_doc do
  sh "yard doc lib/*.rb lib/**/*.rb"
end

desc 'Push project to github'
task :push do
  sh "git push origin master"
end

desc 'Push gem to rubygem'
task :push_gem do
  sh "push #{name} -p $http_proxy"
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/complete.rb']
  t.ruby_opts = ["--server", "-Xinvokedynamic.constants=true", "-J-Xmn512m", 
                 "-J-Xms1024m", "-J-Xmx1024m"]
  t.verbose = true
  t.warning = true
end

