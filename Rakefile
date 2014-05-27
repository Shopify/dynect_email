require 'bundler/gem_tasks'
require 'rake/testtask'
require 'bundler'

desc 'Test DynectEmail'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
