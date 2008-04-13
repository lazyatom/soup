require 'rubygems'
gem 'activerecord', '>=2.0.2'
require 'activerecord'

class ActiveRecordTuple < ActiveRecord::Base
  set_table_name :tuples
  
  def self.prepare_database(config)
    ActiveRecord::Base.establish_connection(config)
    return if connection.tables.include?("tuples")  # NOTE - this probably isn't good enough (what if the schema has changed?)
    ActiveRecord::Migration.create_table :tuples, :force => true do |t|
      t.column :snip_id, :integer
      t.column :name, :string
      t.column :value, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end
  
  def self.for_snip(id)
    find_all_by_snip_id(id)
  end
  
  def self.find_matching(name, value_conditions=nil)
    condition_sql = "name = '#{name}'"
    condition_sql += " AND value #{value_conditions}" if value_conditions
    find(:all, :conditions => condition_sql)
  end
  
  # TODO: *totally* not threadsafe.
  def self.next_snip_id
    maximum(:snip_id) + 1 rescue 1
  end
  
  def save
    super if new_record? || dirty?
  end
  
  private 
  
  def dirty?
    true # hmm.
  end
end