$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[.. lib]))

require 'soup'
require "soup/tuples/active_record_tuple"

def clear_database
  Soup::Tuples::ActiveRecordTuple.destroy_all
end