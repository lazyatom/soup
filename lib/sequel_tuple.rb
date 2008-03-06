require 'rubygems'
require 'sequel'

DB = Sequel.sqlite 'soup_development.db'
  
class Tuple < Sequel::Model(:tuples)
  set_schema do
    primary_key :id
    integer :snip_id
    string :name
    string :value
    datetime :created_at
    datetime :updated_at
  end
  
  def self.connect_to_database(config)
    # ummm... how?
  end
  
  def self.prepare_database
    create_table
  end
  
  def self.for_snip(id)
    filter(:snip_id => id).to_a
  end

  # TODO: *totally* not threadsafe.
  def self.next_snip_id
    max(:snip_id) + 1
  end
end