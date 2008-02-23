$LOAD_PATH << "lib"
$LOAD_PATH.uniq!

require 'soup'
require 'render'

dynasnip "edit_link", %{
class EditSnipLink
  def handle(snip_name, link_text)
    Router.edit_link(snip_name, link_text)
  end
end
EditSnipLink}

dynasnip "link_to", %{
class Linker
  def handle(snip_name)
    if Snip.find_by_name(snip_name).nil?
      Router.new_link(snip_name)
    else
      Router.link_to(snip_name)
    end
  end
end
Linker}

dynasnip "debug", %{
class Debug
  def handle(*args)
    $params.inspect
  end
end
Debug}

system = Snip.new(:name => "system")
system.content = "You're in the system snip now. You probably want to {edit_link system,edit} it though."

system.main_template = <<-HTML
<html>
<head>
  <title><%= @snip.name %></title>
  <link rel="stylesheet" type="text/css" media="screen"  href="<%= Router.url_to("system", "css") %>" />
</head>
<body>
  <div id="content">
    <div id="controls">
      <strong><a href="/">home</a></strong>, 
      <%= Router.new_link %> ::
      <strong><%= @snip.name %></strong> &rarr; 
      <%= Router.edit_link(@snip.name, "Edit") %>
    </div>
    <%= @rendered_snip %>
  </div>
</body>
</html>

HTML

system.edit_template = <<-HTML
<html>
<head>
  <title>Editing '<%= @snip.name %>'</title>
  <link rel="stylesheet" type="text/css" media="screen"  href="<%= Router.url_to("system", "css") %>" />
</head>
<body>
  <div id="content">
    <div id="controls">
      <strong><a href="/">home</a></strong>, 
      <%= Router.new_link %> ::
      <%= Router.link_to @snip.name %> &rarr; 
      <strong>Editing '<%= @snip.name %>'</strong>
    </div>
    <form action="<%= Router.url_to "save" %>">
    <dl>
      <% @snip.attributes.each do |name, value| %>
      <dt><%= name %></dt>
      <% num_rows = value.split("\n").length + 1 %>
      <dd><textarea name="<%= name %>" rows="<%= num_rows %>"><%= value %></textarea></dd>
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
    
    return 'no params' if snip_attributes.empty?
    snip = Snip.find_by_name(snip_attributes[:name])
    snip_attributes.each do |name, value|
      snip.__send__(:set_value, name, value)
    end
    snip.save
    %{Saved snip \#{Router.link_to snip_attributes[:name]} ok}
  rescue Exception => e
    p snip_attributes
    Snip.new(snip_attributes).save
    %{Created snip \#{Router.link_to snip_attributes[:name]} ok}
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
}

pre {
  background-color: #f6f6f6;
  border: 1px solid #ccc;
  padding: 1em;
}

a.new {
  background-color: #f0f0f0;
  text-decoration: none;
  color: #999;
  padding: 0.2em;
}

a.new:hover {
  text-decoration: underline;
}
CSS


system.save

if __FILE__ == $0
  puts Snip.find_by_name('system').main_template
end