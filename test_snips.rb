$LOAD_PATH << "lib"
$LOAD_PATH.uniq!

require 'soup'
require 'render'

s1 = Snip.new(:name => "start")
s1.content =<<EOF
Linking is good: {link_to bold}
Here's a bold snip: {bold}

- Here's a random number between 5 and 15: {rand 5,15}
- Here's a random number between 90 and 100 (the default max): {rand 90}
- Here's a random number between 1 and 100 (the default range): {rand}

And lets include some textile: 

{textile_example}

The source for that was 

{pre textile_example}

And lets include some markdown!: 

{markdown_example}

The source for that was 

{pre markdown_example}

What about a missing snip? Lets try to include one: {monkey}

And an error when running? {bad_dynasnip}

EOF
s1.render_as = "Markdown"
s1.save

bold = Snip.new(:name => "bold")
bold.content =<<EOF
Snip2 in da house!
EOF
bold.render_as = "Bold"
bold.save

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

so, how are you?

- item one
- item two
- item three


what the *hell* are looking at, [beyotch](http://example.com)?
EOF
textile.render_as = "Markdown"
textile.save

dynasnip "pre", <<-EOF
class ShowContentInPreTag
  def handle(snip_name)
    %{<pre>\#{Snip.find_by_name(snip_name).content}</pre>}
  end
end
ShowContentInPreTag
EOF

dynasnip "rand", <<-EOF
class RandomNumber
  def handle(min=1, max=100)
    # arguments come in as strings, so we need to convert them.
    min = min.to_i
    max = max.to_i
    (rand(max-min) + min)
  end
end
RandomNumber
EOF

dynasnip "bad_dynasnip", %{
class BadDynasnip
  def handle(*args)
    raise "Oh no"
  end
end
BadDynasnip}


if __FILE__ == $0
  def render(snip_name, part=nil)
    Render::Base.new.render(snip_name, part)
  end
  
  puts render('start')
end