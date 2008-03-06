require 'snip'

module Soup
  VERSION = "0.1.2"
  
  DEFAULT_CONFIG = {
    :adapter  => 'sqlite3',
    :database => 'soup.db'
  }
  
  DEFAULT_TUPLE_IMPLEMENTATION = "active_record_tuple"
  
  # Set the base of this soup, i.e. where to get the data. This is the
  # database configuration, i.e.
  #
  #   Soup.base = {:database => 'my_soup.db'}
  #
  def self.base=(database_config)
    @database_config = database_config
  end
  
  # Call this to set which tuple implementation to use, i.e.
  #
  #   Soup.flavour = :active_record
  #
  def self.flavour=(tuple_implementation)
    @tuple_implementation = "#{tuple_implementation}_tuple"
  end
  
  # Get the soup ready!
  def self.prepare
    require @tuple_implementation || DEFAULT_TUPLE_IMPLEMENTATION
    Tuple.prepare_database(DEFAULT_CONFIG.merge(@database_config || {}))
  end
end