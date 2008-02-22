def ruby_snip(name, code)
  snip = Snip.new(:name => name)
  snip.content = code
  snip.render_as = "Ruby"
  snip.save
end

ruby_snip "snip_creator", %{
class SnipCreator
  def handle(*args)
    # We really need this to simple load attributes from some request
    # object, and then create the snip
    Snip.new(params).save
  end
end
SnipCreator
}