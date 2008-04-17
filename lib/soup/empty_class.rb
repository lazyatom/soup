# Based on Builder's BlankSlate object
module Soup
  class EmptyClass
    instance_methods.each { |m| undef_method(m) unless m =~ /^(__|instance_eval|respond_to\?)/ }
  end
end