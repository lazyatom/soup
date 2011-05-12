require "test_helper"

context "A Soup with multiple backends" do
  setup do
    @basic_soup_backend_one = Soup::Backends::YAMLBackend.new(File.join(@base_path, "soup_one"))
    @basic_soup_backend_two = Soup::Backends::FileBackend.new(File.join(@base_path, "soup_two"))
    @soup_one = Soup.new(@basic_soup_backend_one)
    @soup_two = Soup.new(@basic_soup_backend_two)
    multi_soup_backend = Soup::Backends::MultiSoup.new(@basic_soup_backend_one, @basic_soup_backend_two)
    @soup = Soup.new(multi_soup_backend)
  end

  teardown do
    FileUtils.rm_rf(@base_path)
  end

  should "return nil when the requested snip is not present in any backend" do
    assert_nil @soup["snip"]
  end

  should "return a snip if any backend contains it" do
    @soup_one << {:name => "snip", :body => "hello"}
    assert_equal "hello", @soup["snip"].body

    @soup_two << {:name => "other_snip", :body => "hi!"}
    assert_equal "hi!", @soup["other_snip"].body
  end

  context "when snips of the same name exist in multiple backends" do
    setup do
      @soup_one << {:name => "snip", :body => "from soup one"}
      @soup_two << {:name => "snip", :body => "from soup two"}
    end

    should "load the snip from the backend with the higher precidence" do
      assert_equal "from soup one", @soup["snip"].body
    end
  end

  context "when snips with a certain attribute exist in multiple backends" do
    setup do
      @soup_one << {:name => "snip1", :active => true}
      @soup_two << {:name => "snip2", :active => true}
    end

    should "find matching snips from all backends" do
      assert_equal 2, @soup[:active => true].length
    end
  end

  should "save snips" do
    @soup << {:name => "snip", :body => "bad snip"}
    @soup.destroy("snip")
    assert_nil @soup["snip"]
  end

  context "when a backend is read-only" do
    setup do
      readonly_backend = Soup::Backends::ReadOnly.new(@basic_soup_backend_one)
      @soup_one = Soup.new(readonly_backend)
      @soup_two = Soup.new(@basic_soup_backend_two)
      multi_soup_backend = Soup::Backends::MultiSoup.new(readonly_backend, @basic_soup_backend_two)
      @soup = Soup.new(multi_soup_backend)
    end

    should "store snips in the writeable backend" do
      @soup << {:name => "snip", :body => "hello"}
      assert_equal "hello", @soup["snip"].body
      assert_nil @soup_one["snip"]
      assert_not_nil @soup_two["snip"]
    end
  end

  should "return all snips" do
    @soup_one << {:name => "alpha"}
    @soup_two << {:name => "beta"}
    assert_equal 2, @soup.all_snips.length
    assert_equal %w(alpha beta), @soup.all_snips.map { |s| s.name }
  end
end