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