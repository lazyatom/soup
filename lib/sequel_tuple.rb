require 'rubygems'
gem 'sequel'

DB = Sequel.sqlite 'soup_development.db'
  
class SequelTuple < Sequel::Model(:tuples)
  set_schema do
    primary_key :id
    integer :snip_id
    string :name
    string :value
    datetime :created_at
    datetime :updated_at
  end
  
  def self.prepare_database(config)
    # ummm... how to connect?
    create_table # TODO: detect if the table already exists
  end
  
  def self.for_snip(id)
    filter(:snip_id => id).to_a
  end

  # TODO: *totally* not threadsafe.
  def self.next_snip_id
    max(:snip_id) + 1
  end
end