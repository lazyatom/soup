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