require 'rubygems'
require 'bundler/setup'
require 'kintama'
require 'soup'

Kintama.setup do
  @base_path = File.join(File.dirname(__FILE__), *%w[.. tmp soup])
end
