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
        @backend.__send__(*args) if @backend.respond_to?(args.first)
      end
    end
  end
end