require 'rubygems'
require 'soup'
require 'dynasnip'

# This module relies on the Router model, which should define the following methods
# Router.new_link(snip_name)

module Render
  def self.renderer_for(snip)
    snip.render_as ? const_get(snip.render_as) : nil
  end
  
  def self.rendering(snip_name, snip_part=:content, args=[], context={}, renderer=nil)
    snip = Snip[snip_name]
    if snip
      new_renderer = renderer || renderer_for(snip) || Render::Base
      part_to_render = snip_part || :content
      renderer_instance = new_renderer.new(snip, part_to_render, args, context)
      yield renderer_instance
    else
      "[Snip does not exist: #{snip_name}]"
    end
  rescue Exception => e
    "<pre>[Error rendering '#{snip_name}' - " + e.message + "]</pre>"
    # ": #{snip_name}\nBacktrace:\n#{e.backtrace.join('\n')}]</pre>" # this seems to produce a confusing backtick for Markdown.
  end
  
  # render a snip using either the renderer given, or the renderer
  # specified by the snip's "render_as" property, or Render::Base
  # if nothing else is given.
  def self.render(snip_name, snip_part=:content, args=[], context={}, renderer=nil)
    rendering(snip_name, snip_part, args, context, renderer) do |r|
      r.render
    end
  end
  
  def self.render_without_including_snips(snip_name, snip_part=:content, args=[], context={}, renderer=nil)
    rendering(snip_name, snip_part, args, context, renderer) do |r|
      r.render_without_including_snips
    end
  end
  
  class Base
    attr_reader :context, :snip, :part, :args
    
    def initialize(snip, snip_part=:content, args=[], context={})
      @context = context
      @snip = snip
      @part = snip_part
      @args = args
      puts "[#{self.object_id}] #{self.class.name}.new(#{snip.inspect}, #{snip_part.inspect}, #{args.inspect}, #{context.inspect})"
    end
    
    # Handles processing the text of the content. Subclasses should
    # override this method to do fancy text processing like markdown
    # or loading the content as Ruby code.
    def process_text(snip, content, args)
      content
    end
    
    SNIP_REGEXP = re = %r{ \{
      ([\w\-]+) (?: \.([\w\-]+) )?
      (?: \s+ ([\w\-,]+) )?
    \} }x
    
    # Default behaviour to include a snip's content
    def include_snips(content)
      content.gsub(SNIP_REGEXP) do
        snip_name = $1
        snip_attribute = $2
        snip_args = $3 ? $3.split(',') : []
        # Render the snip or snip part with the given args, and the current
        # context, but with the default renderer for that snip.
        Render.render(snip_name, snip_attribute, snip_args, @context)
      end
    end
    
    def prevent_snip_inclusion(content)
      content.gsub("{", "&#123;").gsub("}" ,"&#125;")
    end
    
    def render_without_including_snips
      puts "[#{self.object_id}] rendering #{@snip.name} without including snips"
      raw_content = @snip.__send__(@part)
      process_text(@snip, raw_content, @args)
    end
    
    # Default rendering behaviour. Subclasses shouldn't really need to touch this.
    def render
      puts "[#{self.object_id}] rendering #{@snip.name} including snips"
      raw_content = @snip.__send__(@part)
      snip_expanded_content = include_snips(raw_content)
      r = process_text(@snip, snip_expanded_content, @args)
      puts "[#{self.object_id}] DONE rendering #{@snip.name} including snips"
      puts "---\n#{r}\n---\n"
      r
    end
  end
end

# Load all the other renderer subclasses
Dir['renderers/*.rb'].each { |f| require f }