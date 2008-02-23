$LOAD_PATH << "lib"
$LOAD_PATH.uniq!

require 'soup'
require 'render'

if __FILE__ == $0
  Tuple.prepare_database 
  load 'system_snips.rb'
  load 'test_snips.rb'
end