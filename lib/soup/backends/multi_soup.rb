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
          if result = backend.__send__(*args)
            return result
          end
        end
        nil
      end

      private

      def all_snips
        @backends.map { |b| b.send(:all_snips) }.flatten
      end

    end
  end
end