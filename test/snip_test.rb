require 'test_helper'

class SnipTest < Test::Unit::TestCase
  context "A snip" do
    setup do
      @snip = Soup::Snip.new({:name => "james", :content => "is awesome"}, nil)
    end

    should "be equal to another snip with the same attributes" do
      other_snip = Soup::Snip.new({:name => "james", :content => "is awesome"}, nil)
      assert other_snip == @snip
    end

    should "not be equal to another snip with differing attributes" do
      other_snip = Soup::Snip.new({:name => "james", :content => "is really awesome"}, nil)
      assert other_snip != @snip
    end

    should "be comparable in arrays" do
      other_snip = Soup::Snip.new({:name => "james", :content => "is awesome"}, nil)
      assert [@snip] == [other_snip]
    end

    context "loaded from the soup" do
      setup do
        @base_path = File.join(File.dirname(__FILE__), *%w[.. tmp soup])
        backend = Soup::Backends::FileBackend.new(@base_path)
        @soup = Soup.new(backend)
      end

      teardown do
        FileUtils.rm_rf(@base_path)
      end

      should "ignore empty content when comparing" do
        @soup << {:name => 'test'}
        assert_equal Soup::Snip.new({:name => 'test'}, nil), @soup['test']
      end
    end
  end
end