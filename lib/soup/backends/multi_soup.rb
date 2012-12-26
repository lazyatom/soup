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
          if backend.respond_to?(args.first)
            result = backend.__send__(*args)
            return result if result
          end
        end
        nil
      end

      def respond_to?(method)
        super || @backends.inject(false) { |ok, b| ok || b.respond_to?(method) }
      end

      def all_snips
        @backends.map { |b| b.all_snips }.flatten
      end
    end
  end
end
