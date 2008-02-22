$LOAD_PATH << "lib"

require 'soup'

require 'rubygems'
require 'redcloth'

DataMapper::Persistence.auto_migrate!

s1 = Snip.new(:name => "snip1")
s1.content = <<EOF
Linking is good: [snip2]
Here's a super snip: {snip2}

And lets include some textile: {textile_example}
The source for that was <pre>{textile_example.content}</pre>

And lets include some markdown!: {markdown_example}
The source for that was <pre>{markdown_example.content}</pre>

EOF
s1.save

s2 = Snip.new(:name => "snip2")
s2.content =<<EOF
Snip2 in da house!
EOF
s2.render_as = "Bold"
s2.save

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

what the *hell* are __you__ looking at? [Beyotch](http://example.com)
EOF
textile.render_as = "Markdown"
textile.save


module Render
  def self.class_called(renderer_name)
    const_get(renderer_name)
  end

  class Base
    def rendering(snip, &block)
      if renderer = snip.render_as
        yield Render.class_called(renderer).new, snip
      else
        yield self, snip
      end
    end
    
    # handles processing the text of the content
    def process_text(str)
      str
    end
    
    def include_snips(content)
      content.gsub(/\{(\w+)\.?(\w+)?\}/) do
        render($1, $2)
      end
    end
    
    def link_snips(content)
      content.gsub(/\[(\w+)\]/) do
        %{<a href="#{$1}">#{$1}</a>}
      end
    end
    
    def render(snip_name, part=nil)
      snip = Snip.find_by_name(snip_name)
      if part
        snip.__send__(part.to_sym)
      else
        rendering(snip) do |renderer, snip|
          output = renderer.include_snips(snip.content)
          output = renderer.link_snips(output)
          output = renderer.process_text(output)
        end
      end
    end
  end

  class Bold < Base
    def process_text(str)
      "<b>#{str}</b>" 
    end
  end
  
  class Textile < Base
    def process_text(str)
      RedCloth.new(str).to_html
    end
  end
  
  class Markdown < Base
    def process_text(str)
      RedCloth.new(str).to_html(:markdown)
    end
  end
end

def render(snip_name, part=nil)
  Render::Base.new.render(snip_name, part)
end

puts render('snip1')