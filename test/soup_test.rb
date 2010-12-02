require "test_helper"

def each_backend(&block)
  base_path = File.join(File.dirname(__FILE__), *%w[.. tmp soup])
  backends = [
    yaml_backend = Soup::Backends::YAMLBackend.new(base_path),
    file_backend = Soup::Backends::FileBackend.new(base_path),
    Soup::Backends::MultiSoup.new(yaml_backend)
  ]
  backends.each do |backend|
    context "The #{backend.class.name} Soup backend" do
      setup do
        @soup = Soup.new(backend)
      end
      teardown do
        FileUtils.rm_rf(base_path)
      end
      instance_eval(&block)
    end
  end
end

each_backend do
  should "be able to store content" do
    @soup << {:name => 'test', :content => "I like stuff, and things"}
    assert_equal "I like stuff, and things", @soup['test'].content
  end

  should "return a snip when storing content" do
    snip = @soup << {:name => 'test', :content => "I like stuff, and things"}
    assert_equal "I like stuff, and things", snip.content
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
      assert_equal [@murray], @soup[:powers => 'yes', :colour => 'red']
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