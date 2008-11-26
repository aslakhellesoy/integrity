require File.dirname(__FILE__) + "/lib/integrity"
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

task :default => ["spec:coverage", "spec:coverage:verify"]

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ["--color", "--format", "progress"]
  t.spec_files = Dir['spec/**/*_spec.rb'].sort
  t.libs = ['lib']
  t.rcov = false
end

namespace :spec do
  Spec::Rake::SpecTask.new(:coverage) do |t|
    t.spec_opts = ["--color", "--format", "progress"]
    t.spec_files = Dir['spec/**/*_spec.rb'].sort
    t.libs = ['lib']
    t.rcov = true
    t.rcov_opts = ['--exclude-only', '".*"', '--include-file', '^lib']
  end

  namespace :coverage do
    RCov::VerifyTask.new(:verify) do |t|
      t.threshold = 100
      t.index_html = "coverage" / 'index.html'
    end
  end
end

namespace :db do
  desc "Setup connection."
  task :connect do
    config = File.expand_path(ENV['CONFIG']) if ENV['CONFIG']
    config = Integrity.root / 'config.yml' if File.exists?(Integrity.root / 'config.yml')
    Integrity.new(config)
  end

  desc "Automigrate the database"
  task :migrate => :connect do
    require "project"
    require "build"
    require "notifier"
    DataMapper.auto_migrate!
  end
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    files  = `git ls-files`.split("\n").reject {|f| f =~ %r(^spec) || f =~ %r(^vendor/rspec) || f =~ /^\.git/ } 
    files += %w(spec/spec_helper.rb spec/form_field_matchers.rb)

    s.name                 = 'integrity'
    s.summary              = 'The easy and fun Continuous Integration server'
    s.description          = 'Your Friendly Continuous Integration server. Easy, fun and painless!'
    s.homepage             = 'http://integrityapp.com'
    s.rubyforge_project    = 'integrity'
    s.email                = 'contacto@nicolassanguinetti.info'
    s.authors              = ['Nicolás Sanguinetti', 'Simon Rozet']
    s.files                = files
    s.executables          = ['integrity']
    s.post_install_message = 'Run `integrity help` for information on how to setup Integrity.'

    s.add_dependency 'sinatra', ['>= 0.3.2']
    s.add_dependency 'haml' # ah, you evil monkey you
    s.add_dependency 'dm-core', ['>= 0.9.5']
    s.add_dependency 'dm-validations', ['>= 0.9.5']
    s.add_dependency 'dm-types', ['>= 0.9.5']
    s.add_dependency 'dm-timestamps', ['>= 0.9.5']
    s.add_dependency 'dm-aggregates', ['>= 0.9.5']
    s.add_dependency 'data_objects', ['>= 0.9.5']
    s.add_dependency 'do_sqlite3', ['>= 0.9.5']        
    s.add_dependency 'json'
    s.add_dependency 'foca-sinatra-diddies', ['>= 0.0.2']
    s.add_dependency 'rspec_hpricot_matchers'
    s.add_dependency 'thor'
  end
rescue LoadError
end

