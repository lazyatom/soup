require "test_helper"
require "ftools"

class FileBackendTest < Test::Unit::TestCase
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

    should "take name from filename if not supplied" do
      write_snip "blahface", "The snip content"
      assert_equal "blahface", @soup["blahface"].name
    end

    should "take updated_at and created_at from file timestamps if not supplied" do
      @soup << {:name => "snip", :content => "whatever"}
      updated = Time.parse("2010-11-04 14:56")
      File.utime(updated, updated, path_for("snip"))

      snip = @soup["snip"]
      assert_equal updated, snip.updated_at
      assert_equal Time.now.to_i, snip.created_at.to_i
    end

    should "take created_at from attributes if supplied" do
      now = Time.now
      @soup << {:name => "snip", :content => "whatever", :updated_at => now}

      snip = @soup["snip"]
      assert_equal now.to_i, snip.created_at.to_i
    end
  end

  private

  def path_for(name)
    File.join(@base_path, name + ".snip")
  end

  def write_snip(name, content)
    File.open(path_for(name), "w") { |f| f.write content.strip }
  end
end