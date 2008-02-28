module Render
  class Raw < Base
    def render
      @snip.__send__(@part)
    end
  end
end