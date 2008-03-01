$LOAD_PATH << "lib"

require 'soup'
require 'render'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'soup_development.db'
)