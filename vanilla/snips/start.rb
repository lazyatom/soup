start = Snip.new(:name => 'start')
start.content = <<-START
This is the start snip, which forms the home page.

You might want to check out the {link_to test} snip. In fact - I'll include it here for you.

---

{test}

---

Anyway, welcome.
START
start.render_as = "Markdown"
start.save