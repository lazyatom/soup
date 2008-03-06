require 'snip'

module Soup
  VERSION = "0.1.2"
  
  DEFAULT_CONFIG = {
    :adapter  => 'sqlite3',
    :database => 'soup.db'
  }
  
  # Hmm. this metaphor is a bit rubbish.
  def self.season_with(database_config)
    @database_config = database_config
  end
  
  # Set the base of this soup - i.e. how to access the data
  def self.base(tuple_implementation)
    require "#{tuple_implementation}_tuple"
    Tuple.connect_to_database(@database_config || DEFAULT_CONFIG)
  end
  
end