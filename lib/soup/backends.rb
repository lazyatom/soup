class Soup
  module Backends
    autoload :YAMLBackend, 'soup/backends/yaml_backend'
    autoload :MultiSoupBackend, 'soup/backends/multi_soup_backend'
    autoload :ReadOnly, 'soup/backends/read_only'
  end
end