require File.join(File.dirname(__FILE__), *%w[snip_helper])

dynasnip "edit_link", %{
class EditSnipLink
  def handle(snip_name, link_text)
    ::Router.edit_link(snip_name, link_text)
  end
end
EditSnipLink}

dynasnip "link_to", %{
class Linker
  def handle(snip_name)
    if Snip[snip_name]
      ::Router.link_to(snip_name)
    else
      ::Router.new_link(snip_name)
    end
  end
end
Linker}

dynasnip "url_to", %{
  class UrlTo
    def handle(snip_name)
      if Snip[snip_name]
        ::Router.url_to(snip_name)
      else
        "[Snip '\#{snip_name}' not found]"
      end
    end
  end
  UrlTo  
}

# The edit dyna will load the snip given in the 'snip_to_edit' part of the
# params
dynasnip "edit", %{
  class EditSnip < Dynasnip
    def handle(*args)
      prevent_snip_inclusion(Render.render_without_including_snips('edit', :template, [], context, Render::Erb))
    end
  end
  EditSnip
}, :template => %{
  <form action="<%= ::Router.url_to "save" %>">
  <dl>
    <% snip_to_edit = Snip[context[:snip_to_edit]] %>
    <% snip_to_edit.attributes.each do |name, value| %>
    <dt><%= name %></dt>
    <% num_rows = value.split("\n").length + 1 %>
    <dd><textarea name="<%= name %>" rows="<%= num_rows %>"><%=h value %></textarea></dd>
    <% end %>
  </dl>
  <button name='save_button'>Save</button>
  </form>
}, :render_as => "Ruby"

snip "blank", ""

dynasnip "new", %{
class NewSnip < Dynasnip
  def handle(*arg)
    Render.render('edit', :template, [], context.merge(:snip_to_edit => 'blank'), Render::Erb)
  end
end
NewSnip
}

# If the dynasnip is a subclass of Dynasnip, it has access to the request hash
# (or whatever - access to some object outside of the snip itself.)
dynasnip "debug", %{
class Debug < Dynasnip
  def handle(*args)
    # context.inspect
    puts "snip: " + @snip.inspect
    puts "part: " + @part.inspect
    puts "context: " + @context.inspect
    context.inspect
  end
end
Debug}

dynasnip "current_snip", %{
  class CurrentSnip < Dynasnip
    def handle(*args)
      if args[0] == 'name'
        context[:snip]
      else
        Render.render(context[:snip], context[:part], args, context)
      end
    end
  end
  CurrentSnip
}

system = Snip.new(:name => "system")
system.content = "You're in the system snip now. You probably want to {edit_link system,edit} it though."

system.main_template = <<-HTML
<html>
<head>
  <title>{current_snip name}</title>
  <link rel="stylesheet" type="text/css" media="screen"  href="<%= Router.url_to_raw("system", "css") %>" />
</head>
<body>
  <div id="content">
    <div id="controls">
      <strong><a href="/">home</a></strong>, 
      <%= ::Router.new_link %> ::
      <strong><%= @snip.name %></strong> &rarr; 
      <%= ::Router.edit_link("{current_snip name}", "Edit") %>
    </div>
    {current_snip}
  </div>
</body>
</html>
HTML

dynasnip "save", <<-EOF
class Save < Dynasnip
  def handle(*args)
    snip_attributes = context.dup
    snip_attributes.delete(:save_button)
    snip_attributes.delete(:snip)
    snip_attributes.delete(:format)
    
    return 'no params' if snip_attributes.empty?
    snip = Snip[snip_attributes[:name]]
    snip_attributes.each do |name, value|
      snip.__send__(:set_value, name, value)
    end
    snip.save
    %{Saved snip \#{::Router.link_to snip_attributes[:name]} ok}
  rescue Exception => e
    p snip_attributes
    Snip.new(snip_attributes).save
    %{Created snip \#{::Router.link_to snip_attributes[:name]} ok}
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
  puts Snip['system'].main_template
end