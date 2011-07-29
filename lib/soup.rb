# Let us require stuff in lib without saying lib/ all the time
$LOAD_PATH.unshift(File.dirname(__FILE__)).uniq!

require 'yaml'
require 'fileutils'

class Soup
  autoload :Backends, 'soup/backends'
  autoload :Snip, 'soup/snip'
  autoload :TestHelper, 'soup/test_helper'

  class BackendIncompatibleError < StandardError; end

  # Get the soup ready!
  def initialize(backend=nil)
    @backend = backend || Soup::Backends::FileBackend.new
    check_backend_for_compatibility
    @backend.prepare
  end

  # The main interface
  # ==================

  # A shorthand for #with, with the addition that only a name may be
  # supplied (i.e. soup['my snip'])
  def [](conditions)
    conditions = {:name => conditions} unless conditions.respond_to?(:keys)
    with(conditions)
  end

  # Puts some data into the soup, and returns an object that contains
  # that data. The object should respond to accessing and setting its
  # attributes as if they were defined using attr_accessor on the object's
  # class.
  def <<(attributes)
    @backend.save_snip(symbolize_keys(attributes))
  end

  # Finds bits in the soup that make the given attribute hash.
  # This method should eventually be delegated to the underlying persistence
  # layers (i.e. Snips and Tuples, or another document database). The expected
  # behaviour is
  def with(conditions)
    @backend.find(symbolize_keys(conditions))
  end

  def destroy(name)
    @backend.destroy(name)
  end

  def all_snips
    @backend.all_snips
  end

  private

  def check_backend_for_compatibility
    methods = [:all_snips, :load_snip, :save_snip, :prepare, :destroy]
    ok = methods.inject(true) { |ok, method| ok && @backend.respond_to?(method) }
    raise BackendIncompatibleError unless ok
  end

  def symbolize_keys(hash)
    hash.inject({}) { |h,(k,v)| h[k.to_sym] = v; h }
  end
end
