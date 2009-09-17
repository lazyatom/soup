require 'soup/empty_class'

class Snip < Soup::EmptyClass

  def initialize(attributes = {}, soup = Soup)
    @attributes = attributes
    @soup = soup
  end

  def save
    @soup << @attributes
    self
  end

  def destroy
    @soup.destroy(self.name)
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
      @attributes[$1] = value
    else
      @attributes[method]
    end
  end

end
