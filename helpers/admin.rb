module Sinatra
  module AdminHelper
    def get_properties(model)
      Object.const_get(model).send('properties').map { |p| p.name }
    end

    def property_map(props, obj)
      props.reduce({}) { |m,a| m.merge!(a => obj.send(a)) }
    end

    def menu_select
      Menu.all(:order => [:name.asc]).reduce("") do |ops, menu|
        ops += "<option value=#{menu.id}>#{menu.name}</option>"
      end
    end
  end
  helpers AdminHelper
end
