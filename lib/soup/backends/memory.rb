class Soup
  module Backends
    class Memory < Base
      def prepare
        @snips = {}
      end

      def save_snip(attributes)
        @snips[attributes[:name]] = Snip.new(attributes, self)
      end

      def all_snips
        @snips.values
      end

      def load_snip(name)
        @snips[name]
      end

      def destroy(name)
        @snips[name] = nil
      end
    end
  end
end