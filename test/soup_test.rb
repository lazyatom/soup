require 'test/unit'
require 'shoulda'
require 'soup'

class SoupTest < Test::Unit::TestCase

  def self.each_backend(&block)
    backends = [Soup::Backends::YAMLBackend.new(File.join(File.dirname(__FILE__), *%w[.. tmp soup]))]
    backends.each do |backend|
      context "The #{backends.class.name} Soup backend" do
        setup do
          @soup = Soup.new(backend)
        end
        yield
      end
    end
  end

  each_backend do |backend|
    should "be able to store content" do
      @soup << {:name => 'test', :content => "I like stuff, and things"}
      assert_equal "I like stuff, and things", @soup['test'].content
    end

    context "when sieving the soup" do
      setup do
        @james = @soup << {:name => 'james', :spirit_guide => 'fox', :colour => 'blue', :powers => 'yes'}
        @murray = @soup << {:name => 'murray', :spirit_guide => 'chaffinch', :colour => 'red', :powers => 'yes'}
      end

      should "find snips by name if the parameter is a string" do
        assert_equal @james, @soup['james']
      end

      should "find snips using exact matching of keys and values if the parameter is a hash" do
        assert_equal @murray, @soup[:name => 'murray']
      end

      should "match using all parameters" do
        assert_equal @james, @soup[:powers => 'yes', :colour => 'red']
      end

      should "return an array if more than one snip matches" do
        assert_equal [@james, @murray], @soup[:powers => 'yes']
      end

      should "return an empty array if no matching snips exist" do
        assert_equal [], @soup[:powers => 'maybe']
      end
    end

    should "allow deletion of snips" do
      snip = @soup << {:name => 'test', :content => 'content'}
      assert_equal snip, @soup['test']

      @soup['test'].destroy
      assert @soup['test'].nil?
    end
  end
end
