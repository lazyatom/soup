# Based on Builder's BlankSlate object
class Soup
  class EmptyClass
    instance_methods.each { |m| undef_method(m) unless m =~ /^(is_a\?|__|object_id|instance_eval|respond_to\?)/ }
  end
end