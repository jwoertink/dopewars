# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "dopewars"
  gem.homepage = "http://github.com/jwoertink/dopewars"
  gem.license = "MIT"
  gem.summary = "Ruby port of Dopewars game"
  gem.description = "Check out the README file for more info"
  gem.email = "jeremywoertink@gmail.com"
  gem.authors = ["Jeremy Woertink"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

# require 'rspec/core'
# require 'rspec/core/rake_task'
# RSpec::Core::RakeTask.new(:spec) do |spec|
#   spec.pattern = FileList['spec/**/*_spec.rb']
# end
# 
# RSpec::Core::RakeTask.new(:rcov) do |spec|
#   spec.pattern = 'spec/**/*_spec.rb'
#   spec.rcov = true
# end
# 
# task :default => :spec
# 
# require 'yard'
# YARD::Rake::YardocTask.new
