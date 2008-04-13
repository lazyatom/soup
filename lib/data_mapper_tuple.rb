require 'rubygems'
gem 'datamapper'
require 'data_mapper'

# This tuple implementation is broken - there's a weird interaction
# where values are not set within the web application.
#
class DataMapperTuple < DataMapper::Base  
  def self.prepare_database(config)
    DataMapper::Database.setup(config)
    # NOTE: so um, this property stuff doesn't like it if you're not connected to the db
    # lets only have it once we are?  Seems mental.
    self.class_eval {
      set_table_name 'tuples'
      
      property :snip_id, :integer

      property :name, :string
      property :value, :text

      property :created_at, :datetime
      property :updated_at, :datetime
    }
    return if self.table.exists? # NOTE - this probably isn't good enough (what if the schema has changed?)
    DataMapper::Persistence.auto_migrate! 
  end
  
  def self.for_snip(id)
    all(:snip_id => id)
  end
  
  # TODO: *totally* not threadsafe.
  def self.next_snip_id
    database.query("SELECT MAX(snip_id) + 1 FROM tuples")[0] || 1
  end

  def save
    if dirty? or new_record?
      super
    end
  end
  
  alias_method :destroy, :destroy!
end