require 'soup'

require 'rubygems'
require 'redcloth'

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
    rescue Exception => e
      error_for(e.message, snip_name, part, args)
    end
    
    def error_for(message, snip_name, part=nil, args=[])
      "[Error - " + message + ": #{snip_name}]"
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

# Creates a default ruby dynasnip
def dynasnip(name, code, render_as="Ruby")
  snip = Snip.new(:name => name)
  snip.content = code
  snip.render_as = render_as
  snip.save
end