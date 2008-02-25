require 'render'

require 'rubygems'
gem 'RedCloth'
require 'redcloth'

module Render
  class Textile < Base
    def process_text(snip, content, args)
      RedCloth.new(content).to_html
    end
  end
end