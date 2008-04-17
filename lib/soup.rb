# Let us require stuff in lib without saying lib/ all the time
$LOAD_PATH.unshift(File.dirname(__FILE__)).uniq!

require 'soup/snip'

module Soup
  VERSION = "0.2.1"
  
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
    # We want to reset the tuple class if we re-flavour the soup.
    @tuple_class = nil
  end
  
  def self.tuple_class
    @tuple_class ||= case (@tuple_implementation || DEFAULT_TUPLE_IMPLEMENTATION)
    when "active_record_tuple", nil
      Soup::Tuples::ActiveRecordTuple
    when "data_mapper_tuple"
      Soup::Tuples::DataMapperTuple
    when "sequel_tuple"
      Soup::Tuples::SequelTuple
    end
  end
  
  # Get the soup ready!
  def self.prepare
    require "soup/tuples/#{@tuple_implementation || DEFAULT_TUPLE_IMPLEMENTATION}"
    tuple_class.prepare_database(DEFAULT_CONFIG.merge(@database_config || {}))
  end
  
  # The main interface
  # ==================
  
  # Finds bits in the soup that make the given attribute hash.
  # This method should eventually be delegated to the underlying persistence
  # layers (i.e. Snips and Tuples, or another document database). The expected
  # behaviour is 
  def self.sieve(*args)
    Snip.sieve(*args)
  end
  
  # Puts some data into the soup, and returns an object that contains
  # that data. The object should respond to accessing and setting its
  # attributes as if they were defined using attr_accessor on the object's
  # class.
  def self.<<(attributes)
    s = Snip.new(attributes)
    s.save
    s
  end
  
  # A shortcut to sieve by name attribute only
  def self.[](*args)
    results = if args[0].is_a?(Hash) || args.length > 1
      sieve(*args)
    else
      sieve(:name => args[0])
    end
    results.length == 1 ? results.first : results
  end
  
  # ==== (interface ends) =====
  
  # Save the current state of the soup into a YAML file.
  def self.preserve(filename='soup.yml')
    snips = {}
    1.upto(Soup.tuple_class.next_snip_id) do |id|
      snip = Snip.find(id) rescue nil
      snips[snip.id] = snip if snip
    end
    File.open(filename, 'w') do |f|
      f.puts snips.to_yaml
    end
  end
end