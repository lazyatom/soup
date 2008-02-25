require 'render'

module Render
  class Bold < Base
    def process_text(snip, content, args)
      "<b>#{content}</b>" 
    end
  end
end