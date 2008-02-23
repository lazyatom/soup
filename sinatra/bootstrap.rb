$LOAD_PATH << "lib"
$LOAD_PATH.uniq!

require 'soup'
require 'render'

if __FILE__ == $0
  Tuple.prepare_database 
  load File.join(File.dirname(__FILE__), *%w[system_snips.rb])
  load File.join(File.dirname(__FILE__), *%w[test_snips.rb])
end