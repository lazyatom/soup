describe Soup::TestHelper do
  include Soup::TestHelper

  setup do
    @soup = stub_soup({:name => "a", :kind => "x"},
                      {:name => "b", :kind => "y"},
                      {:name => "c", :kind => "x"})
  end

  should "allow stubbing of all snips" do
    assert_same_elements %w(a b c), @soup.all_snips.map { |s| s.name }
  end

  should "stub loading a snip by name" do
    assert_equal "a", @soup["a"].name
  end

  should "stub loading snips by criteria" do
    assert_same_elements %w(a c), @soup[:kind => "x"].map { |s| s.name }
  end
end