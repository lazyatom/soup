require 'rubygems'

require 'lib/soup'

begin
  require 'echoe'

  Echoe.new("soup", Soup::VERSION) do |soup|
    soup.author = ["James Adam"]
    soup.email = ["james@lazyatom.com"]
    soup.description = File.readlines("README").first
    soup.dependencies = ["activerecord >=2.0.2"]
  end

rescue LoadError
  puts "You need to install the echoe gem to perform meta operations on this gem"
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/soup.rb"
end

# We have to run our own spec runner, because Snip will try to undefine
# rspec's should methods using the default one
task(:test) do
  files = FileList['spec/**/*_spec.rb']
  system "ruby spec/spec_runner.rb #{files} --format specdoc"
end