require 'render'

require 'erb'
include ERB::Util

module Render
  class Erb < Base
    def process_text(snip, content, args)
      ERB.new(content).result(binding)
    end
  end
end