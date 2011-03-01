class Soup
  module Backends
    class MultiSoup < Base
      def initialize(*backends)
        @backends = backends
      end

      def prepare
        @backends.each { |b| b.prepare }
      end

      def method_missing(*args)
        @backends.each do |backend|
          if result = backend.respond_to?(args.first) ? backend.__send__(*args) : nil
            return result
          end
        end
        nil
      end

      def all_snips
        @backends.map { |b| b.all_snips }.flatten
      end
    end
  end
end