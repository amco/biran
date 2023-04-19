begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Biran'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'bundler/gem_tasks'
require 'rake/testtask'

begin
  require 'rspec/core/rake_task'
  task("spec").clear

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = "--format documentation"
  end

  task default: :spec
rescue LoadError
  raise 'No rspec available'
end
