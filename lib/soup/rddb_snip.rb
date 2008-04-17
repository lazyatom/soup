require 'rubygems'
require 'rddb'
require 'soup/empty_class'

class RddbSnip < Soup::EmptyClass
  def self.db
    @db ||= setup_database
  end
  
  def self.setup_database
    db = Rddb::Database.new
    db.create_view('named') { |d, name| d.name == name ? d : nil }
    db.create_view('matching') { |d, keys_and_values| 
      keys_and_values.inject(true) { |result, (key, value)| 
        result && d.send(key) == value
      } ? d : nil
    }
    db
  end
  
  def self.sieve(*args)
    return nil unless args.length == 1
    if args.first.is_a?(Hash)
      documents_to_snips db.query('matching', args.first)
    else
      documents_to_snips db.query('named', args.first)
    end
  end
  
  def self.documents_to_snips(documents)
    documents.map do |document|
      s = RddbSnip.new
      s.rddb_document = document
      s
    end
  end
  
  def rddb_document=(doc)
    @rddb_document = doc
  end
  
  def initialize(attributes={})
    @attributes = attributes
  end

  def id
    @rddb_document ? @rddb_document.id : nil
  end

  def to_s
    "<Snip id:#{self.id || "unset"} #{tuples_as_string}>"
  end
  
  def inspect
    "<Snip id:#{self.id || "unset"} name:#{self.name}>"
  end
  
  def method_missing(method, *args)
    value = args.length > 1 ? args : args.first
    if method.to_s =~ /(.*)=\Z/ # || value - could be a nice DSL touch.
      set_value($1, value)
    else
      get_value(method.to_s)
    end
  end
  
  def set_value(name, value)
    @attributes[name.to_s] = value
  end
  
  def get_value(name)
    puts "looking for #{name}"
    @attributes[name.to_s] || (@rddb_document && @rddb_document.send(name))
  end
  
  def save
    @rddb_document ||= Rddb::Document.new
    @attributes.each { |name, value| @rddb_document[name] = value }
    self.class.db << @rddb_document
  end
end