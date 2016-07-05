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

    def ==(other)
      other.is_a?(Snip) && matching_attributes(other)
    end

    def eql?(other)
      self == other
    end

    def inspect
      keys = @attributes.keys.dup
      keys.delete(:name)
      attrs = keys.inject([[:name, self.name]]) { |a, key| a + [[key, @attributes[key]]] }
      "<Snip #{attrs.map { |(key,value)| "#{key}:#{value.inspect}"}.join(" ")}>"
    end

    def hash
      @attributes.hash
    end

    def respond_to?(method, include_all=false)
      @attributes.keys.any? { |k| k.to_s == method.to_s }
    end

    def method_missing(method, *args)
      value = args.length > 1 ? args : args.first
      if method.to_s =~ /(.*)=\Z/
        @attributes[$1.to_sym] = value
      else
        @attributes[method]
      end
    end

    private

    def matching_attributes(other)
      my_attributes = self.attributes.dup
      their_attributes = other.attributes.dup
      [:created_at, :updated_at].each do |attribute_to_ignore|
        my_attributes.delete(attribute_to_ignore)
        their_attributes.delete(attribute_to_ignore)
      end
      my_attributes == their_attributes
    end
  end
end
