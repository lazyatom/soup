require 'rubygems'
#Gem::manage_gems
require 'rake/gempackagetask'

files = FileList["{lib}/**/*"].exclude("rdoc").to_a
p files 

spec = Gem::Specification.new do |s|
  s.name             = "snip_space"
  s.summary          = "A mess of data"
  s.version          = "0.1.0"
  s.author           = "James Adam"
  s.email            = "james at lazyatom dot com"
  s.platform         = Gem::Platform::RUBY
  s.files            = files
  s.require_path     = "lib"
  s.has_rdoc         = true
  s.extra_rdoc_files = ['README']
end

Rake::GemPackageTask.new(spec) do |p|
  p.need_tar = true
  p.gem_spec = spec
end

task :default => [:package]