require 'render'

require 'rubygems'
# from http://www.deveiate.org/projects/BlueCloth
gem 'BlueCloth'
require 'bluecloth'

module Render
  class Markdown < Base
    def process_text(snip, content, args)
      BlueCloth.new(content).to_html
    end
  end
end