Soup.base = {:database => "soup_test.db"}
Soup.prepare

describe Snip, "when newly created" do
  before(:each) { @snip = Snip.new }
  
  it "should not have a name" do
    @snip.name.should be_nil
  end
  
  it "should return nil for any attributes" do
    @snip.other_attribute.should be_nil
  end
  
  it "should not have an id yet" do
    @snip.id.should be_nil
  end
end

describe Snip, "when being created with attributes" do
  it "should set attributes as passed in" do
    @snip = Snip.new(:beats => 'phat', :rhymes => 100)
    @snip.beats.should == 'phat'
    @snip.rhymes.should == 100
  end
  
  it "should ignore any id passed in" do
    @snip = Snip.new(:id => 1000) 
    @snip.id.should be_nil
  end
  
  it "should not ignore the secret __id" do
    @snip = Snip.new(:__id => 1000)
    @snip.id.should == 1000
  end
end

describe Snip, "when setting attributes" do
  before(:each) { @snip = Snip.new }
  
  it "should allow setting attributes" do
    @snip.something = "blah"
    @snip.something.should == "blah"
  end
  
  it "should not respond to attributes that have not been set" do
    @snip.should_not respond_to(:monkey)
  end
  
  it "should respond to attributes that have been set" do
    @snip.monkey = true
    @snip.should respond_to(:monkey)
  end
  
  it "should not allow setting of the id" do
    @snip.id = 100
    @snip.id.should_not == 100
    @snip.id.should be_nil
  end
end

describe Snip, "when saving" do
  before(:each) { @snip = Snip.new }
  
  it "should not save if there's no data" do
    lambda { @snip.save }.should raise_error
  end
  
  it "should return all attributes when reloading" do
    @snip.name = "something"
    @snip.jazz = "smooth"
    @snip.save
    
    other_snip = Snip['something']
    other_snip.jazz.should == "smooth"
  end
  
  it "should generate an id" do
    @snip.name = "something"
    @snip.save
    
    other_snip = Snip['something']
    other_snip.id.should_not be_nil
  end
  
  it "should not overwrite an existing id created via __id" do
    @snip = Snip.new(:__id => 100)
    @snip.name = "something_else"
    @snip.save
    
    other_snip = Snip['something_else']
    other_snip.id.should == 100
  end
end