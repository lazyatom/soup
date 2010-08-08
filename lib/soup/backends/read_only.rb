class Soup
  module Backends
    class ReadOnly < Base
      def initialize(backend)
        @backend = backend
      end

      def save_snip(*args)
        false
      end

      def method_missing(*args)
        @backend.__send__(*args)
      end
    end
  end
end