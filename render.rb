require 'rubygems'
require 'soup'
require 'dynasnip'

# This module relies on the Router model, which should define the following methods
# Router.new_link(snip_name)

module Render
  def self.class_called(renderer_name)
    const_get(renderer_name)
  end

  class Base
    attr_reader :context
    
    def initialize(context)
      # We just pass this on to other objects - other
      # renderers, really.
      @context = context
    end
    
    # Handles processing the text of the content. Subclasses should
    # override this method to do fancy text processing
    def process_text(snip, content, args)
      content
    end
    
    SNIP_REGEXP = re = %r{ \{
      ([\w\-]+) (?: \.([\w\-]+) )?
      (?: \s+ ([\w\-,]+) )?
    \} }x
    
    # Default behaviour to include a snip's content
    def include_snips(snip, content, args)
      content.gsub(SNIP_REGEXP) do
        snip_name = $1
        snip_attribute = $2
        snip_args = $3 ? $3.split(',') : []
        render(snip_name, snip_attribute, snip_args)
      end
    end
    
    # Simply calls a bunch of methods, passing the result of each to the next
    def chain(snip, part, args, *methods)
      methods.inject(render_part(snip, part, args)) { |content, method| send(method, snip, content, args) }
    end
    
    # Abstracted out because it might be useful to override somewhere
    def render_part(snip, part, *args)
      snip.__send__(part.to_sym)
    end
    
    # Default rendering behaviour. Subclasses shouldn't really need to touch this.
    def render(snip_name, part=nil, args=[])
      snip = Snip[snip_name]
      if snip
        if part
          render_part(snip, part, args)
        else
          render_part_as_snip(snip, :content, args)
        end
      else
        "[Snip does not exist: #{Router.new_link(snip_name)}]"
      end
    rescue Exception => e
      error_for(e, snip_name, part, args)
    end
    
    # Yields the appropriate renderer for the given snip. The default
    # renderer is this one (Render::Base)
    def rendering(snip, part, args=[], renderer=nil)
      if renderer = renderer || snip.render_as
        yield Render.class_called(renderer).new(context), snip, part, args
      else
        yield self, snip, part, args
      end
    end
    
    # Renders a part of a snip, but using the renderer specified on for the main snip
    def render_part_as_snip(snip, part, args=[], renderer=nil)
      rendering(snip, part, args, renderer) do |renderer, snip, part, args|
        renderer.chain snip, part, args, :process_text, :include_snips
      end      
    end
    
    def error_for(e, snip_name, part=nil, args=[])
      "[<strong>Error</strong> - " + e.message + 
      ": #{snip_name}<br/><em>Backtrace:</em><br/>#{e.backtrace.join('<br/>')}]"
    end
  end
end

# Load all the other renderer subclasses
Dir['renderers/*.rb'].each { |f| require f }

def snip(name, content, other_attributes={})
  snip = Snip.new(other_attributes.merge(:name => name))
  snip.content = content
  snip.save
end

# Creates a default ruby dynasnip
def dynasnip(name, code, other_attributes={:render_as => "Ruby"})
  snip(name, code, other_attributes)
end