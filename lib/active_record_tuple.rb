require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'soup_development'
)

class Tuple < ActiveRecord::Base
  def self.for_snip(id)
    find_all_by_snip_id(id)
  end
  
  # TODO: *totally* not threadsafe.
  def self.next_snip_id
    maximum(:snip_id) + 1
  end
  
  def save
    super if new_record? || dirty?
  end
  
  private 
  
  def dirty?
    true # hmm.
  end
end
  
# Create the table with this:
#
# ActiveRecord::Migration.create_table do 
#   t.column :snip_id, :integer
#   t.column :name, :string
#   t.column :value, :text
#   t.column :created_at, :datetime
#   t.column :updated_at, :datetime
# end

