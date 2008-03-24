require 'snip'

module Soup
  VERSION = "0.1.5"
  
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
  
  def self.tuple_class
    @tuple_class ||= case (@tuple_implementation || DEFAULT_TUPLE_IMPLEMENTATION)
    when "active_record_tuple", nil
      ActiveRecordTuple
    when "data_mapper_tuple"
      DataMapperTuple
    when "sequel_tuple"
      SequelTuple
    end
  end
  
  # Get the soup ready!
  def self.prepare
    require @tuple_implementation || DEFAULT_TUPLE_IMPLEMENTATION
    tuple_class.prepare_database(DEFAULT_CONFIG.merge(@database_config || {}))
  end
  
  # Save the current state of the soup into a YAML file.
  def self.preserve(filename='soup.yml')
    snips = {}
    1.upto(Soup.tuple_class.next_snip_id) do |id|
      snip = Snip.find(id) rescue nil
      snips[snip.name] = snip if snip
    end
    File.open(filename, 'w') do |f|
      f.puts snips.to_yaml
    end
  end
end