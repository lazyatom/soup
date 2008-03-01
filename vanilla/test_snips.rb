require File.join(File.dirname(__FILE__), *%w[snip_helper])

test = Snip.new(:name => "test")
test.content =<<EOF
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

How about some {link_to debug} information: {debug}

What about a missing snip? Lets try to include one: {monkey}

And an error when running? {bad_dynasnip}

EOF
test.render_as = "Markdown"
test.save

bold = Snip.new(:name => "bold")
bold.content =<<EOF
Snip2 in da house!
EOF
bold.render_as = "Bold"
bold.save

textile = Snip.new(:name => "textile_example")
textile.content =<<EOF

# testing lists
# because lists are common things

monkey

what the *hell* are __you__ looking at?

"Beyotch":http://example.com

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

dynasnip "bad_dynasnip", %{
class BadDynasnip
  def handle(*args)
    raise "Oh no"
  end
end
BadDynasnip}