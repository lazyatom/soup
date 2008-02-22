$LOAD_PATH << "lib"

require 'soup'

require 'rubygems'
require 'redcloth'

DataMapper::Persistence.auto_migrate!

s1 = Snip.new(:name => "snip1")
s1.content = <<EOF
Linking is good: {link_to bold}
Here's a bold snip: {bold}
Here's a random number between 5 and 15: {rand 5,15}

And lets include some textile: {textile_example}
The source for that was {pre textile_example}

And lets include some markdown!: {markdown_example}
The source for that was {pre markdown_example}

EOF
s1.save

bold = Snip.new(:name => "bold")
bold.content =<<EOF
Snip2 in da house!
EOF
bold.render_as = "Bold"
bold.save

textile = Snip.new(:name => "textile_example")
textile.content =<<EOF
# testing lists

what the *hell* are __you__ looking at? "Beyotch":http://example.com
EOF
textile.render_as = "Textile"
textile.save

textile = Snip.new(:name => "markdown_example")
textile.content =<<EOF
# testing header

what the *hell* are looking at, [beyotch](http://example.com)?
EOF
textile.render_as = "Markdown"
textile.save

link_to = Snip.new(:name => "link_to")
link_to.content =<<EOF
class Linker
  def handle(snip_name)
    %{<a href="\#{snip_name}">\#{snip_name}</a>}
  end
end
Linker
EOF
link_to.render_as = "Ruby"
link_to.save

pre = Snip.new(:name => "pre")
pre.content =<<EOF
class ShowContentInPreTag
  def handle(snip_name)
    %{<pre>\#{Snip.find_by_name(snip_name).content}</pre>}
  end
end
ShowContentInPreTag
EOF
pre.render_as = "Ruby"
pre.save

rand = Snip.new(:name => "rand")
rand.content =<<EOF
class RandomNumber
  def handle(min, max)
    # arguments come in as strings, so we need to convert them.
    min = min.to_i
    max = max.to_i
    (rand(max-min) + min)
  end
end
RandomNumber
EOF
rand.render_as = "Ruby"
rand.save

module Render
  def self.class_called(renderer_name)
    const_get(renderer_name)
  end

  class Base
    # Yields the appropriate renderer for the given snip. The default
    # renderer is this one (Render::Base)
    def rendering(snip, args=[])
      if renderer = snip.render_as
        yield Render.class_called(renderer).new, snip, args
      else
        yield self, snip, args
      end
    end
    
    # Handles processing the text of the content. Subclasses should
    # override this method to do fancy text processing
    def process_text(str, args)
      str
    end
    
    SNIP_REGEXP = re = %r{ \{
      (\w+) (?: \.(\w+) )?
      (?: \s+ ([\w,]+) )?
    \} }x
    
    # Default behaviour to include a snip's content
    def include_snips(content, args)
      content.gsub(SNIP_REGEXP) do
        snip_name = $1
        snip_attribute = $2
        snip_args = $3 ? $3.split(',') : []
        render(snip_name, snip_attribute, snip_args)
      end
    end
    
    # Simply calls a bunch of methods, passing the result of each to the next
    def chain(snip, args, *methods)
      methods.inject(snip.content) { |str, method| send(method, str, args) }
    end
    
    # Abstracted out because it might be useful to override somewhere
    def render_part(snip, part, *args)
      snip.__send__(part.to_sym)
    end
    
    # Default rendering behaviour. Subclasses shouldn't really need to touch this.
    def render(snip_name, part=nil, args=[])
      snip = Snip.find_by_name(snip_name)
      if part
        render_part(snip, part, args)
      else
        rendering(snip, args) do |renderer, snip, args|
          renderer.chain snip, args, :process_text, :include_snips
        end
      end
    end
  end

  # Snips that render_as "Ruby" should define a class which has the instance
  # method 'handle' on it.
  # The last line of the content should be the name of that class, so that it
  # is returned by "eval" and we can instantiate it.
  # The result always has #to_s called on it.
  class Ruby < Base
    def process_text(str, args)
      handler = eval(str)
      handler.new.handle(*args).to_s
    end
  end

  class Bold < Base
    def process_text(str, args)
      "<b>#{str}</b>" 
    end
  end
  
  class Textile < Base
    def process_text(str, args)
      RedCloth.new(str).to_html
    end
  end
  
  class Markdown < Base
    def process_text(str, args)
      RedCloth.new(str).to_html(:markdown)
    end
  end
end

def render(snip_name, part=nil)
  Render::Base.new.render(snip_name, part)
end

puts render('snip1')