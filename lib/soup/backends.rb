class Soup
  # Backends should implement (or delegate) the following API:
  # * #prepare - will be called when a Soup is created
  # * #names - should return the names of all snips contained
  # * #load_snip(name) - should return a Soup::Snip, or nil if it couldn't be loaded
  # * #save_snip(attribute_hash) - should store and return a Soup::Snip, or nil if it couldn't be saved
  # * #destroy(name) - should return true if the snip was removed, or false if otherwise
  module Backends
    autoload :Base, 'soup/backends/base'
    autoload :YAMLBackend, 'soup/backends/yaml_backend'
    autoload :MultiSoup, 'soup/backends/multi_soup'
    autoload :ReadOnly, 'soup/backends/read_only'
  end
end