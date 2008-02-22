$LOAD_PATH << "lib"
$LOAD_PATH.uniq!

require 'soup'
require 'render'

dynasnip "edit_link", %{
class EditSnipLink
  def handle(snip_name, link_text)
    %[<a href="/\#{snip_name}/edit">\#{link_text}</a>]
  end
end
EditSnipLink}

dynasnip "link_to", <<-EOF
class Linker
  def handle(snip_name)
    %{<a href="/\#{snip_name}">\#{snip_name}</a>}
  end
end
Linker
EOF

system = Snip.new(:name => "system")
system.content = <<-EOF
  You're in the system snip now. You probably want to {edit_link system,edit} it though
EOF

system.main_template = <<-HTML
<html>
<head>
  <title><%= @snip_name %></title>
  <link rel="stylesheet" type="text/css" media="screen"  href="/system/css" />
</head>
<body>
  <div id="content">
    <div id="controls"><strong><%= @snip_name %></strong>&rarr;<a href="/<%= @snip_name %>/edit">Edit</a></div>
    <%= @rendered_snip %>
  </div>
</body>
</html>

HTML

system.edit_template = <<-HTML
<html>
<head>
  <title>Editing '<%= @snip_name %>'</title>
  <link rel="stylesheet" type="text/css" media="screen"  href="/system/css" />
</head>
<body>
  <div id="content">
    <div id="controls"><a href="/<%= @snip.name %>"><%= @snip.name %></a>&rarr;<strong>Editing '<%= @snip.name %>'</strong></div>
    <dl>
      <% @snip.attributes.each do |name, value| %>
      <dt><%= name %></dt>
      <dd><textarea><%= value %></textarea></dd>
      <% end %>
      <dt><input type="text"></input></dt>
      <dd><textarea></textarea></dd>
    </dl>
  </div>
</body>
</html>
HTML

system.css = <<-CSS
body {
  font-family: Helvetica;
  background-color: #666;
  margin: 0;
  padding: 0;
}

div#content {
  width: 600px;
  margin: 0 auto;
  background-color: #fff;
  padding: 1em;
}

div#controls {
font-size: 80%;
padding-bottom: 1em;
margin-bottom: 1em;
border-bottom: 1px solid #999;
}

textarea {
  width: 100%;
  height: 10em;
}
CSS


system.save

if __FILE__ == $0
  puts Snip.find_by_name('system').main_template
end