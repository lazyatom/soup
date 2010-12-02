require "test_helper"
require "ftools"
require "time"

context "The file-based backend" do
  setup do
    @base_path = File.join(File.dirname(__FILE__), *%w[.. tmp soup])
    @soup = Soup.new(Soup::Backends::FileBackend.new(@base_path))
  end

  should "parse attributes from lines starting with colon" do
    write_snip "snip", %{
Here is the content
of the snip

:name: thing
:render_as: Markdown
:multi_line_attribute: |
  stuff
  things
:blah: yes
    }

    snip = @soup["snip"]
    assert_equal "Here is the content\nof the snip", snip.content
    assert_equal "thing", snip.name
  end

  should "write a snip in the simple format" do
    @soup << {:content => "Here is the content", :name => "dave"}
    assert_equal %{Here is the content\n\n:name: dave\n}, File.read(path_for("dave"))
  end

  should "not require snip attributes to give content" do
    write_snip "test", "snip content"
    assert_equal "snip content", @soup["test"].content
  end

  should "take updated_at and created_at from file timestamps if not supplied" do
    @soup << {:name => "snip", :content => "whatever"}
    time = Time.parse("2010-11-04 14:56")
    File.utime(time, time, path_for("snip"))
  end

  should "take name from filename if not supplied" do
    write_snip "blahface", "The snip content"
    assert_equal "blahface", @soup["blahface"].name
  end

  should "take updated_at and created_at from file timestamps if not supplied" do
    @soup << {:name => "snip", :content => "whatever"}
    time = Time.parse("2010-11-04 14:56")
    File.utime(time, time, path_for("snip"))

    snip = @soup["snip"]
    assert_equal time, snip.updated_at
    assert_equal time, snip.created_at
  end

  should "take created_at from attributes if supplied" do
    created_at = Time.parse("2010-11-04 14:56")
    @soup << {:name => "snip", :content => "whatever", :created_at => created_at}

    snip = @soup["snip"]
    assert_equal created_at.to_i, snip.created_at.to_i
  end

  helpers do
    def path_for(name)
      File.join(@base_path, name + ".snip")
    end

    def write_snip(name, content)
      File.open(path_for(name), "w") { |f| f.write content.strip }
    end
  end
end