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