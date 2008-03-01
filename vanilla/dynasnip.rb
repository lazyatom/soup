require File.join(File.dirname(__FILE__), *%w[.. render])

class Dynasnip < Render::Base
  # dynasnips gain access to the context in the same way as Render::Base
  # subclasses
end