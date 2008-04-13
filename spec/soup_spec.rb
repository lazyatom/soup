require 'soup'

describe Soup, "when unflavoured or based" do
  before(:each) { Soup.class_eval { @database_config = nil; @tuple_class = nil } }
  it "should use the default database config" do
    # I think this set of mock / expectations might be super wrong
    Soup::DEFAULT_CONFIG.should_receive(:merge).with({}).and_return(Soup::DEFAULT_CONFIG)
    Soup.tuple_class.should_receive(:prepare_database).with(Soup::DEFAULT_CONFIG)
    Soup.prepare
  end
  
  it "should use the default tuple implementation" do
    # No real idea how to mock the require, or use aught but Secret Knowledge that AR == Default
    Soup.tuple_class.should == ActiveRecordTuple
    ActiveRecordTuple.should_receive(:prepare_database)
    Soup.prepare
  end
  
end

describe Soup, "when being based" do
  before(:each) { Soup.class_eval { @database_config = nil; @tuple_class = nil } }
  
  it "should allow the base of the soup to be set" do
    Soup.should respond_to(:base=)
  end
  
  it "should use the new base when preparing the soup" do
    bouillabaisse = {:database => 'fishy.db', :adapter => 'fishdb'} 
    Soup.base = bouillabaisse
    Soup.tuple_class.should_receive(:prepare_database).with(bouillabaisse)
    Soup.prepare
  end
  
  it "should merge incomplete bases with the default" do
    tasteless = {:database => 'water.db'}
    Soup.base = tasteless
    Soup.tuple_class.should_receive(:prepare_database).with(Soup::DEFAULT_CONFIG.merge(tasteless))
    Soup.prepare
  end
  
  it "should allow the base to be reset" do
    bouillabaisse = {:database => 'fishy.db', :adapter => 'fishdb'} 
    Soup.base = bouillabaisse
    Soup.tuple_class.should_receive(:prepare_database).once.with(bouillabaisse).ordered
    Soup.prepare
    
    gazpacho = {:database => 'tomato.db', :adapter => 'colddb'}
    Soup.base = gazpacho
    Soup.tuple_class.should_receive(:prepare_database).once.with(gazpacho).ordered
    Soup.prepare
  end
  
  it "should not allow old bases to interfere with new ones" do
    bouillabaisse = {:database => 'fishy.db', :adapter => 'fishdb'} 
    Soup.base = bouillabaisse
    Soup.tuple_class.should_receive(:prepare_database).once.with(bouillabaisse).ordered
    Soup.prepare
    
    tasteless = {:database => 'water.db'}
    Soup.base = tasteless
    Soup.tuple_class.should_receive(:prepare_database).once.with(Soup::DEFAULT_CONFIG.merge(tasteless)).ordered
    Soup.tuple_class.should_not_receive(:prepare_database).with(bouillabaisse.merge(tasteless))
    Soup.prepare
  end
end

describe Soup, "when being flavoured" do
  before(:each) { Soup.class_eval { @database_config = nil; @tuple_class = nil } }
 
  it "should allow the soup to be flavoured" do
    Soup.should respond_to(:flavour=)
  end
  
  it "should determine the tuple class based on the flavour" do
    require 'data_mapper_tuple'
    Soup.flavour = :data_mapper
    Soup.tuple_class.should == DataMapperTuple
  end
  
  it "should allow the flavour to be set multiple times" do
    require 'data_mapper_tuple'
    Soup.flavour = :data_mapper
    Soup.tuple_class.should == DataMapperTuple
    
    require 'sequel_tuple'
    Soup.flavour = :sequel
    Soup.tuple_class.should_not == DataMapperTuple
    Soup.tuple_class.should == SequelTuple
  end
  
  it "should use have no tuple class if the flavour is unknowable" do
    Soup.flavour = :shoggoth
    Soup.tuple_class.should == nil
  end
end

# describe Soup, "when adding data to the soup" do
#   before(:each) do
#     Soup.base = {:database => "soup_test.db"}
#     Soup.flavour = :active_record
#     Soup.prepare
#   end
#   
#   it "should create a new snip and save it" do
#     attributes = {:name => 'monkey'}
#     Snip.should_receive(:new).with(attributes)
#     Soup << attributes
#   end
# end
