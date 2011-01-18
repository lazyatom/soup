# require 'rubygems'
$LOAD_PATH.unshift "/Users/james/Code/lazyatom/jtest/lib"
require 'kintama'
require 'soup'

Kintama.setup do
  @base_path = File.join(File.dirname(__FILE__), *%w[.. tmp soup])
end
