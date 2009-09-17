# Let us require stuff in lib without saying lib/ all the time
$LOAD_PATH.unshift(File.dirname(__FILE__)).uniq!

require 'soup/snip'
require 'yaml'
require 'fileutils'

class Soup
  VERSION = "0.9.9"

  # You can access a default soup using this methods.

  def self.default_instance #:nodoc:
    @@instance ||= new
  end

  def self.[](*args)
    default_instance[*args]
  end

  def self.<<(attributes)
    default_instance << attributes
  end

  def self.sieve(*args)
    default_instance.sieve(*args)
  end
  
  def self.destroy(*args)
    default_instance.destroy(*args)
  end

  attr_reader :base_path

  # Get the soup ready!
  def initialize(base_path="soup")
    @base_path = base_path
    FileUtils.mkdir_p(base_path)
  end

  # The main interface
  # ==================

  # A shorthand for #sieve, with the addition that only a name may be
  # supplied (i.e. Soup['my snip'])
  def [](conditions)
    conditions = {:name => conditions} unless conditions.respond_to?(:keys)
    sieve(conditions)
  end

  # Puts some data into the soup, and returns an object that contains
  # that data. The object should respond to accessing and setting its
  # attributes as if they were defined using attr_accessor on the object's
  # class.
  def <<(attributes)
    save_snip(attributes)
    Snip.new(attributes, self)
  end

  # Finds bits in the soup that make the given attribute hash.
  # This method should eventually be delegated to the underlying persistence
  # layers (i.e. Snips and Tuples, or another document database). The expected
  # behaviour is
  def sieve(conditions)
    if conditions.keys == [:name]
      load_snip(conditions[:name])
    else
      all_snips.select do |s|
        conditions.inject(true) do |matches, (key, value)|
          matches && (s.__send__(key) == value)
        end
      end
    end
  end

  def destroy(name)
    File.delete(path_for(name))
  end

  private

  def save_snip(attributes)
    File.open(path_for(attributes[:name]), 'w') do |f| 
      content = attributes.delete(:content)
      f.write content
      f.write attributes.to_yaml.gsub(/^---\s/, attribute_token)
    end
  end

  def load_snip(name)
    path = path_for(name)
    if File.exist?(path)
      file = File.read(path)
      attribute_start = file.index(attribute_token)
      content = file.slice(0...attribute_start)
      attributes = YAML.load(file.slice(attribute_start..-1)).merge(:content => content)
      Snip.new(attributes, self)
    else
      nil
    end
  end

  def all_snips
    Dir[path_for("*")].map do |path|
      load_snip(File.basename(path, ".yml"))
    end
  end

  def path_for(filename)
    File.join(base_path, filename + ".yml")
  end
  
  def attribute_token
    "--- # Soup attributes"
  end
end
