dynasnip "save", <<-EOF
class Save < Dynasnip
  def handle(*args)
    snip_attributes = context.dup
    snip_attributes.delete(:save_button)
    snip_attributes.delete(:snip)
    snip_attributes.delete(:format)
    
    return 'no params' if snip_attributes.empty?
    snip = Snip[snip_attributes[:name]]
    snip_attributes.each do |name, value|
      snip.__send__(:set_value, name, value)
    end
    snip.save
    %{Saved snip \#{::Router.link_to snip_attributes[:name]} ok}
  rescue Exception => e
    p snip_attributes
    Snip.new(snip_attributes).save
    %{Created snip \#{::Router.link_to snip_attributes[:name]} ok}
  end
end
Save  
EOF