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
end

describe Snip, "when saving" do
  before(:each) { @snip = Snip.new }
  
  it "should return all attributes when reloading" do
    @snip.name = "something"
    @snip.jazz = "smooth"
    @snip.save
    
    other_snip = Snip['something']
    other_snip.jazz.should == "smooth"
  end
end