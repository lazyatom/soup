require 'soup/empty_class'

class Soup
  class Snip < Soup::EmptyClass
    attr_reader :attributes

    def initialize(attributes, backend)
      @attributes = attributes
      @backend = backend
    end

    def save
      @backend.save_snip(@attributes)
      self
    end

    def destroy
      @backend.destroy(self.name)
      self
    end

    def inspect
      "<Snip name:#{self.name}>"
    end

    def respond_to?(method)
      @attributes.keys.include?(method.to_s)
    end

    def method_missing(method, *args)
      value = args.length > 1 ? args : args.first
      if method.to_s =~ /(.*)=\Z/
        @attributes[$1.to_sym] = value
      else
        @attributes[method]
      end
    end
  end
end
