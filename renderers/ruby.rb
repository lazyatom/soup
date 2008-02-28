require 'render'

module Render
  # Snips that render_as "Ruby" should define a class which has the instance
  # method 'handle' on it.
  # The result of the handle method invocation always has #to_s called on it.
  # The last line of the content should be the name of that class, so that it
  # is returned by "eval" and we can instantiate it.
  # If the dynasnip needs access to the 'context' (i.e. probably the request
  # itself), it should be a subclass of Dynasnip (or define an initializer
  # that accepts the context as its first argument).
  class Ruby < Base
    def process_text(snip, content, args)
      handler_klass = eval(content, binding, snip.name)
      instance = if handler_klass.ancestors.include?(Render::Base)
        handler_klass.new(snip, nil, args, context)
      else
        handler_klass.new
      end
      instance.handle(*args).to_s
    end
  end
end
