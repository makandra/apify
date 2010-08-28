require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'

desc 'Default: Run all specs.'
task :default => :spec

desc "Run all specs"
Spec::Rake::SpecTask.new() do |t|
  t.spec_opts = ['--options', "\"spec/spec.opts\""]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc 'Generate documentation for the apify gem.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'apify'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "apify"
    gemspec.summary = "Compact definition of JSON APIs for Rails applications. "
    gemspec.email = "github@makandra.de"
    gemspec.homepage = "http://github.com/makandra/apify"
    gemspec.description = "Compact definition of JSON APIs for Rails applications. "
    gemspec.authors = ["Henning Koch"]
    gemspec.add_dependency 'json'
    gemspec.add_dependency 'jsonschema'
    gemspec.add_dependency 'rest-client'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

