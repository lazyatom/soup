$LOAD_PATH << "lib"
$LOAD_PATH.uniq!

require 'soup'
require 'render'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'soup_development.db'
)

def load_snips(kind)
  Dir[File.join(File.dirname(__FILE__), kind, '*.rb')].each do |f|
    puts "loading #{f}"
    load f
  end
end

if __FILE__ == $0
  Tuple.prepare_database 
  
  require File.join(File.dirname(__FILE__), *%w[snip_helper])

  load_snips('dynasnips')
  load_snips('snips')
  
  load File.join(File.dirname(__FILE__), *%w[test_snips.rb])
  
  puts "Loaded #{Tuple.count} tuples"
end