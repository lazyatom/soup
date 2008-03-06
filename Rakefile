require 'rubygems'
require 'rake/gempackagetask'

require 'lib/soup'

soup_spec = Gem::Specification.new do |s|
  s.name             = "soup"
  s.summary          = "A mess of data"
  s.version          = Soup::VERSION
  s.author           = "James Adam"
  s.email            = "james at lazyatom dot com"
  s.platform         = Gem::Platform::RUBY
  s.files            = FileList["{lib}/**/*"].exclude("rdoc").to_a
  s.require_path     = "lib"
  s.has_rdoc         = true
  s.extra_rdoc_files = ['README']
end

Rake::GemPackageTask.new(soup_spec) do |p|
  p.gem_spec = soup_spec
end

task :default => ["package"]