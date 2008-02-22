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

dynasnip "debug", <<-EOF
class Debug
  def handle(*args)
    $params.inspect
  end
end
Debug
EOF

system = Snip.new(:name => "system")
system.content = <<-EOF
  You're in the system snip now. You probably want to {edit_link system,edit} it though
EOF

system.main_template = <<-HTML
<html>
<head>
  <title><%= @snip.name %></title>
  <link rel="stylesheet" type="text/css" media="screen"  href="/system/css" />
</head>
<body>
  <div id="content">
    <div id="controls"><strong><%= @snip.name %></strong>&rarr;<a href="/<%= @snip.name %>/edit">Edit</a>; <a href="/new">New</a></div>
    <%= @rendered_snip %>
  </div>
</body>
</html>

HTML

system.edit_template = <<-HTML
<html>
<head>
  <title>Editing '<%= @snip.name %>'</title>
  <link rel="stylesheet" type="text/css" media="screen"  href="/system/css" />
</head>
<body>
  <div id="content">
    <div id="controls"><a href="/<%= @snip.name %>"><%= @snip.name %></a>&rarr;<strong>Editing '<%= @snip.name %>'</strong>; <a href="/new">New</a></div>
    <form action="/save">
    <dl>
      <% @snip.attributes.each do |name, value| %>
      <dt><%= name %></dt>
      <dd><textarea name="<%= name %>"><%= value %></textarea></dd>
      <% end %>
    </dl>
    <button name='save_button'>Save</button>
    </form>
  </div>
</body>
</html>
HTML

dynasnip "save", <<-EOF
class Save
  def handle(*args)
    snip_attributes = $params.dup
    snip_attributes.delete(:save_button)
    snip_attributes.delete(:snip)
    snip_attributes.delete(:format)
    
    return 'no params' if snip_attributes.nil?
    p snip_attributes[:name]
    snip = Snip.find_by_name(snip_attributes[:name])
    snip_attributes.each do |name, value|
      puts "setting \#{name} as \#{value}"
      snip.__send__(:set_value, name, value)
    end
    snip.save
    "Saved snip '\#{snip_attributes[:name]}' ok"    
  rescue Exception => e
    p e
    Snip.new(snip_attributes).save
    "Created snip '\#{snip_attributes[:name]}' ok"
  end
end
Save  
EOF

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