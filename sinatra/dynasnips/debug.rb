# If the dynasnip is a subclass of Dynasnip, it has access to the request hash
# (or whatever - access to some object outside of the snip itself.)
dynasnip "debug", %{
class Debug < Dynasnip
  def handle(*args)
    context.inspect
  end
end
Debug}