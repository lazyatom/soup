require 'rubygems'
require 'sequel'

DB = Sequel.sqlite 'soup_development'
  
class Tuple < Sequel::Model(:tuples)
  set_schema do
    primary_key :id
    integer :snip_id
    string :name
    string :value
    datetime :created_at
    datetime :updated_at
  end
  
  def self.for_snip(id)
    Tuple.filter(:snip_id => id).to_a
  end

  # TODO: *totally* not threadsafe.
  def self.next_snip_id
    max(:snip_id) + 1
  end
end
  
  
# Create the table with this:
#
# Item.create_table