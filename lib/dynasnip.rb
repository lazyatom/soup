class Dynasnip
  attr_reader :request
  
  def initialize(request)
    @request = request
  end
end