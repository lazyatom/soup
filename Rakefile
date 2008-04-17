require 'rubygems'

require 'lib/soup'

begin
  require 'echoe'

  Echoe.new("soup", Soup::VERSION) do |soup|
    soup.author = ["James Adam"]
    soup.email = ["james@lazyatom.com"]
    soup.description = File.readlines("README").first
    soup.dependencies = ["activerecord >=2.0.2"]
    soup.clean_pattern = ["*.db", "meta", "pkg"]
    soup.ignore_pattern = [".git", "*.db", "meta"]
  end
  
rescue LoadError
  puts "You need to install the echoe gem to perform meta operations on this gem"
end

begin
  require 'spec'
  require 'spec/rake/spectask'
  
  Spec::Rake::SpecTask.new do |t|
    t.spec_opts = ["--format", "specdoc", "--colour"]
    t.spec_files = Dir['spec/**/*_spec.rb'].sort
    t.libs = ['lib']
    #t.rcov = true
    #t.rcov_dir = 'meta/coverage'
  end
  
  task :show_rcov do
    system 'open meta/coverage/index.html' if PLATFORM['darwin']
  end
  
rescue LoadError
  puts "You need RSpec installed to run the spec (default) task on this gem"
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb --prompt simple -rubygems -r ./lib/soup.rb"
end

task :default => [:spec, :show_rcov]