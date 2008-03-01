dynasnip "current_snip", %{
  class CurrentSnip < Dynasnip
    def handle(*args)        
      if args[0] == 'name'
        if context[:snip] == 'edit' # we're editing so don't use this name
          context[:snip_to_edit]
        else
          context[:snip]
        end
      else
        Render.render(context[:snip], context[:part], args, context)
      end
    end
    
  end
  CurrentSnip
}