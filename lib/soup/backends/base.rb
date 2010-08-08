class Soup
  module Backends
    class Base
      def find(conditions)
        if conditions.keys == [:name]
          load_snip(conditions[:name])
        else
          all_snips.select do |s|
            conditions.inject(true) do |matches, (key, value)|
              matches && (s.__send__(key) == value)
            end
          end
        end
      end
    end
  end
end