$LOAD_PATH << "lib"

require 'soup'

DataMapper::Persistence.auto_migrate!

s1 = Snip.new(:name => "snip1")
s1.content = <<EOF
Here's a super snip: {snip2.name}
EOF
s1.save

s2 = Snip.new(:name => "snip2")
s2.content =<<EOF
Snip2 in da house!
EOF
s2.save

def render(snip_name, part=nil)
  snip = Snip.find_by_name(snip_name)
  if part
    snip.__send__(part.to_sym)
  else
    snip.content.gsub(/\{(\w+)\.?(\w+)?\}/) do
      render($1, $2)
    end
  end
  
end

puts render('snip1')