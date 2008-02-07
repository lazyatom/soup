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
  
  def save
    super if dirty? or new_record?
  end
  
  # TODO: *totally* not threadsafe.
  def self.next_snip_id
    database.query("SELECT MAX(snip_id) + 1 FROM tuples")[0] || 1
  end
end
