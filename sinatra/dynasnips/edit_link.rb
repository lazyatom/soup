dynasnip "edit_link", %{
class EditSnipLink
  def handle(snip_name, link_text)
    ::Router.edit_link(snip_name, link_text)
  end
end
EditSnipLink}