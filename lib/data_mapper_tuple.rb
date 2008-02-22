require 'rubygems'
require 'data_mapper'

DataMapper::Database.setup({
  :adapter  => 'sqlite3',
  :database => 'soup_development'
})

class Tuple < DataMapper::Base
  
  property :snip_id, :integer
  
  property :name, :string
  property :value, :text
  
  property :created_at, :datetime
  property :updated_at, :datetime
  
  def self.for_snip(id)
    all(:snip_id => id)
  end
  
  def self.all_for_snip_named(name)
    id = first(:name => "name", :value => name).snip_id
    for_snip(id)
  end
  
  # TODO: *totally* not threadsafe.
  def self.next_snip_id
    database.query("SELECT MAX(snip_id) + 1 FROM tuples")[0] || 1
  end

  def save
    if dirty? or new_record?
      puts "saving tuple #{self}"
      super
    end
  end
  
  alias_method :destroy, :destroy!
end

# Create the table with this:
#
# DataMapper::Persistence.auto_migrate!