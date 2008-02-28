$LOAD_PATH << "lib"
$LOAD_PATH.uniq!

require 'soup'
require 'render'

def snip(name, content, other_attributes={})
  snip = Snip.new(other_attributes.merge(:name => name))
  snip.content = content
  snip.save
end

# Creates a default ruby dynasnip
def dynasnip(name, code, other_attributes={:render_as => "Ruby"})
  snip(name, code, other_attributes)
end